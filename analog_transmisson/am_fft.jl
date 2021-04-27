using FFTW
using JLD2

for (ind, arg) in enumerate(ARGS)
    t = typeof(arg)
    msg = "$(ind) -> $arg :$t"
    println(msg)
end

function main()
    sampling_rate = 0.0
    jldopen(ARGS[1], "r") do f
        sampling_rate = f["samplingrate"]
    end

    println(sampling_rate)
end

main()
