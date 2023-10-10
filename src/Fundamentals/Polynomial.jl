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
@inline Base.getproperty(p::Polynomial, sym::Symbol) = sym === :degree ? degree(p) : getfield(p, sym)

@inline function Base.show(io::IO, ::MIME"text/plain", p::Polynomial)
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
@inline function evaluate(p::Polynomial, x::Real)
    coe = p.coe
    p.degree <= 0 && return coe[1]
    result = zero(promote_type(eltype(coe), typeof(x)))
    result += coe[1] * x + coe[2]
    for k=3:p.degree+1
        result = result * x + coe[k]
    end
    return result
end

@inline (p::Polynomial)(x::Real) = evaluate(p, x)

"""
比较相等
"""
@inline Base.:(==)(p::Polynomial, q::Polynomial) = eltype(p.coe)==eltype(q.coe) && p.coe == q.coe && p.var == q.var

"""
判断 0 多项式
"""
@inline Base.iszero(p::Polynomial) = Base.iszero(p.coe[1])

"""
生成0多项式
"""
@inline Base.zero(::Type{Polynomial{T}}, var::Symbol= :x) where T<:Real = Polynomial(zeros(T, 1), var)
@inline Base.zero(::Type{Polynomial}, var::Symbol= :x)  = Polynomial(zeros(Int, 1), var)

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

"""
多项式加法
"""
@inline function Base.:+(p::Polynomial, q::Polynomial)    
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
@inline Base.:-(p::Polynomial) = Polynomial(-p.coe, p.var)

"""
多项式减法
"""
@inline Base.:-(p::Polynomial, q::Polynomial) = Base.:+(p, -q)

"""
多项式标量乘法
"""
@inline function Base.:*(a::Real, p::Polynomial)
    iszero(a) || iszero(p) && return zero(typeof(p))
    return Polynomial(a*p.coe, p.var)
end

using FFTW
"""
两个多项式的乘法
"""
@inline function Base.:*(p::Polynomial, q::Polynomial)
    p.var == q.var || throw(ArgumentError("两个多项式的变量不同, 暂不支持多元多项式"))
    T = promote_type(eltype(p.coe), eltype(q.coe))
    iszero(p) || iszero(q) && return zero(Polynomial{T})
    isconstant(p) && return Polynomial(p.coe[1]*q.coe, p.var)
    isconstant(q) && return Polynomial(q.coe[1]*p.coe, p.var)
    n = 1
    while n < p.degree + q.degree + 1
        n <<= 1
    end
    a = _insertzerolast(p.coe, n-length(p.coe))
    b = _insertzerolast(q.coe, n-length(q.coe))
    coe = @view real.(ifft(fft(a) .* fft(b)))[1:p.degree+q.degree+1]
    if T <: Integer 
        coe = map(x->round(T, x), coe)
    end
    return Polynomial(coe, p.var)
end


function from_roots(roots::Vector{<:Real}, a::Real=1, var::Symbol= :x) :: Polynomial
    isempty(roots) && throw(ArgumentError("根向量不能为空"))
    n = length(roots)
    T = promote_type(eltype(roots), typeof(a))
    iszero(a) && return zero(Polynomial{T})
    p = Polynomial([T(a)], var)
    @inbounds for k in 1:n
        p *= Polynomial([one(T), -roots[k]])
    end
    return p
end