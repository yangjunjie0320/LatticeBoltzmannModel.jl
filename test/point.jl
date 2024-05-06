using Test, LatticeBoltzmannModel
using LinearAlgebra

# Define a test set for the Point struct
@testset "Point struct tests" begin
    p = Point(1.0, 2.0, 3.0)
    @test p.coord == (1.0, 2.0, 3.0)
end

# Test cases for norm function
@testset "Norm function tests" begin
    p1 = Point(1.0, 2.0)
    p2 = Point(3.0, 4.0)
    @test isapprox(LinearAlgebra.norm(p1), sqrt(1.0^2 + 2.0^2), atol=1e-6)
    @test isapprox(LinearAlgebra.norm(p2), sqrt(3.0^2 + 4.0^2), atol=1e-6)
end

# Test cases for dot function
@testset "Dot product function tests" begin
    p1 = Point(1.0, 2.0, 3.0)
    p2 = Point(3.0, 4.0, 5.0)
    @test LinearAlgebra.dot(p1, p2) == 1.0 * 3.0 + 2.0 * 4.0 + 3.0 * 5.0
end

# Test cases for distance function
@testset "Distance function tests" begin
    p1 = Point(1.0, 2.0, 3.0)
    p2 = Point(4.0, 5.0, 6.0)
    @test isapprox(distance(p1, p2), LinearAlgebra.norm(Point(3.0, 3.0, 3.0)), atol=1e-6)
end
