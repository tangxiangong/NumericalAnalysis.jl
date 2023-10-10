using Test
# using NumericalAnalysis

@testset "多项式测试" begin
    include("poly_tests.jl")
end

@testset "非线性方程求根测试" begin
    include("nonlinear_tests.jl")
end

@testset "指数积分子测试" begin
    include("exponentialintegrators_test.jl")
end