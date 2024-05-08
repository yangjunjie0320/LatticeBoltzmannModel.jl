using Test, LatticeBoltzmannModel

@testset "point" begin
    include("point.jl")
end

@testset "fluid" begin
    include("fluid.jl")
end
