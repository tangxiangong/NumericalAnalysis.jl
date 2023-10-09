"""
    Polynomial{<:Real}(coe::Vector{<:Real}, var::Symbol)

(实)多项式类
"""
struct Polynomial{T <: Real}
    coe::Vector{<:Real}
    var::Symbol
    function Polynomial{T}(coe::Vector{<:Real}, var::Symbol=:x) where T <: Real
        isempty(coe) && throw(ArgumentError("系数向量不能为空"))
        promote_type(T, eltype(coe)) == T || throw(ArgumentError("系数类型需为多项式类型的子集"))
        if length(coe) > 1
            coe[1] == 0 && throw(ArgumentError("除了 0 多项式, 其它多项式的最高次项系数不能为 0"))
        end
        if T != eltype(coe)
            new{T}(Vector{T}(coe), var)
        else
            new{T}(coe, var)
        end
    end
end
Polynomial(coe::Vector{<:Real}, var::Symbol=:x) = Polynomial{eltype(coe)}(coe, var)

"""
    degree(p::Polynomial)::Int

多项式 `p` 的次数, 0 多项式的次数设为 -1. 
"""
degree(p::Polynomial) :: Int = p.coe[1] == 0 ? -1 : length(p.coe) - 1

"""
将上面求出的多项式次数作为多项式本身的性质
"""
Base.getproperty(p::Polynomial, sym::Symbol) = sym === :degree ? degree(p) : getfield(p, sym)

function Base.show(io::IO, ::MIME"text/plain", p::Polynomial)
    n = degree(p)
    n <= 0 && return print(io, "$(p.coe[1])")
    if n == 1
        str = abs(p.coe[1]) != 1 ? "$(p.coe[1])$(p.var)" : (p.coe[1] == 1 ? "$(p.var)" : "-$(p.var)")
    else
        str = abs(p.coe[1]) != 1 ? "$(p.coe[1])$(p.var)^$n" : (p.coe[1] == 1 ? "$(p.var)^$n" : "-$(p.var)^$n")
    end
    for k in 2:n-1
        p.coe[k] == 0 && continue
        if p.coe[k] > 0 
            str *= "+"
        end
        str *= abs(p.coe[k]) == 1 ? "$(p.var)^$(n-k+1)" : "$(p.coe[k])$(p.var)^$(n-k+1)"
    end
    if n > 1 && p.coe[n] != 0 
        str *= p.coe[n] > 0 ? "+$(p.coe[n])$(p.var)" : "$(p.coe[n])$(p.var)"
    end
    if p.coe[n+1] != 0 
        str *= p.coe[n+1] > 0 ? "+$(p.coe[n+1])" :  "$(p.coe[n+1])"
    end
    return print(io, str)
end

"""
秦九韶算法求多项式值
"""
function eval_poly(p::Polynomial, x::Real)
    coe = p.coe
    p.degree <= 0 && return coe[1]
    result = zero(promote_type(eltype(coe), typeof(x)))
    result += coe[1] * x + coe[2]
    for k=3:p.degree+1
        result = result * x + coe[k]
    end
    return result
end

(p::Polynomial)(x::Real) = eval_poly(p, x)

"""
比较相等
"""
Base.:(==)(p::Polynomial, q::Polynomial) = eltype(p.coe)==eltype(q.coe) && p.coe == q.coe && p.var == q.var

"""
判断 0 多项式
"""
Base.iszero(p::Polynomial) = Base.iszore(p.coe[1])
"""
判断常多项式
"""
isconstant(p::Polynomial) = length(p.coe) == 1

"""
求导
"""
function ∂(p::Polynomial)::Polynomial
    coe = p.coe
    n = p.degree
    isconstant(p) && return Polynomial([zero(eltype(coe))], p.var)
    ncoe = Vector{eltype(coe)}(undef, n)
    for (k, a) in enumerate(@view coe[1:end-1])
        @inbounds ncoe[k] = a * (n-k+1)
    end
    return Polynomial(ncoe, p.var)
end

"""
将向量中第一个非零元素前的元素全部pop
"""
function _popzerofirst!(v::Vector{<:Real})
    temp = findfirst(!iszero, v)
    index = isnothing(temp) ? length(v) : temp
    for _ in 1:index-1
        popfirst!(v)
    end
end

"""
在向量(copy)的头部插入n个0
"""
_insertzerofirst(v::Vector{<:Real}, n::Integer) = n >= 1 ? vcat(zeros(eltype(v), n), v) : throw(ArgumentError("第二个参数为正整数"))

"""
多项式加法
"""
function Base.:+(p::Polynomial, q::Polynomial)    
    p.var == q.var || throw(ArgumentError("两个多项式的自变量要相同"))
    n = length(p.coe)
    m = length(q.coe)
    if n == m
        ncoe = p.coe + q.coe
    elseif n > m
        ncoe = p.coe + _insertzerofirst(q.coe, n-m)
    else
        ncoe = q.coe + _insertzerofirst(p.coe, m-n)
    end
    _popzerofirst!(ncoe)
    return Polynomial(ncoe, p.var)
end
"""
加法逆元
"""
Base.:-(p::Polynomial) = Polynomial(-p.coe, p.var)

"""
多项式减法
"""
Base.:-(p::Polynomial, q::Polynomial) = Base.:+(p, -q)
