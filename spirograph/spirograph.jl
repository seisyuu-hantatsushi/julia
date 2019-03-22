using ArgParse
using Plots

function x_mother(c,omega,t)
    return cos(t)+c*cos(omega*t)
end

function y_mother(c,omega,t)
    return sin(t)+c*sin(omega*t)
end

function main()

    s = ArgParseSettings()
    @add_arg_table s begin
        "--output","-o"
        help = "output graph image file"
        arg_type = String
        default = "output.png"
        "-c"
        help = "coeff c"
        arg_type = Float64
        default = 1.0
        "-w"
        help = "coeff w"
        arg_type = Float64
        default = 1.0
    end

    parsed_args = parse_args(s);
    for (arg,val) in parsed_args
        println("   $arg => $val")
    end

    c = parsed_args["c"]
    w = parsed_args["w"]
    x(t) = x_mother(c,w,t)
    y(t) = y_mother(c,w,t)

    plot(x, y, 0:0.01:1000,aspect_ratio=1.0)

    savefig(parsed_args["output"])

end

main()
