using Test
using NumericalAnalysis.NonLinearSolve

@testset "二分法测试" begin
    @test_throws ArgumentError bisection(x->x^2-2, (1, 0))  
    @test_throws ArgumentError bisection(x->x^2-2, (0, 1))
    @test bisection(x->x^2-2, (1, 2)) ≈ sqrt(2) 
end

# @testset "不动点测试" begin
#     # @test fixedpoint(x->x^2-2, 2) ≈ sqrt(2)
# end