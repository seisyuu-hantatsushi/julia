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

function calcEffectiveReproduction(sol)

    v = Array{Float64,1}()
    t = Array{Float64,1}()
    for index in 2:length(sol)
        push!(v, sol[index][2]/sol[index-1][2])
        push!(t, sol.t[index])
    end

    return [v,t]
end
