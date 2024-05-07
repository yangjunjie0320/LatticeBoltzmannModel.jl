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
function directions(::D2Q9) :: Tuple{Point2D}
    return (
        Point( 1,  1), Point(-1,  1),
        Point( 1,  0), Point( 0, -1),
        Point( 0,  0), Point( 0,  1),
        Point(-1,  0), Point( 1, -1),
        Point(-1, -1),
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

# the total density of the fluid
density(c::Cell) = sum(cell.density)
# the density of the fluid in a specific direction,
# where the direction is an integer
density(c::Cell, direction::Int) = c.density[direction]

"""
    get_momentum(lb::AbstractLBConfig, c::Cell)

Compute the momentum of the fluid from the density of the fluid.
"""
function get_momentum(config::AbstractLatticeBoltzmannConfiguration, c::Cell)
    return sum([cd * d for (cd, d) in zip(c.density, config |> directions)])
end

"""
    equilibrium_density(config::AbstractLatticeBoltzmannConfiguration, rho::Real, u::Point)
"""