using UUIDs,Plots,JLD2

function sin_generator(freq, t)
    sin(2*pi*t*freq)
end

function draw_graph(time_dat_path::String,
                    w_c_dat_path::String,
                    w_s_dat_path::String,
                    w_fm_dat_path::String)


    timeline::Array{Float64} = []
    w_fm_vals::Array{Float64} = []
    w_c_vals::Array{Float64} = []
    w_s_vals::Array{Float64} = []

    open(time_dat_path,"r") do f_t
        open(w_c_dat_path,"r") do f_c
            open(w_s_dat_path,"r") do f_s
                open(w_fm_dat_path,"r") do f_fm 
                    

                    #plot_graph=plot(timeline, w_s_vals, xlims=(0.0,1/1000), size=(2000,480), fmt =:png)
                    #plot!(plot_graph, timeline, w_fm_vals)
                    #plot!(plot_graph, timeline, w_c_vals)
                    
                    #plot_graph=plot(timeline, w_fm_vals, xlims=(0.0003,0.0003+0.000005), size=(2000,700), fmt =:png)
                    #plot!(plot_graph, timeline, w_s_vals)
                    #plot!(plot_graph, timeline, w_c_vals)
                    #savefig(plot_graph,"fm_signal.png")
                    
                    #plot_graph=plot(timeline, w_fm_vals, xlims=(0.0007,0.0007+0.000005), size=(2000,700), fmt =:png)
                    #plot!(plot_graph, timeline, w_s_vals)
                    #plot!(plot_graph, timeline, w_c_vals)
                    #savefig(plot_graph,"fm_signal_2.png")
                    
                    #plot_graph=plot(timeline, w_fm_vals, xlims=(0.0005,0.0005+0.000005), size=(2000,700), fmt =:png)
                    #plot!(plot_graph, timeline, w_s_vals)
                    #plot!(plot_graph, timeline, w_c_vals)
                    #savefig(plot_graph,"fm_signal_3.png")
                end
            end
        end
    end
end

function main()

    uuid = uuid4()

    println(string(uuid))

    mkdir(string(uuid))

    time_dat_path = string(uuid) * "/time.dat"
    w_c_dat_path  = string(uuid) * "/w_c.dat"
    w_s_dat_path  = string(uuid) * "/w_s.dat"
    w_fm_dat_path = string(uuid) * "/w_fm.dat"


    # f_s_max = 22KHz
    # channel spacing 200kHz
    # frequnency deviation delta_f=75kHz
    # should be carrier_freq > delta_f
    carrier_freq  =      7780*1000 #7.78MHz
    sampling_rate =  100*1000*1000
    Δt = 1/sampling_rate
    Δf = 75*1000
    accumulate = 0

    f_t  = open(time_dat_path, "w")
    f_c  = open(w_c_dat_path,  "w")
    f_s  = open(w_s_dat_path,  "w")
    f_fm = open(w_fm_dat_path, "w")

    for step in 1:100*1000*1000
        t = step/sampling_rate
        w_s = sin_generator(1000, t)
        accumulate += w_s*Δt
        #println(2*pi*Δf*accumulate)
        w_c = sin(2*pi*carrier_freq*t)
        w_fm = sin(2*pi*carrier_freq*t+2*pi*Δf*accumulate)
        write(f_t, t)
        write(f_c, w_c)
        write(f_s, w_s)
        write(f_fm, w_fm)
    end

    close(f_fm)
    close(f_s)
    close(f_c)
    close(f_t)

    jldopen(ARGS[1],"w") do file
        file["samplingrate"] = sampling_rate

        vals = []
        open(time_dat_path,"r") do f
            while !eof(f_t)
                push!(vals, read(f, Float64))
            end
        end
        file["times"] = vals

        vals = []
        open(w_s_dat_path,"r") do f
            while !eof(f)
                push!(vals, read(f, Float64))
            end
        end
        file["w_s"] = vals

        vals = []
        open(w_c_dat_path,"r") do f
            while !eof(f)
                push!(vals, read(f, Float64))
            end
        end
        file["w_c"] = vals

        vals = []
        open(w_fm_dat_path,"r") do f
            while !eof(f)
                push!(vals, read(f, Float64))
            end
        end
        file["w_fm"] = vals
    end

    rm(string(uuid), force=true, recursive=true)
end


main()
