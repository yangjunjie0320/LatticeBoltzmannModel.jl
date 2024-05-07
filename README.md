# LatticeBoltzmannModel

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://yangjunjie0320.github.io/LatticeBoltzmannModel.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://yangjunjie0320.github.io/LatticeBoltzmannModel.jl/dev/)
[![Build Status](https://github.com/yangjunjie0320/LatticeBoltzmannModel.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/yangjunjie0320/LatticeBoltzmannModel.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/yangjunjie0320/LatticeBoltzmannModel.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/yangjunjie0320/LatticeBoltzmannModel.jl)

This package implements [Lattice Boltzmann Model (LBM)](https://physics.weber.edu/schroeder/fluids/) 
for fluid dynamics simulation in `julia`.  The code closely follows the corresponding part in
[Scientific Computing for Physicists](https://github.com/GiggleLiu/ScientificComputingDemos/tree/main/LatticeBoltzmannModel) by [@GiggleLiu](https://github.com/GiggleLiu).

## Contents
* D2Q9 model - a 2D LBM with 9 velocities
* Fluid dynamics visualization

## Get started

Please clone this repository to your local machine, and then run the following commands in the terminal,
```bash
$ make init-LatticeBoltzmannModel  # Initialize the environment
$ make example-LatticeBoltzmannModel  # Run the examples
```