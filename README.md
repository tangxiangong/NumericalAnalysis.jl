# NumericalAnalysis.jl
> 教材 [Numerical Analysis (3rd Edition, by Timothy Sauer)](https://www.pearson.com/en-us/subject-catalog/p/numerical-analysis/P200000006340?view=educator&tab=title-overview) 中数值算法的 Julia 实现. 

[![codecov](https://codecov.io/gh/tangxiangong/NumericalAnalysis.jl/graph/badge.svg?token=58LNBU2BVF)](https://codecov.io/gh/tangxiangong/NumericalAnalysis.jl)

## Chapter 0. Fundamentals
### 0.1. [Evaluating a Polynomial](./src/Fundamentals/Polynomial.jl)
多项式相关计算, 更专业全面的实现可见 [Polynomials.jl](https://github.com/JuliaMath/Polynomials.jl).
#### 进展
- [x] 实多项式类型 `Polynomial{<:Real}(::Vector{<:Real}, ::Symbol)`
- [x] 多项式次数 `degree(::Polynomial)`, `Base.getproperty(::Polynomial, :degree)` 
- [x] 自定义纯文本输出 `Base.show(::Polynomial)`
- [ ] 在 Jupyter/Pluto/... 中实现 $\LaTeX$ 输出 (利用 [Latexify.jl](https://github.com/korsbo/Latexify.jl))
- [x] 加法逆元 `Base.:-(::Polynomial)`
- [x] 秦九韶算法求值 `eval_poly(::Polynomial)`, `(::Polynomial)(::Real)`
- [x] 加/减法和求导运算 `Base.:+(::Polynomial, ::Polynomial)`, `Base.:-(::Polynomial, ::Polynomial)`, `∂(::Polynomial)`
- [x] 标量乘法 `Base.:*(::Real, ::Polynomial)` 和多项式乘法 `Base.:*(::Polynomial, ::Polynomial)` (利用 [FFTW.jl](https://github.com/JuliaMath/FFTW.jl) 计算乘积的系数)
#### 代码示例
```julia
using NumericalAnalysis.Fundamentals
p = Polynomial([1, 2, 0, 1], :t)  # 输出为 t^3+2t^2+1
q = Polynomial([1, 2, 1], :t) 
-q    # -t^2-2t-1
eval_poly(p, 1)  # 3
p(1) == eval_poly(p, 1)  # true
∂(p)   # 3t^2+4t
p + q; p-q; p*q
```