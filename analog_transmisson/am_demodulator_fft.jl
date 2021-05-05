using Plots,FFTW,JLD2

function main()
    sampling_rate = 0.0
    window_size = 64*1024;
    w_m_vals::Array{Float64} = []

    jldopen(ARGS[1], "r") do f
        sampling_rate = f["samplingrate"]
        w_m_vals = f["w_m"]
    end

    f_t = open("time_fft.dat", "w")
    f_i = open("I_fft.dat", "w")
    f_q = open("Q_fft.dat", "w")
    f_am_p = open("am_fft.dat", "w")

    duration = 2500000
    dt = 1/sampling_rate
    for t in 1:duration
        I::Float64 = 0
        Q::Float64 = 0
        spectrum = fft(w_m_vals[t:window_size+t-1])|>fftshift
        I = real(spectrum[32*1024+626])/window_size
        Q = -imag(spectrum[32*1024+626])/window_size
        A = 2.0*sqrt(I^2+Q^2)
        write(f_t, t*dt)
        write(f_i, I)
        write(f_q, Q)
        write(f_am_p, A)
    end
    close(f_am_p)
    close(f_q)
    close(f_i)
    close(f_t)

    timeline::Array{Float64}=[]
    power::Array{Float64}=[]
    open("time_fft.dat","r") do f_t
        open("am_fft.dat","r") do f_am
            for step in 1:1000*1000
                t = read(f_t, Float64)
                p = read(f_am, Float64)
                push!(timeline, t)
                push!(power, p)
            end
        end
    end
    plot_graph=plot(timeline, power, fmt=:png)
    savefig(plot_graph, "demodulate_fft_am.png")

    jldopen("am_demodulate_fft.jld2","w") do file
        file["samplingrate"] = sampling_rate

        vals = []
        open("time.dat","r") do f
            while !eof(f_t)
                push!(vals, read(f, Float64))
            end
        end
        file["times"] = vals

        vals = []
        open("I.dat","r") do f
            while !eof(f)
                push!(vals, read(f, Float64))
            end
        end
        file["I"] = vals

        vals = []
        open("Q.dat","r") do f
            while !eof(f)
                push!(vals, read(f, Float64))
            end
        end
        file["Q"] = vals

        vals = []
        open("am.dat","r") do f
            while !eof(f)
                push!(vals, read(f, Float64))
            end
        end
        file["demodulated_signal"] = vals

    end

    rm("time_fft.dat")
    rm("I_fft.dat")
    rm("Q_fft.dat")
    rm("am_fft.dat")


end

main()
