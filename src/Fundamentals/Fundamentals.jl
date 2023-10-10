module Fundamentals
include("Polynomial.jl")
export Polynomial, degree, evaluate, ∂, _popzerofirst!, _insertzerofirst, isconstant, from_roots 
end