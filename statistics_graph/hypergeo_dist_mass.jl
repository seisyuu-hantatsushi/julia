using ArgParse,CairoMakie

CairoMakie.activate!(type="pdf")

function parse_argument()
end

function hypergeo_dist(n,M,N,x)
    binomial(BigInt(M),BigInt(x))*binomial(BigInt(N),BigInt(n-x))/binomial(BigInt(M+N),BigInt(n))
end

function main()
    graph_name = "hypergeo_dist_mass"

    xs_max = 50
    xs = 0:xs_max

    graph_params = [Dict("params"=>Dict("n"=>10,"N"=>100,"M"=>100), "color"=>:gray0,  "marker"=>:circle, "label"=>"n=10,M=100,N=100"),
                    Dict("params"=>Dict("n"=>30,"N"=>100,"M"=>100), "color"=>:gray30, "marker"=>:diamond, "label"=>"n=30,M=100,N=100"),
                    Dict("params"=>Dict("n"=>70,"N"=>100,"M"=>100), "color"=>:gray50, "marker"=>:rect,    "label"=>"n=70,M=100,N=100")]

    fig = Figure(resolution = (800, 600))

    axis = Axis(fig[1,1], title = "hypergeometric distribution mass function")

    for params in graph_params
        n = params["params"]["n"]
        M = params["params"]["M"]
        N = params["params"]["N"]
        p_s = [hypergeo_dist(n,M,N,x) for x in xs ]
        stem!(fig[1,1], xs, p_s, color = params["color"], marker = params["marker"], label=params["label"])
    end

    axislegend(axis)

    save("$graph_name.pdf", fig)

end

main()
