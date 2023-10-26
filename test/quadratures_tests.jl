using NumericalAnalysis.Quadrature
using Test

@testset "Gauss-Legendre 测试" begin
    f(x) = x^9
    dx = discretization((0, 1), 20)
    @test ∫(f)*dx ≈ 0.1
end
