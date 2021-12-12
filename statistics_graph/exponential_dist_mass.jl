using ArgParse,CairoMakie,Distributions

CairoMakie.activate!(type="pdf")

function parse_argument()
end

function main()
    graph_name ="exponential_dist_mass"

    xs::Array{Float64} = 0:0.1:5.0

    graph_params = [Dict("params"=>Dict("λ"=>1.0), "linestyle"=>nothing, "label"=>"Ex(1.0)"),
                    Dict("params"=>Dict("λ"=>1.5), "linestyle"=>:dash,   "label"=>"Ex(1.5)"),
                    Dict("params"=>Dict("λ"=>0.5), "linestyle"=>:dot,    "label"=>"Ex(0.5)")]

    fig = Figure(resolution = (800, 600))

    axis = Axis(fig[1,1], title = "exponential distribution mass function")

    for params in graph_params
        λ = params["params"]["λ"]
        ys = [pdf(Exponential(λ), x) for x in xs]
        lines!(fig[1,1], xs, ys, linestyle=params["linestyle"], label=params["label"])
    end

    axislegend(axis)

    save("$graph_name.pdf", fig)
end

main()
