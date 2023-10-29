# NumericalAnalysis.jl
> 教材 [Numerical Analysis (3rd Edition, by Timothy Sauer)](https://www.pearson.com/en-us/subject-catalog/p/numerical-analysis/P200000006340?view=educator&tab=title-overview) 中数值算法的 Julia 实现. 

[![codecov](https://codecov.io/gh/tangxiangong/NumericalAnalysis.jl/graph/badge.svg?token=58LNBU2BVF)](https://codecov.io/gh/tangxiangong/NumericalAnalysis.jl)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://tangxiangong.github.io/NumericalAnalysis.jl/dev)


## Chapter 0. Fundamentals
[Evaluating a Polynomial](./src/Fundamentals/Polynomial.jl)
多项式相关计算, 更专业全面的实现可见 [Polynomials.jl](https://github.com/JuliaMath/Polynomials.jl).
### 进展
- [x] 实多项式类型 `Polynomial{<:Real}(::Vector{<:Real})`
- [x] 多项式次数 `degree(::Polynomial)`, `Base.getproperty(::Polynomial, :degree)` 
- [x] 自定义纯文本输出 `Base.show(::Polynomial)`
- [ ] 在 Jupyter/Pluto/... 中实现 $\LaTeX$ 输出 (利用 [Latexify.jl](https://github.com/korsbo/Latexify.jl))
- [x] 加法逆元 `Base.:-(::Polynomial)`
- [x] 秦九韶算法求值 `evaluate(::Polynomial)`, `(::Polynomial)(::Real)`
- [x] 加/减法和求导运算 `Base.:+(::Polynomial, ::Polynomial)`, `Base.:-(::Polynomial, ::Polynomial)`, `∂(::Polynomial)`
- [x] 标量乘法 `Base.:*(::Real, ::Polynomial)` 和多项式乘法 `Base.:*(::Polynomial, ::Polynomial)` (利用 [FFTW.jl](https://github.com/JuliaMath/FFTW.jl) 计算乘积的系数)
- [x] 由根向量生成多项式 `from_roots(::Vector{<:Real}, ::Real = 1) :: Polynomial`
### 代码示例
```julia
using NumericalAnalysis.Fundamentals
p = Polynomial([1, 2, 0, 1])  # 输出为 Polynomial(t^3+2t^2+1)
q = Polynomial([1, 2, 1]) 
-q    # Polynomial(-x^2-2x-1)
eval_poly(p, 1)  # 3
p(1) == evaluate(p, 1)  # true
∂(p)   # Polynomial(3x^2+4x)
p + q; p-q; p*q
```

## Chapter 1. Solving Equations
[求解非线性方程组](./src/NonLinearSolve/NonLinearSolve.jl)
### 进展
- [x] 二分法 `bisection(::Function, ::Tuple{<:Real, <:Real}, ::Float64=1e-8)`
- [x] 不动点迭代法 `fixedpoint(::Function, ::Real; ::Union{Function, Nothing}=nothing, ::Float64=1e-8, ::Int=10_000)`
- [x] 牛顿迭代法 `newton(::Function, ::Real; ::Union{Nothing, Function}=nothing, ::Float64=1e-8, ::Integer=10_000)`

## Chapter Numerical Integrals
[数值积分](./src/Quadratures/)

### 进展
- [x] Gauss 积分公式

### 例子
```julia
using NumericalAnalysis.Quadrature 
domain = (0, 1)           # 积分区间
order = 10                # 节点个数, 即所使用的正交多项式的次数, 对应 2`order`-1阶代数精度
dx = discretization(domain, order; method=:Legendre)    #  计算区间 `domain`, `order` 次 Legendre 正交多项式所对应的节点和权重
f(x) = x^9                # 被积函数
∫(f)*dx                   # 数值积分
```