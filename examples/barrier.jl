using CairoMakie: RGBA # for visualization
using CairoMakie
using LatticeBoltzmannModel # our package

lb = example_d2q9()
vorticity = Observable(curl(get_momentum.(Ref(lb.config), lb.grid_cur))')
fig, ax, plot = image(vorticity, colormap = :jet, colorrange = (-0.1, 0.1))

barrier_img = map(x -> x ? RGBA(0, 0, 0, 1) : RGBA(0, 0, 0, 0), lb.barrier)
image!(ax, barrier_img')

# Recording the simulation
record(fig, joinpath(@__DIR__, "barrier.mp4"), 1:100; framerate = 10) do i
    for i=1:20 
        step!(lb)
    end
    vorticity[] = curl(get_momentum.(Ref(lb.config), lb.grid_cur))'
end
