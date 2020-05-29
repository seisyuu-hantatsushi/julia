using Plots
using Printf
using DifferentialEquations
using DiffEqBiological

seirmodel = @reaction_network SEIR begin
    β, S + I --> E + I
    δ, E --> I
    γ, I --> R
    ϵ, R --> S
end β δ γ ϵ

function solveSEIR(u0, β, γ, δ, ϵ, time_span)

    dprob = DiscreteProblem(seirmodel, u0, time_span, [β, δ, γ, ϵ] )
    jprob = JumpProblem(dprob, Direct(), seirmodel)

    sol = solve(jprob, SSAStepper())

    return sol

end

R0=2.0
N=10000
I=10
γ=0.1
β=γ*R0/N
δ=0.25
ϵ=1/150

sol = solveSEIR([N-I,0,I,0], β, γ, δ, ϵ, (0.0,1080.0))

xlabel = Float64[]

ylabel, yval = Float64[], Float64[]

for i in 1:1080
    rem(i,30)==0 && push!(xlabel, i)
end

# y axis is log scale
for i in 1:10, j in 1:4
    push!(yval, i*10^j)
    i==1 && push!(ylabel, 10^j)
end

title=@sprintf "SEIR (Expire) model/Gillespie R0=%.2f γ=%.3f δ=%.3f ϵ=%.5f" R0 γ δ ϵ
plot_graph = plot(sol, vars=(0,1), title=title, label="Suscepible",
                  color=:blue, seriestype=:line, legend=:bottomright, size=(1200,900),
                  xticks=xlabel, yticks=(yval, ylabel), yaxis=(:log10, (1,Inf)))
plot!(plot_graph, sol, vars=(0,2), label="Infectious", color=:red)
plot!(plot_graph, sol, vars=(0,3), label="Exposed", color=:darkmagenta)
plot!(plot_graph, sol, vars=(0,4), label="Removed", color=:green)

png(plot_graph, "seir_gillespie_exp.png")
