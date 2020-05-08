using Plots
using DifferentialEquations

function seirmodel(du, u, p, t)
    S = u[1]
    E = u[2]
    I = u[3]
    R = u[4]
    dS = -p[1]*S*I
    dE = p[1]*S*I-p[2]*E
    dI = p[2]*E-p[3]*I
    dR = p[3]*I
    du[1] = dS
    du[2] = dE
    du[3] = dI
    du[4] = dR
end

function solveSEIR(u0, β, γ, δ, time_span)

    prob = ODEProblem(seirmodel, u0, time_span, [β, δ, γ])

    sol = solve(prob)

    return sol

end

R0=2.0
N=10000
γ=0.1
β=γ*R0/N
δ=0.25

sol = solveSEIR(Array{Float64}([N-1,0,1,0]), β, γ, δ, (0.0,360.0))
