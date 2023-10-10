using Test
# using NumericalAnalysis

@testset "多项式测试" begin
    include("poly_tests.jl")
end

@testset "非线性方程求根测试" begin
    include("nonlinear_tests.jl")
end