module NonLinearSolve
export bisection, fixedpoint, newton

"""
    bisection(func::Function, domain::Tuple{<:Real, <:Real}, ε::Float64=1e-8)

二分法求解函数 `func` 的位于区间 `domain` 的根, 停机准则误差为 `ε`.
"""
function bisection(func::Function, domain::Tuple{<:Real, <:Real}, ε::Float64=1e-8)
    a, b = domain    
    a < b || throw(ArgumentError("左端点, 右端点"))
    func(a)*func(b) < 0 || throw(ArgumentError("两个端点处的值需为异号"))
    mid = (a+b)/2
    while abs(func(mid)) > ε
        sign(func(a)) == sign(func(mid)) ? a = mid : b = mid
        mid = (a+b)/2
    end
    return mid
end

"""
    fixedpoint(func::Function, init_point::Real; iter_func::Union{Function, Nothing}=nothing, iter_atol::Float64=1e-8, maxiter::Int=10_000)

不动点迭代求解多项式 `func` 的根, `init_point` 为迭代的初始值, `iter_func` 为迭代函数, 若未给定, 则默认为 `x-func(x)`, `iter_atol` 为停机准则误差, `maxiter` 为最大迭代步数.
"""
function fixedpoint(func::Function, init_point::Real; iter_func::Union{Function, Nothing}=nothing, iter_atol::Float64=1e-8, maxiter::Int=10_000)
    g = isnothing(iter_func) ?  x -> x - func(x) : iter_func
    x = init_point
    for _ in 1:maxiter
        x = g(x)
        isapprox(func(x), 0, atol=iter_atol) && return x
    end
    throw(AssertionError("超过设置的迭代最大阈值, 请调整迭代初值或迭代函数"))
end

import Symbolics:@variables, Differential, substitute, expand_derivatives, value
"""
    newton(f::Function, x₀::Real; df::Union{Nothing, Function}=nothing, atol::Float64=1e-8, maxiter::Integer=10_000)

牛顿迭代法求解函数 `f` 的根, `x₀` 为迭代的初始值, `df` 为函数 `f` 的导函数, 如果没有提供导函数, 就尝试使用符号计算 (`Symbolics.jl`) 求出导函数, `atol` 为停机准则误差, `maxiter` 为最大迭代步数.
"""
function newton(f::Function, x₀::Real; df::Union{Nothing, Function}=nothing, atol::Float64=1e-8, maxiter::Integer=10_000)
    if isnothing(df)
        try
            @variables t
            D = Differential(t)
            Df = expand_derivatives(D(f(t)))
            df = x->(substitute.(Df, (Dict(t=>x),))[1] |> value)
        catch  
            throw(ArgumentError("请提供导函数!"))
        end
    end
    for _ in 1:maxiter
        x₀ = x₀-f(x₀)/df(x₀)
        abs(f(x₀)) <= atol && return x₀
        x₀ = x₀-f(x₀)/df(x₀)
    end
end 
end