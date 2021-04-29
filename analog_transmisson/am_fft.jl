using Plots,FFTW
using JLD2

for (ind, arg) in enumerate(ARGS)
    t = typeof(arg)
    msg = "$(ind) -> $arg :$t"
    println(msg)
end

function sqaure_windowing_signal(signal::Array{Float64})
    windowed_signal = signal
    window_correction_factor = 1
    return (windowed_signal,window_correction_factor)
end

function hamming_windowing_signal(signal::Array{Float64})
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
    sampling_rate = 0.0
    window_size = 64*1024*1024;
    w_m_vals::Array{Float64} = []

    jldopen(ARGS[1], "r") do f
        sampling_rate = f["samplingrate"]
        w_m_vals = f["w_m"]
    end

    println(sampling_rate)
    println(length(w_m_vals))

    #(windowed_signal, window_correction_factor)  = sqaure_windowing_signal(w_m_vals[1:window_size])
    (windowed_signal, window_correction_factor) = hamming_windowing_signal(w_m_vals[1:window_size])
    println(window_correction_factor)
    powers = map(x->20*log10(abs(x)*window_correction_factor),fft(windowed_signal)|>fftshift)
    freqs = fftfreq( window_size, sampling_rate )|>fftshift

    plot_graph=plot(freqs, powers, xlims=(0,2000*1000), fmt =:png)
    savefig(plot_graph, "fft1.png")
    plot_graph=plot(freqs, powers, xlims=(944*1000,964*1000), fmt =:png)
    savefig(plot_graph, "fft2.png")
end

main()
