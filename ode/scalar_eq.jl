using Makie
using MakieLayout
using DifferentialEquations

f(u,p,t) = 1.01*u
u0 = 1/2
tspan=(0.0, 1.0)
prob = ODEProblem(f, u0, tspan)
sol = solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)

scene, layout = layoutscene()

ax = layout[1,1] = LAxis(scene)

ls = [lines!(ax, sol.t, sol, color=:blue, linewidth=5),
      lines!(ax, sol.t, t->0.5*exp(1.01*t), color=:red, linewidth=3, linestyle=:dash)]

leg = layout[1, 1] = LLegend(scene, ls, ["solve", "true"];
                             width = Auto(), height = Auto(), halign = :left, valign = :top,
                             tellwidth = false, tellheight = false,
                             margin = (20, 20, 15, 15))
display(scene)
readline()

save("plot.png", scene)
