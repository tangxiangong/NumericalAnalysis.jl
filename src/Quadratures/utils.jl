using FastGaussQuadrature

import Base.*

struct Integrand 
    name::Function 
end


# Gauss 积分中的节点和权重
struct WeightsNodes
    weights::Vector{Float64}
    nodes::Vector{Float64}
end

function weights_and_nodes(degree, interval::NTuple{2, Real}; method)
    @assert method in [:Legendre]
    a, b = interval
    @assert a < b
    ex = Expr(:call, Symbol("gauss", lowercase(String(method))), degree)
    nodes_u, weights_u = eval(ex)
    weights = @. (b-a)*weights_u/2
    nodes = @. (b-a)*nodes_u/2 + (b+a)/2
    return WeightsNodes(weights, nodes)
end

discretization(interval::NTuple{2, Real}, degree::Integer; method=:Legendre) = weights_and_nodes(degree, interval; method)

∫(func::Function) = Integrand(func)

function *(I::Integrand, dx::WeightsNodes)
    weights, nodes = dx.weights, dx.nodes
    func = I.name
    s = 0.0
    for k in eachindex(nodes)
        s += weights[k] * func(nodes[k])
    end
    s
end