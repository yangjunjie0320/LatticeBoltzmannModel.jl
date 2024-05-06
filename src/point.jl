"""
    Point{D, T}

    A point in `D`-dimensional space with coordinates of type `T`.
"""
struct Point{D, T<:Real}
    coord::NTuple{D, T}
end

const Point2D{T<:Real} = Point{2, T}
const Point3D{T<:Real} = Point{3, T}

Point(x::Real...) = Point((x...,))

LinearAlgebra.norm(p::Point) = sum(abs2, p.coord) |> sqrt
LinearAlgebra.dot(p1::Point, p2::Point) = sum(p1.coord .* p2.coord)
distance(p1::Point, p2::Point) = LinearAlgebra.norm(p1 - p2)

# Elementwise operations
Base.:+(p1::Point, p2::Point) = Point(p1.coord .+ p2.coord)
Base.:-(p1::Point, p2::Point) = Point(p1.coord .- p2.coord)

# Scalar multiplication
Base.:*(a::Real, p::Point) = Point(a .* p.coord)
Base.:*(p::Point, a::Real) = Point(a .* p.coord)
Base.:/(p::Point, a::Real) = Point(p.coord ./ a)

Base.isapprox(p1::Point, p2::Point; kwargs...) = isapprox.(p1.coord, p2.coord; kwargs...) |> all
Base.getindex(p::Point, i::Int) = p.coord[i]
Base.broadcastable(p::Point) = p.coord
Base.iterate(p::Point, args...) = iterate(p.coord, args...)

Base.zero(::Type{Point{D, T}}) where {D, T} = Point(zero(T) for _ in 1:D)
Base.zero(::Point{D, T}) where {D, T} = zero(Point{D, T})

