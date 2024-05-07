# [Step 1] Define the boltzmann model 
"""
    AbstractLatticeBoltzmannConfiguration{D, N}

An abstract type representing a lattice Boltzmann configuration 
in `D` dimensions with `N` velocities.
"""
abstract type AbstractLatticeBoltzmannConfiguration{D, N} end

"""
    D2Q9 <: AbstractLatticeBoltzmannConfiguration{2, 9}

D2Q9 lattice Boltzmann model, which is defined in 2-dimensional space,
and has 9 velocities.
"""
struct D2Q9 <: AbstractLatticeBoltzmannConfiguration{2, 9} end

# `directions` returns the all the directions
function directions(::D2Q9) :: NTuple{9, Point2D}
    return (
        Point( 1,  1), Point(-1,  1),
        Point( 1,  0), Point( 0, -1),
        Point( 0,  0), Point( 0,  1),
        Point(-1,  0), Point( 1, -1),
        Point(-1, -1)
    )
end

function weights(::D2Q9) :: NTuple{9, Float64}
    return (
        1/36, 1/36, 
        1/9,   1/9,   
        4/9,   1/9, 
        1/9,  1/36, 
        1/36
        )
end

# [Step 2] Define the Cell type for storing the state
# directions[k] is the opposite of directions[flip_direction_index(k)
function flip_direction_index(::D2Q9, i::Int)
    return 10 - i
end

# the density of the fluid, each component is the density of a velocity
struct Cell{N, T <: Real}
    density::NTuple{N, T}
end

Base.isapprox(c1::Cell, c2::Cell; kwargs...) = isapprox.(c1.density, c2.density; kwargs...) |> all

# the total density of the fluid
density(c::Cell) = sum(c.density)

# the density of the fluid in a specific direction,
# where the direction is an integer
density(c::Cell, direction::Int) = c.density[direction]

"""
    get_momentum(config::AbstractLBConfig, c::Cell)

Compute the momentum of the fluid from the density of the fluid.
"""
function get_momentum(config::AbstractLatticeBoltzmannConfiguration, c::Cell)
    return mapreduce(
        (r, d) -> r * d, +, c.density, directions(config)
    ) / density(c)
end
Base.:+(c1::Cell, c2::Cell) = Cell(c1.density .+ c2.density)
Base.:*(a::Real, c::Cell) = Cell(a .* c.density)

"""
    get_equilibrium_cell(config::AbstractLatticeBoltzmannConfiguration, rho, u)

Compute the equilibrium density of the fluid from the total density and momentum.
"""
function get_equilibrium_cell(
    config::AbstractLatticeBoltzmannConfiguration{<:Any, N},
    rho, u
) where {N}
    return Cell(
        map((w, d) -> rho * w * (1 + 3 * dot(u, d) + 9 / 2 * dot(u, d)^2 - 3 / 2 * dot(u, u)),
            weights(config), directions(config))
        )
end

# streaming step
function stream(
    config::AbstractLatticeBoltzmannConfiguration{2, N},
    grid_old::AbstractMatrix{C}, barrier::AbstractMatrix{Bool}, 
    # grid_new::AbstractMatrix{C} # output FIXME: what is the best practice?
) where {N, C}
    grid_new = similar(grid_old)

    @inbounds for ci in CartesianIndices(grid_old)
        i, j = ci.I

        # generate the cell from the old grid
        t = ntuple(N) do k
            dk = directions(config)[k]
            m, n = size(grid_old)
            i2 = mod1(i - dk[1], m)
            j2 = mod1(j - dk[2], n)
            
            if barrier[i2, j2]
                density(grid_old[i, j], flip_direction_index(config, k))
            else
                density(grid_old[i2, j2], k)
            end
        end

        grid_new[ci] = Cell(t)
    end

    return grid_new
end

# collision step, applied on a single cell
function collide(config::AbstractLatticeBoltzmannConfiguration{D, N}, c::Cell; viscosity = 0.02) where {D, N}
    omega = 1 / (3 * viscosity + 0.5)

    # Recompute macroscopic quantities:
    p = get_momentum(config, c)
    
    return (1 - omega) * c + omega * get_equilibrium_cell(config, density(c), p)
end

"""
    curl(u::AbstractMatrix{Point2D{T}})

Compute the curl of the momentum field in 2D.
"""
function curl(u::Matrix{Point2D{T}}) where T 
    return map(CartesianIndices(u)) do ci
        i, j = ci.I
        m, n = size(u)
        uy = u[mod1(i + 1, m), j][2] - u[mod1(i - 1, m), j][2]
        ux = u[i, mod1(j + 1, n)][1] - u[i, mod1(j - 1, n)][1]
        return uy - ux
    end
end

"""
    LatticeBoltzmann{D, N, T, C, M, B}

A lattice Boltzmann simulation with D dimensions, N velocities, and lattice configuration CFG.

### Fields
- `config::C`: lattice Boltzmann configuration
- `grid_cur::M`: current grid
- `grid_old::M`: old grid
- `barrier::B`: barrier matrix
"""
mutable struct LatticeBoltzmann{D, N, T, C<:AbstractLatticeBoltzmannConfiguration{D, N}, M<:AbstractMatrix{Cell{N, T}}, B<:AbstractMatrix{Bool}}
    config::C
    grid_cur::M
    grid_old::M
    barrier::B
end

function LatticeBoltzmann(config::AbstractLatticeBoltzmannConfiguration{D, N}, grid::AbstractMatrix{<:Cell}, barrier::AbstractMatrix{Bool}) where {D, N}
    @assert size(grid) == size(barrier)
    return LatticeBoltzmann(config, grid, similar(grid), barrier)
end

"""
    step!(lb::LatticeBoltzmann)

Perform a single step of the lattice Boltzmann simulation.
"""
function step!(lb::LatticeBoltzmann)
    lb.grid_old = lb.grid_cur
    # copyto!(lb.grid_old, lb.grid_cur)
    
    lb.grid_cur = stream(lb.config, lb.grid_old, lb.barrier)
    # stream!(lb.config, lb.grid, lb.gridcache, lb.barrier)

    lb.grid_cur = collide.(Ref(lb.config), lb.grid_cur)
    return lb
end

"""
    example_d2q9(; height = 80, width = 200, u0 = Point(0.0, 0.1))

A D2Q9 lattice Boltzmann simulation example. A simple linear barrier is added to the lattice.

### Arguments
- `height::Int`: height of the lattice
- `width::Int`: width of the lattice
- `u0::Point2D`: initial and in-flow speed
"""
function example_d2q9(; 
        ncol = 80, nrow = 200, # lattice dimensions
        u0 = Point(0.0, 0.1)   # initial and in-flow speed
    )
    # Initialize all the arrays to steady rightward flow:
    c0 = get_equilibrium_cell(D2Q9(), 1.0, u0)
    g0 = fill(c0, ncol, nrow)

    # Initialize barriers:
    b = falses(ncol, nrow)
    m1, m2 = (m -> (m-8, m+8))(div(ncol, 2))
    b[m1:m2, div(ncol,2)] .= true

    return LatticeBoltzmann(D2Q9(), g0, b)
end