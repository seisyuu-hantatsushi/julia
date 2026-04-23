using CSV, DataFrames
using CairoMakie

hakusan_data = CSV.read("../R_scripts/csv_out/HAKUSAN.csv", DataFrame)

function draw_hist(fig, bin_width, xtick_step, title, xlabel, data)
    lower_edge = floor(Int, minimum(data) / bin_width) * bin_width
    upper_edge = ceil(Int, maximum(data) / bin_width) * bin_width

    if lower_edge == upper_edge
        upper_edge += bin_width
    end
    bin_edges = lower_edge:bin_width:upper_edge

    ax = Axis(
        fig,
        title = title,
        xlabel = xlabel,
        ylabel = "Frequency",
        xticks = lower_edge:xtick_step:upper_edge
    )
    hist!(
        ax,
        data;
        bins = bin_edges,
        color = (:steelblue, 0.75),
        strokecolor = :black,
        strokewidth = 1,
    )
end
fig = Figure()

rolling = collect(skipmissing(hakusan_data.Rolling))
draw_hist(fig[1, 1], 1, 2, "Histogram of Rolling", "Rolling", rolling)

yawrate = collect(skipmissing(hakusan_data.YawRate))
draw_hist(fig[2, 1], 1, 2, "Histgram of YawRate", "YawRate", yawrate)

save("hakusan_hist.png", fig)

fig
