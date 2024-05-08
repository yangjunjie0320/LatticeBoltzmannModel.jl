module LatticeBoltzmannModel

    # Import required modules
    using LinearAlgebra

    # Export the Point struct and related functions
    export Point, Point2D, Point3D, Point, distance
    include("point.jl")

    # Export the D2Q9 struct and related functions
    export D2Q9, LatticeBoltzmann, step!
    export get_equilibrium_cell, get_momentum
    export curl, example_d2q9, density
    export Cell, weights, directions, flip_direction_index
    include("fluid.jl")

end
