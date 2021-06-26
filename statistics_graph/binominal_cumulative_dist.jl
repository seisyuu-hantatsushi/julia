using ArgParse,CairoMakie

CairoMakie.activate!(type="pdf")

function parse_argument()

end

function binominal_prob_desity(n,p,x)
    return binomial(n,x)*p^x*(1-p)^(n-x)
end

function main()
    graph_name = "binominal_cumulative_dist"
    xs_max = 50
    fig = Figure(resolution = (800,600))

    xs = 0:xs_max
    axis = Axis(fig[1,1], title = "binominal cumulative distribution function")

    graph_params = [Dict("prob"=>0.1, "color"=>:gray0,  "marker"=>:circle,  "label"=>"p=0.1"),
                    Dict("prob"=>0.5, "color"=>:gray30, "marker"=>:diamond, "label"=>"p=0.5"),
                    Dict("prob"=>0.7, "color"=>:gray50, "marker"=>:rect,    "label"=>"p=0.7")]

    for params in graph_params
        c_s::Array{Float64} = []
        accum::Float64 = 0
        for x in xs
            accum += binominal_prob_desity(xs_max,params["prob"],x)
            push!(c_s,accum)
        end
        stem!(fig[1,1], xs, c_s, color = params["color"], marker = params["marker"], label=params["label"])
    end

    axislegend(axis)
    save("$graph_name.pdf", fig)
end

main()
