using Test

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
    @test get_momentum(config, c) == Point(0.0, 0.0)
end

# Test the `get_equilibrium_cell` function
@testset "get_equilibrium_cell" begin
    config = D2Q9()
    rho = 1.0
    u = Point(0.0, 0.0)
    expected = Cell((4/9, 1/9, 1/9, 1/9, 4/9, 1/9, 1/9, 1/9, 4/9))
    @test get_equilibrium_cell(config, rho, u) == expected
end

# Test the `stream` function
@testset "stream" begin
    config = D2Q9()
    grid_old = [
        Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)) for _ in 1:3, _ in 1:3
    ]
    barrier = falses(3, 3)
    grid_new = stream(config, grid_old, barrier)
    expected = [
        Cell((9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0)) for _ in 1:3, _ in 1:3
    ]
    @test grid_new == expected
end

# Test the `collide` function
@testset "collide" begin
    config = D2Q9()
    c = Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0))
    expected = Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0))
    @test collide(config, c) == expected
end

# Test the `curl` function
@testset "curl" begin
    u = [
        Point(1.0, 2.0) for _ in 1:3, _ in 1:3
    ]
    expected = [
        -1.0, -1.0, -1.0,
        -1.0, -1.0, -1.0,
        -1.0, -1.0, -1.0
    ]
    @test curl(u) == expected
end

# Test the `LatticeBoltzmann` struct
@testset "LatticeBoltzmann" begin
    config = D2Q9()
    grid = [
        Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)) for _ in 1:3, _ in 1:3
    ]
    barrier = falses(3, 3)
    lb = LatticeBoltzmann(config, grid, barrier)
    @test lb.config == config
    @test lb.grid_cur == grid
    @test lb.grid_old == grid
    @test lb.barrier == barrier
end

# Test the `step!` function
@testset "step!" begin
    config = D2Q9()
    grid = [
        Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)) for _ in 1:3, _ in 1:3
    ]
    barrier = falses(3, 3)
    lb = LatticeBoltzmann(config, grid, barrier)
    step!(lb)
    expected_grid_cur = [
        Cell((9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0)) for _ in 1:3, _ in 1:3
    ]
    @test lb.grid_cur == expected_grid_cur
end

# Test the `example_d2q9` function
@testset "example_d2q9" begin
    lb = example_d2q9()
    @test size(lb.grid_cur) == (80, 200)
    @test size(lb.barrier) == (80, 200)
end