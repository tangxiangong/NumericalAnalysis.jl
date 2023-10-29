using Documenter
using NumericalAnalysis
 
makedocs(sitename = "NumericalAnalysis",
    modules = [NumericalAnalysis],
    format = Documenter.HTML(
        prettyurls = false,
        mathengine = Documenter.HTMLWriter.MathJax3(Dict(
            :loader => Dict("load" => ["[tex]/physics"]),
            :tex => Dict(
            :equationNumbers => Dict(:autoNumber => "AMS"),
            "inlineMath" => [["\$","\$"], ["\\(","\\)"]],
            "tags" => "ams",
            "packages" => ["base", "ams", "autoload", "physics"],
        ),
    ))
    ),
    pages = [
        "首页" => "index.md",
        "多项式" => "Fundamentals.md",
        "非线性方程求解" => "NonLinearSolve.md",
        "数值积分" => "Quadrature.md"
        # "Manual" => Any[
        #     "man/guide.md"
        # ],
        # "references.md"
    ],    
)