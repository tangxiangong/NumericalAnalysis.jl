"""
非线性方程求根
"""
module NonLinearSolve
export bisection, fixedpoint

"""
二分法
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
不动点
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

end