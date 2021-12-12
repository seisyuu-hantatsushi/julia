using ArgParse,CairoMakie,Distributions

CairoMakie.activate!(type="pdf")

function parse_argument()
end

function main()
    graph_name ="gamma_cumulative_dist"

    xs::Array{Float64} = 0:0.1:10.0

    graph_params = [Dict("params"=>Dict("α"=>2.0,"β"=>2.0),   "linestyle"=>nothing, "label"=>"Gamma(2.0,2.0)"),
                    Dict("params"=>Dict("α"=>1.0,"β"=>2.0),   "linestyle"=>:dash,   "label"=>"Gamma(1.0,2.0)"),
                    Dict("params"=>Dict("α"=>5.0,"β"=>2.0), "linestyle"=>:dot,    "label"=>"Gamma(5.0,2.0)")]

    fig = Figure(resolution = (800, 600))

    axis = Axis(fig[1,1], title = "gamma distribution cumulative function")

    for params in graph_params
        α = params["params"]["α"]
        β = params["params"]["β"]
        ys = [cdf(Gamma(α,β), x) for x in xs]
        lines!(fig[1,1], xs, ys, linestyle=params["linestyle"], label=params["label"])
    end

    axislegend(axis, position = :rb)

    save("$graph_name.pdf", fig)
end

main()
