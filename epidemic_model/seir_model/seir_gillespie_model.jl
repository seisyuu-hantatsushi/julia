using Plots
using DifferentialEquations
using DiffEqBiological

seirmodel = @reaction_network SEIR begin
    β, S + I --> E + I
    δ, E --> I
    γ, I --> R
end β δ γ

function solveSEIR(u0, β, γ, δ, time_span)

    dprob = DiscreteProblem(seirmodel, u0, time_span, [β, δ, γ])
    jprob = JumpProblem(dprob, Direct(), seirmodel)

    sol = solve(jprob, SSAStepper())

    return sol

end

R0=2.0
N=10000
γ=0.1
β=γ*R0/N
δ=0.25

sol = solveSEIR([N-1,0,1,0], β, γ, δ, (0.0,360.0))

plot_graph = plot(sol, vars=(0,1), title="SEIR model/Gillespie R0=$R0 γ=$γ δ=$δ", label="Suscepible",
                  color=:blue, seriestype=:line, legend=:left, size=(1200,900))
plot!(plot_graph, sol, vars=(0,2), label="Infectious", color=:red)
plot!(plot_graph, sol, vars=(0,3), label="Exposed", color=:darkmagenta)
plot!(plot_graph, sol, vars=(0,4), label="Removed", color=:green)

png(plot_graph, "seir_gillespie.png")
