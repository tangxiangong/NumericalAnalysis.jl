function discretization(interval::NTuple{2, Real}, h::Float64)
    a, b = interval
    nodes = collect(a:h:b)
    n = length(nodes)
    weights = h * ones(n)
    weights[1] = h/2
    weights[end] = h/2
    return WeightsNodes(weights, nodes)
end