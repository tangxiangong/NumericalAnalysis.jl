var documenterSearchIndex = {"docs":
[{"location":"Fundamentals.html#NumericalAnalysis.Fundamentals","page":"多项式","title":"NumericalAnalysis.Fundamentals","text":"","category":"section"},{"location":"Fundamentals.html","page":"多项式","title":"多项式","text":"Modules = [Fundamentals]\nOrder = [:function, :type] ","category":"page"},{"location":"Fundamentals.html#Base.:*-Tuple{NumericalAnalysis.Fundamentals.Polynomial, NumericalAnalysis.Fundamentals.Polynomial}","page":"多项式","title":"Base.:*","text":"两个多项式的乘法\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#Base.:*-Tuple{Real, NumericalAnalysis.Fundamentals.Polynomial}","page":"多项式","title":"Base.:*","text":"多项式标量乘法\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#Base.:+-Tuple{NumericalAnalysis.Fundamentals.Polynomial, NumericalAnalysis.Fundamentals.Polynomial}","page":"多项式","title":"Base.:+","text":"多项式加法\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#Base.:--Tuple{NumericalAnalysis.Fundamentals.Polynomial, NumericalAnalysis.Fundamentals.Polynomial}","page":"多项式","title":"Base.:-","text":"多项式减法\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#Base.:--Tuple{NumericalAnalysis.Fundamentals.Polynomial}","page":"多项式","title":"Base.:-","text":"加法逆元\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#Base.:==-Tuple{NumericalAnalysis.Fundamentals.Polynomial, NumericalAnalysis.Fundamentals.Polynomial}","page":"多项式","title":"Base.:==","text":"比较相等\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#Base.getproperty-Tuple{NumericalAnalysis.Fundamentals.Polynomial, Symbol}","page":"多项式","title":"Base.getproperty","text":"将上面求出的多项式次数作为多项式本身的性质\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#Base.iszero-Tuple{NumericalAnalysis.Fundamentals.Polynomial}","page":"多项式","title":"Base.iszero","text":"判断 0 多项式\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#Base.zero-Union{Tuple{Type{NumericalAnalysis.Fundamentals.Polynomial{T}}}, Tuple{T}, Tuple{Type{NumericalAnalysis.Fundamentals.Polynomial{T}}, Symbol}} where T<:Real","page":"多项式","title":"Base.zero","text":"生成0多项式\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#NumericalAnalysis.Fundamentals._insertzerofirst-Tuple{Vector{<:Real}, Integer}","page":"多项式","title":"NumericalAnalysis.Fundamentals._insertzerofirst","text":"在向量(copy)的头部插入n个0\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#NumericalAnalysis.Fundamentals._popzerofirst!-Tuple{Vector{<:Real}}","page":"多项式","title":"NumericalAnalysis.Fundamentals._popzerofirst!","text":"将向量中第一个非零元素前的元素全部pop\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#NumericalAnalysis.Fundamentals.degree-Tuple{NumericalAnalysis.Fundamentals.Polynomial}","page":"多项式","title":"NumericalAnalysis.Fundamentals.degree","text":"degree(p::Polynomial)::Int\n\n多项式 p 的次数, 0 多项式的次数设为 -1. \n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#NumericalAnalysis.Fundamentals.evaluate-Tuple{NumericalAnalysis.Fundamentals.Polynomial, Real}","page":"多项式","title":"NumericalAnalysis.Fundamentals.evaluate","text":"秦九韶算法求多项式值\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#NumericalAnalysis.Fundamentals.isconstant-Tuple{NumericalAnalysis.Fundamentals.Polynomial}","page":"多项式","title":"NumericalAnalysis.Fundamentals.isconstant","text":"判断常多项式\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#NumericalAnalysis.Fundamentals.qevaluate-Tuple{NumericalAnalysis.Fundamentals.Polynomial, Real}","page":"多项式","title":"NumericalAnalysis.Fundamentals.qevaluate","text":"在已知所有(实)根的情况下, 进行多项式求值\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#NumericalAnalysis.Fundamentals.∂-Tuple{NumericalAnalysis.Fundamentals.Polynomial}","page":"多项式","title":"NumericalAnalysis.Fundamentals.∂","text":"求导\n\n\n\n\n\n","category":"method"},{"location":"Fundamentals.html#NumericalAnalysis.Fundamentals.Polynomial","page":"多项式","title":"NumericalAnalysis.Fundamentals.Polynomial","text":"Polynomial{<:Real}(coe::Vector{<:Real}, var::Symbol)\n\n(实)多项式类\n\n\n\n\n\n","category":"type"},{"location":"index.html#NumericalAnalysis.jl","page":"首页","title":"NumericalAnalysis.jl","text":"","category":"section"},{"location":"index.html#简介","page":"首页","title":"简介","text":"","category":"section"},{"location":"index.html#多项式","page":"首页","title":"多项式","text":"","category":"section"},{"location":"index.html","page":"首页","title":"首页","text":"Modules=[NumericalAnalysis.Fundamentals]","category":"page"},{"location":"index.html#非线性方程求解","page":"首页","title":"非线性方程求解","text":"","category":"section"},{"location":"index.html","page":"首页","title":"首页","text":"Modules=[NumericalAnalysis.NonLinearSolve]","category":"page"},{"location":"NonLinearSolve.html#NumericalAnalysis.NonLinearSolve","page":"非线性方程求解","title":"NumericalAnalysis.NonLinearSolve","text":"","category":"section"},{"location":"NonLinearSolve.html","page":"非线性方程求解","title":"非线性方程求解","text":"Modules = [NumericalAnalysis.NonLinearSolve]\nOrder = [:function, :type] ","category":"page"},{"location":"NonLinearSolve.html#NumericalAnalysis.NonLinearSolve.bisection","page":"非线性方程求解","title":"NumericalAnalysis.NonLinearSolve.bisection","text":"二分法\n\n\n\n\n\n","category":"function"},{"location":"NonLinearSolve.html#NumericalAnalysis.NonLinearSolve.fixedpoint-Tuple{Function, Real}","page":"非线性方程求解","title":"NumericalAnalysis.NonLinearSolve.fixedpoint","text":"不动点\n\n\n\n\n\n","category":"method"},{"location":"NonLinearSolve.html#NumericalAnalysis.NonLinearSolve.newton-Tuple{Function, Real}","page":"非线性方程求解","title":"NumericalAnalysis.NonLinearSolve.newton","text":"牛顿迭代法\n\n如果没有提供导函数, 就尝试使用符号计算求出导函数\n\n\n\n\n\n","category":"method"}]
}
