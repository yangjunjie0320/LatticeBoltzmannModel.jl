# [Step 1] define the boltzmann model 
"""
    AbstractLatticeBoltzmannConfiguration{D, N}

An abstract type representing a lattice Boltzmann configuration 
in `D` dimensions with `N` velocities.
"""
abstract type AbstractLatticeBoltzmannConfiguration{D, N} end

"""
    D2Q9 <: AbstractLatticeBoltzmannConfiguration{2, 9}

D2Q9 lattice Boltzmann model, which is defined in 2-dimensional space
"""

struct D2Q9 <: AbstractLatticeBoltzmannConfiguration{2, 9} end

# `directions` returns the all the directions