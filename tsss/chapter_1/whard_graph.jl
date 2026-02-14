using CSV, DataFrames
using CairoMakie

whard_data = CSV.read("../R_scripts/csv_out/WHARD.csv", DataFrame)

fig = Figure(size = (900, 450))
ax = Axis(fig[1, 1], xlabel = "time (year)", ylabel = "value", title = "value vs time")

lines!(ax, whard_data.time, whard_data.value; linewidth = 0.6)

fig
