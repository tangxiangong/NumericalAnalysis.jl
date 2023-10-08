# NumericalAnalysis.jl
> 教材 [Numerical Analysis (3rd Edition, by Timothy Sauer)](https://www.pearson.com/en-us/subject-catalog/p/numerical-analysis/P200000006340?view=educator&tab=title-overview) 中数值算法的 Julia 实现. 

[![codecov](https://codecov.io/gh/tangxiangong/NumericalAnalysis.jl/graph/badge.svg?token=58LNBU2BVF)](https://codecov.io/gh/tangxiangong/NumericalAnalysis.jl)

## 进度
- **Chapter 0. Fundamentals**
  - [Evaluating a Polynomial](./src/Fundamentals/Polynomial.jl)
    - [x] `Polynomial{<:Real}` 类型
    - [x] 返回多项式次数的函数/成员变量 `degree` (由 `Base.getproperty` 实现)
    - [x] 重载 `Base.show` 自定义纯文本输出 
    - [ ] 使用 `Latexify.jl` 在 `Jupyter`/`Pluto.jl`/... 中实现 $\LaTeX$ 输出
    - [x] 重载 `Base.:-` 得到关于加法运算的逆元 
