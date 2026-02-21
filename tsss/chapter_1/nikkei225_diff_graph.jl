using CSV,DataFrames
using CairoMakie

include("../lib/tsss.jl")

nikkei255_data = CSV.read("../R_scripts/csv_out//Nikkei225.csv", DataFrame)
nikkei255_data_log10 = transform(nikkei255_data, :value => (v -> log10.(Float64.(v))) => :value)

print(nikkei255_data_log10)

nikkei255_diff_data = diff_timeseries(nikkei255_data)

nikkei255_diff_data_log10 = diff_timeseries(nikkei255_data_log10)

fig = Figure(size = (900, 450))
ax = Axis(fig[1, 1], xlabel = "time (year)", ylabel = "value", title = "value vs time")
lines!(ax, nikkei255_diff_data.t, nikkei255_diff_data.dv; linewidth = 0.6)
bx = Axis(fig[2, 1], xlabel = "time (year)", ylabel = "log10 value", title = "value vs time")
lines!(bx, nikkei255_diff_data_log10.t, nikkei255_diff_data_log10.dv; linewidth = 0.6)

fig
