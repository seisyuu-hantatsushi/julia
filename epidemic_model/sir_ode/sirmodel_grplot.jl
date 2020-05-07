using Plots

gr()

include("sirmodel.jl")

R0=2.0
N=1000
γ=0.1
β=γ*R0/N

sol = solveSIR(N, β, γ)

plot_graph = plot(sol, vars=(0,1), title="SIR model/Runge-Kutta", label="Suscepible", color=:blue, legend=:left)
plot!(plot_graph, sol, vars=(0,2), label="Infectious", color=:red)
plot!(plot_graph, sol, vars=(0,3), label="Removed", color=:green)

png(plot_graph, "plot_0.png")
