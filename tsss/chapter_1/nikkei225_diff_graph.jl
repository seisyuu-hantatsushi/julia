using CSV,DataFrames
using CairoMakie

#include("../lib/tsss.jl")

nikkei225_data = CSV.read("../R_scripts/csv_out//Nikkei225.csv", DataFrame)
nikkei225_data_log10 = transform(nikkei225_data, :value => (v -> log10.(Float64.(v))) => :value)

nikkei225_data.dv = vcat(missing, diff(nikkei255_data.value))
nikkei225_data = dropmissing(nikkei225_data, [:dv])

nikkei225_data_log10.dv = vcat(missing, diff(nikkei255_data_log10.value))
nikkei225_data_log10 = dropmissing(nikkei225_data_log10, [:dv])

print(nikkei225_data)
print(nikkei225_data_log10)

fig = Figure(size = (900, 450))
ax = Axis(fig[1, 1], xlabel = "time (year)", ylabel = "value", title = "value vs time")
lines!(ax, nikkei225_data.time, nikkei225_data.dv; linewidth = 0.6)
bx = Axis(fig[2, 1], xlabel = "time (year)", ylabel = "log10 value", title = "value vs time")
lines!(bx, nikkei225_data_log10.time, nikkei225_data_log10.dv; linewidth = 0.6)

fig
