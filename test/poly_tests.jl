using NumericalAnalysis.Fundamentals
using Test


@testset "构造函数传参测试" begin
    # 至少需要传入一个参数
    @test_throws MethodError Polynomial()
    # 一些参数
    c1 = rand(1:5, 4)               # 整系数
    c2 = rand(5)                    # 浮点系数
    c3 = rand([1//2, 1//3], 5)      # 有理系数
    # 带有参数类型的构造函数
    @test Polynomial{eltype(c1)}(c1) isa Polynomial{eltype(c1)}
    @test Polynomial{eltype(c1)}(c1, :t) isa Polynomial{eltype(c1)}
    @test Polynomial{eltype(c2)}(c2) isa Polynomial{eltype(c2)}
    @test Polynomial{eltype(c2)}(c2, :t) isa Polynomial{eltype(c2)}
    @test Polynomial{eltype(c3)}(c3) isa Polynomial{eltype(c3)}
    @test Polynomial{eltype(c3)}(c3, :t) isa Polynomial{eltype(c3)}

    # 试图用整系数向量生成浮点系数多项式
    @test Polynomial{Float64}(c1) isa Polynomial{Float64}
    @test Polynomial{Float64}(c1).coe == Vector{Float64}(c1) 
    # 试图用浮点系数向量生成整系数多项式
    @test_throws ArgumentError Polynomial{Int}(c2)
    # 不使用参数类型来声明实例
    @test Polynomial(c1) isa Polynomial{eltype(c1)}
    @test Polynomial(c1, :t) isa Polynomial{eltype(c1)}
    @test Polynomial(c2) isa Polynomial{eltype(c2)}
    @test Polynomial(c2, :t) isa Polynomial{eltype(c2)}
    @test Polynomial(c3) isa Polynomial{eltype(c3)}
    @test Polynomial(c3, :t) isa Polynomial{eltype(c3)}
    # 最高次系数为 0
    @test_throws ArgumentError Polynomial([0, 1, 2])
end

@testset "次数测试" begin
    @test degree(Polynomial([0])) == -1
    @test degree(Polynomial([1])) == 0
    n = rand(1:344)
    @test degree(Polynomial(rand(n))) == n-1
    @test Polynomial(rand(n)).degree == n-1
end

@testset "输出测试" begin
    @test repr(MIME("text/plain"), Polynomial([1, 2, 0, 1])) == "x^3+2x^2+1"
    @test repr(MIME("text/plain"), Polynomial([2, 1, 3, 4], :t)) == "2t^3+t^2+3t+4"
end