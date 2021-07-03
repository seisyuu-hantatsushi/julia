using ArgParse,CairoMakie

CairoMakie.activate!(type="pdf")

function poisson_prob_desity(λ,x)
    ((λ^x)/factorial(x))*(ℯ^(-λ))
end

function main()
    graph_name = "poisson_cumulative_dist"
    xs_max = 20
    xs = 0:xs_max

    graph_params = [Dict("lambda"=>1,  "color"=>:gray0,  "marker"=>:circle,  "label"=>"λ=1"),
                    Dict("lambda"=>5,  "color"=>:gray30, "marker"=>:diamond, "label"=>"λ=5"),
                    Dict("lambda"=>10, "color"=>:gray50, "marker"=>:rect,    "label"=>"λ=15")]

    fig = Figure(resolution = (800, 600))

    axis = Axis(fig[1,1], title = "poisson cumulative distribution function")

    for params in graph_params
        c_s::Array{Float64} = []
        accum::Float64 = 0
        for x in xs
            accum += poisson_prob_desity(params["lambda"],x)
            push!(c_s,accum)
        end
        stem!(fig[1,1], xs, c_s, color = params["color"], marker = params["marker"], label=params["label"])
    end

    axislegend(axis, position = :rb)

    save("$graph_name.pdf", fig)
end

main()
