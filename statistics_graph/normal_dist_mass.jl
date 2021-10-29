using ArgParse,CairoMakie

CairoMakie.activate!(type="pdf")

function parse_argument()
end

function normal_dist_prob_desity(μ,σ,x)
    (ℯ^(-(x-μ)^2/(2σ)))/sqrt(2*π*σ)
end

function main()
    graph_name = "normal_dist_mass"

    xs::Array{Float64} = -4.0:0.1:4.0

    graph_params = [Dict("params"=>Dict("μ"=>0.0,"σ"=>1.0),   "linestyle"=>nothing, "label"=>"N(0.0,1.0)"),
                    Dict("params"=>Dict("μ"=>0.0,"σ"=>0.5),   "linestyle"=>:dash,   "label"=>"N(0.0,0.5)"),
                    Dict("params"=>Dict("μ"=>-1.0,"σ"=>0.75), "linestyle"=>:dot,    "label"=>"N(-1.0,0.75)")]


    fig = Figure(resolution = (800, 600))

    axis = Axis(fig[1,1], title = "normal distribution mass function")

    for params in graph_params
        μ = params["params"]["μ"]
        σ = params["params"]["σ"]
        ys = [ normal_dist_prob_desity(μ,σ,x) for x in xs ]
        lines!(fig[1,1], xs, ys, linestyle=params["linestyle"], label=params["label"])
    end
    axislegend(axis)

    save("$graph_name.pdf", fig)

end

main()
