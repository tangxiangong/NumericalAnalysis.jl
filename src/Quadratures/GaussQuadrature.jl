module GaussQ
    import ..Quadrature:Integrand, WeightsNodes
    """
    Gauss 积分公式.

    # 例子
    ```julia
    domain = (0, 1)    # 积分区间
    order = 10         # 多项式次数
    dx = discretization(domain, order) 
    f(x) = ... 
    I = ∫(f)*dx        # 数值积分结果
    ```
    """
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