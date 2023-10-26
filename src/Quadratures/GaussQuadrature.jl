module GaussQ
    import ..Quadrature:Integrand, WeightsNodes
    import Base:*
    function *(I::Integrand, dx::WeightsNodes)
        weights, nodes = dx.weights, dx.nodes
        func = I.name
        s = 0.0
        for k in eachindex(nodes)
            s += weights[k] * func(nodes[k])
        end
        s
    end
end



# # Gauss-Legendra 测试
# # 被积函数
# f(x) = x^5
# # Legendra 多项式次数
# order = 10
# # 数值积分
# dx = discretization((0, 1), 5, mode=:legendra)
# @show ∫(f)*dx
# method=:Legendre
# poly = Symbol("guass", lowercase(String(method)))
# w, b = Expr(:call, poly, 10) |> eval

# macro orthpoly(method, degree)
#     func = Symbol("gauss", lowercase(String(method)))
#     return Expr(:call, func, degree)
# end
