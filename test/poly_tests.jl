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
    @test repr(MIME("text/plain"), Polynomial([1, 4])) == "x+4"
end

@testset "求值测试" begin
    p = Polynomial([1, 2, -3, 4])
    @test evaluate(p, 1) == 4
    @test p(1) == 4
end

@testset "判断测试" begin
    p = Polynomial([1, 2, 3])
    q = Polynomial{Float64}([1, 2, 3])
    @test p != q
    @test p != Polynomial([1, 2, 3], :t)
    @test p == Polynomial([1, 2, 3])
end

@testset "求导测试" begin
    @test ∂(Polynomial([1])) == Polynomial([0])
    @test ∂(Polynomial([1.])) != Polynomial([0])
    @test ∂(Polynomial([1, 2, -3], :t)) == Polynomial([2, 2], :t)
end

@testset "辅助函数测试" begin
    @testset "_popzerofirst!" begin
        a1 = [0]
        _popzerofirst!(a1) 
        @test a1 == a1
        a2 = [1]
        _popzerofirst!(a2)
        @test a2 == a2
        a3 = [1, 0, 0, 0]
        _popzerofirst!(a3)
        @test a3 == a3
        a4 = zeros(5)
        _popzerofirst!(a4)
        @test a4 == [0]
        a5 = [0, 0, 0, 1, 0, 3]
        _popzerofirst!(a5)
        @test a5 == [1, 0, 3]
    end
    @testset "_insertzerofirst" begin
        @test_throws ArgumentError _insertzerofirst([0, 0], 0)
        b1 = [1, 2, 4, 5]
        @test _insertzerofirst(b1, 3) == [0, 0, 0, 1, 2, 4, 5]
    end
end

@testset "加/减法测试" begin
    p1 = Polynomial([1, 2, 3])
    p2 = Polynomial([2])
    @test -p1 == Polynomial([-1, -2, -3])
    @test p1+p2 == Polynomial([1, 2, 5])
    @test p1-p2 == Polynomial([1, 2, 1])
end

@testset "乘法测试" begin
    p = Polynomial([1, 2, 1])
    @test p * p == Polynomial([1, 4, 6, 4, 1])
end