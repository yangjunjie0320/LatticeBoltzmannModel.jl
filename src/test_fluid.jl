using Test

# Test the directions function
function test_directions()
    config = D2Q9()
    expected = (
        Point( 1,  1), Point(-1,  1),
        Point( 1,  0), Point( 0, -1),
        Point( 0,  0), Point( 0,  1),
        Point(-1,  0), Point( 1, -1),
        Point(-1, -1)
    )
    @test directions(config) == expected
end

# Test the weights function
function test_weights()
    config = D2Q9()
    expected = (
        1/36, 1/36, 
        1/9,   1/9,   
        4/9,   1/9, 
        1/9,  1/36, 
        1/36
    )
    @test weights(config) == expected
end

# Test the flip_direction_index function
function test_flip_direction_index()
    config = D2Q9()
    @test flip_direction_index(config, 1) == 9
    @test flip_direction_index(config, 5) == 5
    @test flip_direction_index(config, 9) == 1
end

# Test the density function
function test_density()
    c = Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0))
    @test density(c) == 45.0
    @test density(c, 1) == 1.0
    @test density(c, 5) == 5.0
    @test density(c, 9) == 9.0
end

# Test the get_momentum function
function test_get_momentum()
    config = D2Q9()
    c = Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0))
    @test get_momentum(config, c) == Point(0.0, 0.0)
end

# Test the get_equilibrium_cell function
function test_get_equilibrium_cell()
    config = D2Q9()
    rho = 1.0
    u = Point(0.0, 0.0)
    expected = Cell((4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0))
    @test get_equilibrium_cell(config, rho, u) == expected
end

# Test the stream function
function test_stream()
    config = D2Q9()
    grid_old = fill(Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)), (3, 3))
    barrier = falses(3, 3)
    grid_new = stream(config, grid_old, barrier)
    expected = (
        Cell((9.0, 1.0, 3.0, 7.0, 5.0, 6.0, 4.0, 8.0, 2.0)),
        Cell((2.0, 8.0, 6.0, 4.0, 5.0, 3.0, 7.0, 1.0, 9.0)),
        Cell((9.0, 1.0, 3.0, 7.0, 5.0, 6.0, 4.0, 8.0, 2.0))
    )
    @test grid_new == expected
end

# Test the collide function
function test_collide()
    config = D2Q9()
    c = Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0))
    expected = Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0))
    @test collide(config, c) == expected
end

# Test the curl function
function test_curl()
    u = [
        Point(1.0, 2.0) Point(2.0, 3.0) Point(3.0, 4.0);
        Point(4.0, 5.0) Point(5.0, 6.0) Point(6.0, 7.0);
        Point(7.0, 8.0) Point(8.0, 9.0) Point(9.0, 10.0)
    ]
    expected = [
        -1.0 -1.0 -1.0;
        -1.0 -1.0 -1.0;
        -1.0 -1.0 -1.0
    ]
    @test curl(u) == expected
end

# Test the LatticeBoltzmann struct
function test_LatticeBoltzmann()
    config = D2Q9()
    grid = fill(Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)), (3, 3))
    barrier = falses(3, 3)
    lb = LatticeBoltzmann(config, grid, barrier)
    @test lb.config == config
    @test lb.grid_cur == grid
    @test lb.grid_old == grid
    @test lb.barrier == barrier
end

# Test the step! function
function test_step()
    config = D2Q9()
    grid = fill(Cell((1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)), (3, 3))
    barrier = falses(3, 3)
    lb = LatticeBoltzmann(config, grid, barrier)
    step!(lb)
    @test lb.grid_old == grid
    @test lb.grid_cur != grid
end

# Test the example_d2q9 function
function test_example_d2q9()
    lb = example_d2q9()
    @test lb.config == D2Q9()
    @test size(lb.grid_cur) == (80, 200)
    @test size(lb.grid_old) == (80, 200)
    @test size(lb.barrier) == (80, 200)
end

# Run all the tests
@testset "Lattice Boltzmann Model Tests" begin
    @testset "AbstractLatticeBoltzmannConfiguration" begin
        @testset "directions" begin
            test_directions()
        end
        @testset "weights" begin
            test_weights()
        end
    end
    @testset "Cell" begin
        @testset "flip_direction_index" begin
            test_flip_direction_index()
        end
        @testset "density" begin
            test_density()
        end
        @testset "get_momentum" begin
            test_get_momentum()
        end
        @testset "get_equilibrium_cell" begin
            test_get_equilibrium_cell()
        end
    end
    @testset "stream" begin
        test_stream()
    end
    @testset "collide" begin
        test_collide()
    end
    @testset "curl" begin
        test_curl()
    end
    @testset "LatticeBoltzmann" begin
        test_LatticeBoltzmann()
    end
    @testset "step!" begin
        test_step()
    end
    @testset "example_d2q9" begin
        test_example_d2q9()
    end
end