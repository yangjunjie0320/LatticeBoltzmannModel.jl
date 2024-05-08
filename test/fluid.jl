using Test, LatticeBoltzmannModel

# Test the `directions` function
@testset "directions" begin
    @test directions(D2Q9()) == (
        Point(1, 1), Point(-1, 1),
        Point(1, 0), Point(0, -1),
        Point(0, 0), Point(0, 1),
        Point(-1, 0), Point(1, -1),
        Point(-1, -1)
    )
end

# Test the `weights` function
@testset "weights" begin
    @test weights(D2Q9()) == (
        1/36, 1/36,
        1/9, 1/9,
        4/9, 1/9,
        1/9, 1/36,
        1/36
    )
end

# Test the `flip_direction_index` function
@testset "flip_direction_index" begin
    @test flip_direction_index(D2Q9(), 1) == 9
    @test flip_direction_index(D2Q9(), 5) == 5
    @test flip_direction_index(D2Q9(), 9) == 1
end

# Test the `density` function
@testset "density" begin
    c = Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0))
    @test density(c) == 45.0
    @test density(c, 3) == 3.0
end

# Test the `get_momentum` function
@testset "get_momentum" begin
    config = D2Q9()
    c = Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0))
    @test isapprox(get_momentum(config, c), Point(-2/15, -4/15))
end

# Test the `get_equilibrium_cell` function
@testset "get_equilibrium_cell" begin
    config = D2Q9()
    rho = 1.0
    u = Point(0.0, 0.0)
    expected = Cell((1/36, 1/36, 1/9, 1/9, 4/9, 1/9, 1/9, 1/36, 1/36))
    @test isapprox(get_equilibrium_cell(config, rho, u), expected)
end

# Test the `curl` function
@testset "curl" begin
    u = [
        Point(1.0, 2.0) for _ in 1:3, _ in 1:3
    ]
    expected = zeros(3, 3)
    @test curl(u) == expected
end

@testset "step!" begin
    lb0 = example_d2q9(; u0=Point(0.0, 0.1))
    lb = deepcopy(lb0)
    for i=1:100 step!(lb) end
    # the conservation of mass
    @test isapprox(sum(density.(lb.grid_cur)), sum(density.(lb0.grid_cur)); rtol=1e-4)
    # the conservation of momentum
    mean_u = sum(get_momentum.(Ref(lb.config), lb.grid_cur))/length(lb.grid_cur)
    @test mean_u[2] < 0.1 - 1e-3
end

# Test the `example_d2q9` function
@testset "example_d2q9" begin
    lb = example_d2q9()
    @test size(lb.grid_cur) == (80, 200)
    @test size(lb.barrier) == (80, 200)
end