using ArgParse,CairoMakie

CairoMakie.activate!(type="png")

function parse_argument()

end

function binominal_prob_desity(n,p,x)
    return binomial(n,x)*p^x*(1-p)^(n-x)
end

function main()

    fig = Figure(resolution = (800, 600))
    xs = 0:50

    p1_s::Array{Float64} = []
    for x in xs
        push!(p1_s,binominal_prob_desity(50,0.1,x))
    end

    lines(fig[1,1], xs, p1_s, color = :blue)

    p2_s::Array{Float64} = []
    for x in xs
        push!(p2_s,binominal_prob_desity(50,0.5,x))
    end

    lines!(fig[1,1], xs, p2_s, color = :red)

    p3_s::Array{Float64} = []
    for x in xs
        push!(p3_s,binominal_prob_desity(50,0.7,x))
    end

    lines!(fig[1,1], xs, p3_s, color = :yellow)

    save("plot.png", fig)

end

main()
