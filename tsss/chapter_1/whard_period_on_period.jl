using CSV, DataFrames, ShiftedArrays
using CairoMakie

whard_data = CSV.read("../R_scripts/csv_out/WHARD.csv", DataFrame)

whard_data.lag_month = ShiftedArrays.lag(whard_data.value, 1);
whard_data.lag_year  = ShiftedArrays.lag(whard_data.value, 12);

whard_data.month_ratio = whard_data.value ./ whard_data.lag_month;
whard_data.year_ratio  = whard_data.value ./ whard_data.lag_year;

whard_data_mom = dropmissing(whard_data, [:month_ratio])
whard_data_yoy = dropmissing(whard_data, [:year_ratio])

print(whard_data_mom)
print(whard_data_yoy)

fig = Figure(size = (900, 450))

month_ratio = Axis(fig[1, 1], xlabel = "month", ylabel = "month ratio", title = "month on month")
lines!(month_ratio, whard_data_mom.time, whard_data_mom.month_ratio, linewidth=0.6)

year_ratio = Axis(fig[2, 1], xlabel = "month", ylabel = "year ratio", title = "year on year")
lines!(year_ratio, whard_data_yoy.time, whard_data_yoy.year_ratio, linewidth=0.6)

fig
