using LatticeBoltzmannModel
using Documenter

DocMeta.setdocmeta!(LatticeBoltzmannModel, :DocTestSetup, :(using LatticeBoltzmannModel); recursive=true)

makedocs(;
    modules=[LatticeBoltzmannModel],
    authors="Junjie Yang <yangjunjie0320@gmail.com> and contributors",
    sitename="LatticeBoltzmannModel.jl",
    format=Documenter.HTML(;
        canonical="https://JunjieYang.github.io/LatticeBoltzmannModel.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JunjieYang/LatticeBoltzmannModel.jl",
    devbranch="main",
)
