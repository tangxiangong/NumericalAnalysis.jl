# using LaTeXStrings, Plots
# pgfplotsx()
struct Contour
    λ::Real
    α::Real
    function Contour(λ=1, α=π/4)
        0<α<π/2 || throw(BoundsError("0<alpha<pi/2"))
        new(λ, α)
    end
end

function hyperbola(λ, α)
    return s -> λ * (1-sin(α + s * im))
end

function node(Γ::Contour, K::Integer, τ::Float64=0.01)
    θ = 1-1/K
    α = Γ.α
    aθ = acosh(1/(1-θ)*sin(α))
    d = α/2
    λ = 2*π*d*K*(1-θ)/(τ*aθ)
    h = aθ/K
    z = zeros(ComplexF64, 2K+1)
    Γ = hyperbola(λ, α)
    @inbounds @simd for k in -K:1:K
        z[k] = Γ(h*k)
    end
    return z
end
