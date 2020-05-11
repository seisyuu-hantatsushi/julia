using Plots
using DifferentialEquations
using DiffEqBiological

sirmodel = @reaction_network SIR begin
    β, S + I --> 2I
    γ, I --> R
end β γ

function solveSIR(u0, β, γ, time_span)

    p = [β, γ]

    dprob = DiscreteProblem(sirmodel, u0, time_span, p)
    jprob = JumpProblem(dprob, Direct(), sirmodel)

    sol = solve(jprob, SSAStepper())

    return sol

end

R0=2.0
N=10000
γ=0.1
β=γ*R0/N

sol = solveSIR([N-1,1,0], β, γ, (0, 160.0))

plot_graph = plot(sol, vars=(0,1), title="SIR model/Gillespie", label="Suscepible",
                  color=:blue, seriestype=:line, legend=:left, size=(1200,900))
plot!(plot_graph, sol, vars=(0,2), label="Infectious", color=:red)
plot!(plot_graph, sol, vars=(0,3), label="Removed", color=:green)

png(plot_graph, "sir_gillespie.png")
