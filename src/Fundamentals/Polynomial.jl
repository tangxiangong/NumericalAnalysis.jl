@doc raw"""
    Polynomial{T}(coe::Vector{<:Real}, roots::Vector{<:Real}) where T <: Real

(实)多项式类 
```math
p(x)=a_nx^n+a_{n-1}x^{n-1}+\cdots+a_1x+a_0, \quad a_n\neq 0.
```
# 参数
- `T<:Real` : 类型参数, 若没有显式给定, 则隐式地由多项式系数 `coe` 的元素类型决定. 若显式给出, 可与 `coe` 的元素类型不一致, 但必须要有 `promote_type(T, eltype(coe))==T`, 此时将会对 `coe` 做类型提升处理. 
- `coe::Vector{<:Real}` : 多项式的系数 ``[a_n,a_{n-1},\cdots,a_1, a_0]``, 按幂次降序排列, 并且对于非常数多项式要求 `coe[1]` 非零, 即最高次项系数不为零. 
- `roots::Vector{<:Real}` : 多项式的根, 默认为整型空向量

# 例子

"""
struct Polynomial{T <: Real}
    coe::Vector{<:Real}
    roots::Vector{<:Real}
    function Polynomial{T}(coe::Vector{<:Real}, roots::Vector{<:Real}=Vector{Int}()) where T <: Real
        isempty(coe) && throw(ArgumentError("系数向量不能为空"))
        promote_type(T, eltype(coe)) == T || throw(ArgumentError("系数类型需为多项式类型的子集"))
        if length(coe) > 1
            coe[1] == 0 && throw(ArgumentError("除了 0 多项式, 其它多项式的最高次项系数不能为 0"))
        end
        if T != eltype(coe)
            new{T}(Vector{T}(coe), roots)
        else
            new{T}(coe, roots)
        end
    end
end
Polynomial(coe::Vector{<:Real}, roots::Vector{<:Real}=Vector{Int}()) = Polynomial{eltype(coe)}(coe, roots)

"""
    degree(p::Polynomial)::Int

多项式 `p` 的次数, 0 多项式的次数设为 -1. 
"""
degree(p::Polynomial) :: Int = p.coe[1] == 0 ? -1 : length(p.coe) - 1

import Base: getproperty
"""
将上面求出的多项式次数作为多项式本身的性质
"""
@inline getproperty(p::Polynomial, sym::Symbol) = sym === :degree ? degree(p) : getfield(p, sym)

import Base: show
"""
输出
"""
@inline function show(io::IO, ::MIME"text/plain", p::Polynomial)
    n = degree(p)
    var = :x
    coe = p.coe
    n <= 0 && return print(io, "$(coe[1])")
    if n == 1
        str = abs(coe[1]) != 1 ? "$(coe[1])$(var)" : (coe[1] == 1 ? "$(var)" : "-$(var)")
    else
        str = abs(coe[1]) != 1 ? "$(coe[1])$(var)^$n" : (coe[1] == 1 ? "$(var)^$n" : "-$(var)^$n")
    end
    for k in 2:n-1
        coe[k] == 0 && continue
        if coe[k] > 0 
            str *= "+"
        end
        str *= abs(coe[k]) == 1 ? "$(var)^$(n-k+1)" : "$(coe[k])$(var)^$(n-k+1)"
    end
    if n > 1 && coe[n] != 0 
        str *= coe[n] > 0 ? "+$(coe[n])$(var)" : "$(coe[n])$(var)"
    end
    if coe[n+1] != 0 
        str *= coe[n+1] > 0 ? "+$(coe[n+1])" :  "$(coe[n+1])"
    end
    str = "Polynomial(" * str * ")"
    return print(io, str)
end

"""
秦九韶算法求多项式值
"""
@inline function evaluate(p::Polynomial, x::Real)
    coe = p.coe
    n = degree(p)
    n <= 0 && return coe[1]
    result = zero(promote_type(eltype(coe), typeof(x)))
    result += coe[1] * x + coe[2]
    for k=3:n+1
        result = result * x + coe[k]
    end
    return result
end

"""
在已知所有(实)根的情况下, 进行多项式求值
"""
@inline function qevaluate(p::Polynomial, x::Real)
    roots = p.roots
    coe = p.coe
    T = promote_type(eltype(coe), typeof(x))
    x in roots && return zero(T)
    result = coe[1] * one(T)
    @inbounds for k in eachindex(roots)
        result *= x - roots[k]
    end
    return result
end

@inline (p::Polynomial)(x::Real) = isempty(p.roots) ? evaluate(p, x) : qevaluate(p, x)

import Base: ==
"""
比较相等
"""
@inline ==(p::Polynomial, q::Polynomial) = eltype(p.coe)==eltype(q.coe) && p.coe == q.coe 

import Base:iszero
"""
判断 0 多项式
"""
@inline iszero(p::Polynomial) = iszero(p.coe[1])

import Base:zero
"""
生成0多项式
"""
@inline zero(::Type{Polynomial{T}}) where T<:Real = Polynomial(zeros(T, 1))
@inline zero(::Type{Polynomial})  = Polynomial(zeros(Int, 1))

"""
判断常多项式
"""
@inline isconstant(p::Polynomial) = length(p.coe) == 1

"""
求导
"""
@inline function ∂(p::Polynomial)::Polynomial
    coe = p.coe
    n = p.degree
    isconstant(p) && return Polynomial([zero(eltype(coe))])
    ncoe = Vector{eltype(coe)}(undef, n)
    for (k, a) in enumerate(@view coe[1:end-1])
        @inbounds ncoe[k] = a * (n-k+1)
    end
    return Polynomial(ncoe)
end

"""
将向量中第一个非零元素前的元素全部pop
"""
@inline function _popzerofirst!(v::Vector{<:Real})
    temp = findfirst(!iszero, v)
    index = isnothing(temp) ? length(v) : temp
    for _ in 1:index-1
        popfirst!(v)
    end
end

"""
在向量(copy)的头部插入n个0
"""
@inline _insertzerofirst(v::Vector{<:Real}, n::Integer) = n >= 1 ? vcat(zeros(eltype(v), n), v) : throw(ArgumentError("第二个参数为正整数"))

@inline _insertzerolast(v::Vector{<:Real}, n::Integer) = n >= 1 ? vcat(v, zeros(eltype(v), n)) : throw(ArgumentError("第二个参数为正整数"))

import Base:+
"""
多项式加法
"""
@inline function +(p::Polynomial, q::Polynomial)    
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
    return Polynomial(ncoe)
end

import Base:-
"""
加法逆元
"""
@inline -(p::Polynomial) = Polynomial(-p.coe, p.roots)

"""
多项式减法
"""
@inline -(p::Polynomial, q::Polynomial) = +(p, -q)

import Base:*
"""
多项式标量乘法
"""
@inline function *(a::Real, p::Polynomial)
    iszero(a) || iszero(p) && return zero(typeof(p))
    return Polynomial(a*p.coe, p.roots)
end

using FFTW
"""
两个多项式的乘法
"""
@inline function *(p::Polynomial, q::Polynomial)
    pcoe, qcoe = p.coe, q.coe
    proots, qroots = p.roots, q.roots
    T = promote_type(eltype(pcoe), eltype(qcoe))
    iszero(p) || iszero(q) && return zero(Polynomial{T})
    isconstant(p) && return Polynomial(pcoe[1]*qcoe, qroots)
    isconstant(q) && return Polynomial(qcoe[1]*pcoe, proots)
    n = 1
    dp, dq = degree(p), degree(q)
    while n < dp + dq + 1
        n <<= 1
    end
    a = _insertzerolast(pcoe, n-length(pcoe))
    b = _insertzerolast(qcoe, n-length(qcoe))
    coe = real.(ifft(fft(a) .* fft(b)))[1:dp+dq+1]
    if T <: Integer 
        coe = map(x->round(T, x), coe)
    end
    roots = !isempty(proots) && !isempty(qroots) ? vcat(proots, qroots) : Vector{Int}()
    return Polynomial(coe, roots)
end


function from_roots(roots::Vector{<:Real}, a::Real=1) :: Polynomial
    isempty(roots) && throw(ArgumentError("根向量不能为空"))
    T = promote_type(eltype(roots), typeof(a))
    iszero(a) && return zero(Polynomial{T})
    p = Polynomial(a*[1, -roots[1]], [roots[1]])
    @inbounds for k in firstindex(roots)+1:lastindex(roots)
        p *= Polynomial([one(T), -roots[k]], [roots[k]])
    end
    return p
end