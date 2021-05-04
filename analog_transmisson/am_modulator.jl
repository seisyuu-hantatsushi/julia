using Plots
using JLD2

struct SimParam
    samplingrate::Float64
end

function sin_generator(freq, t)
    sin(2*pi*t*freq)
end

function main()
    simparam = SimParam(100*1000*1000)
    mod_ratio = 0.8

    f_t = open("time.dat","w")
    f_w_s = open("w_s.dat", "w");
    f_w_c = open("w_c.dat", "w");
    f_w_m = open("w_m.dat", "w");

    for step in 1:100*1000*1000
        t = step/simparam.samplingrate
        w_s = sin_generator(100, t)
        #w_s = 0
        w_c = sin_generator(954*1000, t)
        w_m = (1+mod_ratio*w_s)*w_c
        write(f_t, t)
        write(f_w_c, w_c)
        write(f_w_s, w_s)
        write(f_w_m, w_m)
    end
    close(f_w_m)
    close(f_w_c)
    close(f_w_s)
    close(f_t)

    times = []
    w_m_vals = []
    open("time.dat","r") do f_t
        open("w_m.dat","r") do f_w_m
            for step in 1:10*1000*1000
                t = read(f_t, Float64)
                w_m = read(f_w_m, Float64)
                push!(times, t)
                push!(w_m_vals, w_m)
            end
        end
    end


    plot_graph=plot(times, w_m_vals, fmt =:png)
    #plot!(plot_graph,times,w_c_vals)
    #plot!(plot_graph,times,w_m_vals)

    #gui(plot_graph)

    savefig(plot_graph,"signal.png")

    jldopen(ARGS[1],"w") do file
        file["samplingrate"] = simparam.samplingrate

        vals = []
        open("time.dat","r") do f
            while !eof(f_t)
                push!(vals, read(f, Float64))
            end
        end
        file["times"] = vals

        vals = []
        open("w_s.dat","r") do f
            while !eof(f)
                push!(vals, read(f, Float64))
            end
        end
        file["w_s"] = vals

        vals = []
        open("w_c.dat","r") do f
            while !eof(f)
                push!(vals, read(f, Float64))
            end
        end
        file["w_c"] = vals

        vals = []
        open("w_m.dat","r") do f
            while !eof(f)
                push!(vals, read(f, Float64))
            end
        end
        file["w_m"] = vals

    end

    rm("time.dat")
    rm("w_s.dat");
    rm("w_c.dat");
    rm("w_m.dat");
end

main()
