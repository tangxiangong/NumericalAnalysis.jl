using Test
using NumericalAnalysis.NonLinearSolve

@testset "二分法测试" begin
    @test_throws ArgumentError bisection(x->x^2-2, (1, 0))  
    @test_throws ArgumentError bisection(x->x^2-2, (0, 1))
    @test bisection(x->x^2-2, (1, 2)) ≈ sqrt(2) 
end

@testset "牛顿迭代法测试" begin
    @test newton(x->x^2-2, 1) ≈ sqrt(2) atol=1e-4
end

@testset "不动点测试" begin
    f(x) = x^3+x-1
    g(x) = (1+2x^3)/(1+3x^2)
    x = fixedpoint(f, 0.5, iter_func=g)
    @test f(x) ≈ 0 atol=1e-5
end