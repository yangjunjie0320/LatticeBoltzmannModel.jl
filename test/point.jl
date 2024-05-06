using Test, LatticeBoltzmannModel
using LinearAlgebra

# Define a test set for the Point struct
@testset "Point struct tests" begin
    p = Point(1.0, 2.0, 3.0)
    println(typeof(p))
    @test p isa Point{3, Float64}
    @test p.coord == (1.0, 2.0, 3.0)

    p = Point(1.0, 2.0)
    @test p isa Point{2, Float64}
    @test p.coord == (1.0, 2.0)
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

# Define a test set for elementwise operations
@testset "Elementwise operations tests" begin
    p1 = Point(1.0, 2.0, 3.0)
    p2 = Point(4.0, 5.0, 6.0)
    
    @test p1 + p2 == Point(1.0+4.0, 2.0+5.0, 3.0+6.0)
    @test p1 - p2 == Point(1.0-4.0, 2.0-5.0, 3.0-6.0)
end

# Test cases for scalar multiplication and division
@testset "Scalar operations tests" begin
    a = 2.0
    p = Point(1.0, 2.0, 3.0)
    
    @test a * p == Point(a*1.0, a*2.0, a*3.0)
    @test p * a == Point(a*1.0, a*2.0, a*3.0)
    @test p / a == Point(1.0/a, 2.0/a, 3.0/a)
end

# Test the isapprox method
@testset "Point isapprox tests" begin
    p1 = Point(1.0, 2.0, 3.0)
    p2 = Point(1.0001, 2.0001, 3.0001)
    p3 = Point(1.1, 2.1, 3.1)

    # Test approximate equality
    @test isapprox(p1, p2; atol=0.0002) == true

    # Test not approximate due to tolerance being too tight
    @test isapprox(p1, p2; atol=0.00001) == false

    # Test not approximate with significantly different points
    @test isapprox(p1, p3) == false
end

# Test the getindex method
@testset "Point getindex tests" begin
    p = Point(4.0, 5.0, 6.0)

    # Test accessing individual coordinates
    @test p[1] == 4.0
    @test p[2] == 5.0
    @test p[3] == 6.0
end

# Test the broadcastable method
@testset "Point broadcastable tests" begin
    p = Point(4.0, 5.0, 6.0)
    @test (p .+ 1.0) == (p.coord .+ 1.0)
end

# Test the iterate method
@testset "Point iterate tests" begin
    p = Point(10.0, 11.0, 12.0)
    iter = iterate(p)

    # Check the first iteration
    @test iter !== nothing && iter[1] == 10.0

    # Check the second iteration using the state from the first
    iter2 = iterate(p, iter[2])
    @test iter2 !== nothing && iter2[1] == 11.0

    # Check the third iteration
    iter3 = iterate(p, iter2[2])
    @test iter3 !== nothing && iter3[1] == 12.0

    # Check the end of iteration
    @test iterate(p, iter3[2]) == nothing
end
