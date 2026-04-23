using CSV,DataFrames
using RollingFunctions, Statistics
using CairoMakie

temperature_data = CSV.read("../R_scripts/csv_out/Temperature.csv", DataFrame)

temperature_data_ma3 = temperature_data[1+1:end-1, :]
temperature_data_ma3.value = rolling(median, temperature_data.value, 3)

temperature_data_ma17 = temperature_data[1+8:end-8, :]
temperature_data_ma17.value = rolling(median, temperature_data.value, 17)

temperature_data_ma29 = temperature_data[1+14:end-14, :]
temperature_data_ma29.value = rolling(median, temperature_data.value, 29)

fig = Figure(size = (900, 450))

day_graph = Axis(fig[1, 1], xlabel = "day", ylabel = "temp", title = "dialy high temp")
lines!(day_graph, temperature_data.time, temperature_data.value, linewidth=0.6)

ma3_graph = Axis(fig[1, 2], xlabel = "day", ylabel = "temp median", title = "3days moving median")
lines!(ma3_graph, temperature_data_ma3.time, temperature_data_ma3.value, linewidth=0.6)

ma17_graph = Axis(fig[2, 1], xlabel = "day", ylabel = "temp median", title = "17days moving median")
lines!(ma17_graph, temperature_data_ma17.time, temperature_data_ma17.value, linewidth=0.6);

ma29_graph = Axis(fig[2, 2], xlabel = "day", ylabel = "temp median", title = "29days moving median")
lines!(ma29_graph, temperature_data_ma29.time, temperature_data_ma29.value, linewidth=0.6)

fig

