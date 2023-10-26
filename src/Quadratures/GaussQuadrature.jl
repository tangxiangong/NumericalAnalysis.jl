using FastGaussQuadrature

"""
Legendra 多项式
"""
struct Legendra degree::Integer end

"""
Gauss 积分中的节点和权重
"""
struct GaussQ
    weights::Vector{Float64}
    nodes::Vector{Float64}
end

function weights_and_nodes(p::Legendra, interval::NTuple{2, Real})
    a, b = interval
    @assert a < b
    nodes_u, weights_u = gausslegendre(p.degree) 
    weights = @. (b-a)*weights_u/2
    nodes = @. (b-a)*nodes_u/2 + (b+a)/2
    return GaussQ(weights, nodes)
end

discretization(interval::NTuple{2, Real}, degree::Integer; mode=:legendra) = weights_and_nodes(Legendra(degree), interval)

struct Integrand name::Function end

∫(func::Function) = Integrand(func)

import Base:*
function *(I::Integrand, dx::GaussQ)
    weights, nodes = dx.weights, dx.nodes
    func = I.name
    s = 0.0
    for k in eachindex(nodes)
        s += weights[k] * func(nodes[k])
    end
    s
end
# # Gauss-Legendra 测试
# # 被积函数
# f(x) = x^5
# # Legendra 多项式次数
# order = 10
# # 数值积分
# dx = discretization((0, 1), 5, mode=:legendra)
# @show ∫(f)*dx