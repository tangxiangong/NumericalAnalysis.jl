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
