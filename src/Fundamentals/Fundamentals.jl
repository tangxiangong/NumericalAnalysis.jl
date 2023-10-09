module Fundamentals
include("Polynomial.jl")
export Polynomial, degree, eval_poly, ∂, _popzerofirst!, _insertzerofirst, isconstant 
end