@doc raw"""
    ExpMatrix{T}(basis::Matrix{T}, order::Integer)

The datatype representing exponential integrators without any computing.

The `ExpMatrix` type is associated with the exponential integrators $\varphi_n(A)$ and/or the time-dependent case $\varphi_n(tA)$, where the function $\varphi_n$ is the generating function of the integrators associated with $n$ order/degree Lagrangian interpolation polynomial, and the (square) matrix, $A$, obviously, is the one whose exponent with natural base are what we want to get. Concretely, the functions $\varphi_n$, $n=0$, $1$, $\cdots$, have the following relation:
```math
\varphi_0(z)=\mathrm{e}^{z},\quad 
```

# Parameters
- `basis` : the matrix $A$ 
- `order` : the order $n$, default = `0`

# Additional Constructors
- 
-

# Examples
```julia

```
"""
struct ExpMatrix{T <: Number}
    basis :: Matrix{T}
    order :: Integer
    function ExpMatrix{T}(mat::Matrix{T}; order::Integer=0) where T <: Number
        size(mat, 1) == size(mat, 2) || throw(DimensionMismatch("`mat` should be a square matrix"))
        order >= 0 || throw(BoundsError("`order` must be a non-negative integer!")) 
        new{T}(mat, order)
    end
end

ExpMatrix(mat::Matrix{T}; order::Integer = 0) where T <: Number = ExpMatrix{T}(mat; order=order)

ExpMatrix(t::Number, mat::Matrix; order::Integer = 0) = ExpMatrix(t .* mat; order=order)

function multiply(expmat::ExpMatrix, b::Vector{<:Number}; method::String="Contour-Krylov", args...)
    size(expmat.basis, 1) == length(b) || throw(DimensionMismatch("`expmat` and `b` are not compatible.")) 
    method in ["Krylov", "Contour", "Contour-Krylov"] || throw(UndefVarError("`method` is not defined, please choose `Krylov`, `Contour`, and `Contour-Krylov`.")) 
    A = expmat.basis
    order = expmat.order
    if method == "Keylov"
        return krylov(A, b; order=order, args=args)
    elseif method == "Contour"
        return contour(A, b; order=order, args=args)
    else
        return contour_krylov(A, b; order=order, args=args)
    end
end

Base.:*(expmat::ExpMatrix, b::Vector{<:Number}) = multiply(expmat, b)