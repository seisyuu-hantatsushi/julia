using ArgParse,CairoMakie

CairoMakie.activate!(type="pdf")

function poisson_prob_desity(λ,x)
    ((λ^x)/factorial(x))*(ℯ^(-λ))
end

function main()
    graph_name = "poisson_prob_mass"
    xs_max = 20
    xs = 0:xs_max

    graph_params = [Dict("lambda"=>1,  "color"=>:gray0,  "marker"=>:circle,  "label"=>"λ=1"),
                    Dict("lambda"=>5,  "color"=>:gray30, "marker"=>:diamond, "label"=>"λ=5"),
                    Dict("lambda"=>10, "color"=>:gray50, "marker"=>:rect,    "label"=>"λ=15")]

    fig = Figure(resolution = (800, 600))

    axis = Axis(fig[1,1], title = "poisson probability mass function")

    for params in graph_params
        p_s = [ poisson_prob_desity(params["lambda"],x) for x in xs ]
        stem!(fig[1,1], xs, p_s, color = params["color"], marker = params["marker"], label=params["label"])
    end

    axislegend(axis)

    save("$graph_name.pdf", fig)
end

main()
