module LatticeBoltzmannModel

    # Import required modules
    using LinearAlgebra

    # Export the Point struct and related functions
    export Point, Point2D, Point3D, Point, distance
    include("point.jl")

    # TODO: Export the Fluid struct and related functions
    include("fluid.jl")

end
