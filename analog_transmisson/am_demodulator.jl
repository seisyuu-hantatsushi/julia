using FFTW,JLD2,Plots

function main()
    carrier_freq = 954*1000
    sampling_rate::Float64 = 0.0
    w_m_vals::Array{Float64} = []
    band_width::Float64 = 1.0/(20*1000)

    jldopen(ARGS[1], "r") do f
        sampling_rate = f["samplingrate"]
        w_m_vals = f["w_m"]
    end

    window_size = round(Int,band_width*sampling_rate)

    println("samplingrate: $sampling_rate")
    println("window_size: $window_size")

    f_t = open("time.dat", "w")
    f_i = open("I.dat", "w")
    f_q = open("Q.dat", "w")
    f_am_p = open("am.dat", "w")

    dt = 1/sampling_rate
    # duration = length(w_m_vals)-window_size
    duration = 2500000
    for t in 0:duration
        I::Float64 = 0
        Q::Float64 = 0
        for n in 1:window_size
            I += w_m_vals[t+n]*cos(2*pi*carrier_freq*dt*(n-1))
            Q += w_m_vals[t+n]*sin(2*pi*carrier_freq*dt*(n-1))
        end
        I /= window_size;
        Q /= window_size;
        A = 2.0*sqrt(I^2+Q^2)
        write(f_t, dt*t)
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
    open("time.dat","r") do f_t
        open("am.dat","r") do f_am
            for step in 1:1000*1000
                t = read(f_t, Float64)
                p = read(f_am, Float64)
                push!(timeline, t)
                push!(power, p)
            end
        end
    end
    plot_graph=plot(timeline, power, fmt=:png)
    savefig(plot_graph, "demodulate_am.png")

    jldopen("am_demodulate.jld2","w") do file
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

    rm("time.dat")
    rm("I.dat")
    rm("Q.dat")
    rm("am.dat")

end

main()
