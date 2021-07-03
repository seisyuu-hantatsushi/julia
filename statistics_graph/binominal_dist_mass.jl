using ArgParse,CairoMakie

CairoMakie.activate!(type="pdf")

function parse_argument()

end

function binominal_prob_desity(n,p,x)
    return binomial(n,x)*p^x*(1-p)^(n-x)
end

function main()
    graph_name = "binominal_prob_mass"
    xs_max = 50
    xs = 0:xs_max
    fig = Figure(resolution = (800, 600))

    axis = Axis(fig[1,1], title = "binominal probability mass function")

    graph_params = [Dict("prob"=>0.1, "color"=>:gray0,  "marker"=>:circle,  "label"=>"p=0.1"),
                    Dict("prob"=>0.5, "color"=>:gray30, "marker"=>:diamond, "label"=>"p=0.5"),
                    Dict("prob"=>0.7, "color"=>:gray50, "marker"=>:rect,    "label"=>"p=0.7")]

    for params in graph_params
        p_s = [ binominal_prob_desity(xs_max,params["prob"],x) for x in xs ]
        stem!(fig[1,1], xs, p_s, color = params["color"], marker = params["marker"], label=params["label"])
    end

    axislegend(axis)
    save("$graph_name.pdf", fig)

end

main()
