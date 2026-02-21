using CSV, DataFrames
using CairoMakie

whard_data = CSV.read("../R_scripts/csv_out/WHARD.csv", DataFrame)

whard_data = transform(whard_data, :value => (v -> log10.(Float64.(v))) => :log10_dv)

fig = Figure(size = (900, 450))
ax = Axis(fig[1, 1], xlabel = "time (year)", ylabel = "value", title = "value vs time")
lines!(ax, whard_data.time, whard_data.value; linewidth = 0.6)
bx = Axis(fig[2, 1], xlabel = "time (year)", ylabel = "log10 value", title = "value vs time")
lines!(bx, whard_data.time, whard_data.log10_value; linewidth = 0.6)

fig
