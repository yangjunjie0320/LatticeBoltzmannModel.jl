using LatticeBoltzmannModel
using Documenter

DocMeta.setdocmeta!(LatticeBoltzmannModel, :DocTestSetup, :(using LatticeBoltzmannModel); recursive=true)

makedocs(;
    modules=[LatticeBoltzmannModel],
    authors="Junjie Yang <yangjunjie0320@gmail.com> and contributors",
    sitename="LatticeBoltzmannModel.jl",
    format=Documenter.HTML(;
        canonical="https://yangjunjie0320.github.io/LatticeBoltzmannModel.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/yangjunjie0320/LatticeBoltzmannModel.jl",
    devbranch="main",
)
