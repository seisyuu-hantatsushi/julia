using ArgParse,CairoMakie,Distributions

CairoMakie.activate!(type="pdf")

function parse_argument()
end

function main()
    graph_name ="beta_dist_mass"

    xs::Array{Float64} = 0.03:0.01:0.97

    graph_params = [Dict("params"=>Dict("α"=>2.0,"β"=>2.0), "linestyle"=>nothing, "label"=>"Beta(2.0,2.0)"),
                    Dict("params"=>Dict("α"=>2.0,"β"=>0.5), "linestyle"=>:dash,   "label"=>"Beta(2.0,0.5)"),
                    Dict("params"=>Dict("α"=>0.2,"β"=>0.5), "linestyle"=>:dot,    "label"=>"Beta(0.2,0.5)")]

    fig = Figure(resolution = (800, 600))

    axis = Axis(fig[1,1], title = "beta distribution mass function")

    for params in graph_params
        α = params["params"]["α"]
        β = params["params"]["β"]
        ys = [pdf(Beta(α,β), x) for x in xs]
        lines!(fig[1,1], xs, ys, linestyle=params["linestyle"], label=params["label"])
    end

    axislegend(axis)

    save("$graph_name.pdf", fig)
end

main()
