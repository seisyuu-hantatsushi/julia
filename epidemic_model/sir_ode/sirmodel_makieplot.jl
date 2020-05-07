using Makie
using MakieLayout

include("sirmodel.jl")

R0=2.0
N=1000
γ=0.1
β=γ*R0/N

sol = solveSIR(N, β, γ)

rep = calcEffectiveReproduction(sol)

scene, layout = layoutscene(resolution=(1200,900))

xticks=0:10:160

ax = layout[1,1] = LAxis(scene, title="SIR Model,N=$N,β=$β,γ=$γ", xticks=xticks)

ls = [lines!(ax, sol.t, sol[1,:], color=:blue),
      lines!(ax, sol.t, sol[2,:], color=:red),
      lines!(ax, sol.t, sol[3,:], color=:green)]

layout[1,1] = LLegend(scene, ls, ["Susceptible", "Infectious", "Removed"],
                      width=Auto(), height=Auto(), halign=:left, valign=:center,
                      tellwidth=false, tellheight=false, margin=(10,10,10,10))

bx = layout[2,1] = LAxis(scene, title="Effective Reproduce. \0=$R0",xticks=xticks)
lines!(bx, rep[2], rep[1], color=:blue)

#display(scene)
#readline()

save("plot.png",scene)
