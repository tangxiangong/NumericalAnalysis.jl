module Quadrature
    export GaussQ
    export discretization, ∫
    include("utils.jl")
    include("GaussQuadrature.jl")
    include("CompositeQuadrature.jl")
end