using Test
using NumericalAnalysis.ExponentialIntegrators
 
@testset "ExpMatrix" begin
    @testset "Constructors" begin
        @test ExpMatrix{Float64}(rand(3,3)) isa ExpMatrix
        @test ExpMatrix(rand(3, 3)) isa ExpMatrix
        @test ExpMatrix(rand(3, 3);order=1).order == 1   
        try 
            ExpMatrix(rand(3, 4))
        catch 
            err = true
        else
            err = false
        finally
            @test err
        end
    end
end