using Plots
using DifferentialEquations

function sirmodel(du, u, p, t)
    S = u[1]
    I = u[2]
    R = u[3]
    dS = -p[1]*S*I
    dI = p[1]*S*I-p[2]*I
    dR = p[2]*I
    du[1] = dS
    du[2] = dI
    du[3] = dR
end

function solveSIR(N, β, γ)

    tspan = (0.0, 160.0)
    u0 = [N-1.0, 1.0, 0.0]
    p = [β, γ]

    prob = ODEProblem(sirmodel, u0, tspan, p)

    sol = solve(prob)

    return sol
end

R0=2.0
N=10000
γ=0.1
β=γ*R0/N

sol = solveSIR(N, β, γ)

plot_graph = plot(sol, vars=(0,1), title="SIR model/Runge-Kutta R0=$R0 γ=$γ", label="Suscepible",
                  color=:blue, seriestype=:line, legend=:left, size=(1200,900))
plot!(plot_graph, sol, vars=(0,2), label="Infectious", color=:red)
plot!(plot_graph, sol, vars=(0,3), label="Removed", color=:green)

png(plot_graph, "plot_0.png")
