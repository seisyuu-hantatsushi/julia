using Plots,FFTW,JLD2

function sqaure_windowing_signal(signal::Array{Float64})
    windowed_signal = signal
    window_correction_factor = 1
    return (windowed_signal,window_correction_factor)
end

function hanning_windowing_signal(signal::Array{Float64})
    windowed_signal::Array{Float64} = []
    window::Array{Float64} = []
    total_window_power = 0
    j = 1
    for w = signal
        window_val = 0.5*(1 - cos(2*pi*j/length(signal)))
        push!(window,window_val)
        windowed = window_val*w
        push!(windowed_signal, windowed)
        total_window_power += window_val
        j += 1
    end
    window_correction_factor = length(signal)/total_window_power
    return (windowed_signal,window_correction_factor)
end

function main()
    sampling_rate = 0
    window_size = 64*1024*1024
    w_fm_vals::Array{Float64} = []

    jldopen(ARGS[1],"r") do f
        sampling_rate = f["samplingrate"]
        w_fm_vals = f["w_fm"]
    end

    (windowed_signal, window_correction_factor) = sqaure_windowing_signal(w_fm_vals[1:window_size])

    powers = map(x->20*log10(abs(x)*window_correction_factor),fft(windowed_signal)|>fftshift)
    freqs = fftfreq( window_size, sampling_rate )|>fftshift

    println(freqs)

    plot_graph=plot(freqs, powers, size=(2000,700), fmt =:png)
    savefig(plot_graph, "fm_fft1.png")

    plot_graph=plot(freqs, powers, xlims=(7.6*10^6, 8.0*10^6), size=(2000,700), fmt =:png)
    savefig(plot_graph, "fm_fft2.png")

end

main()
