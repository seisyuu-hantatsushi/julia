x  = -5.0:0.1:5.0

f(x) = 1.0 ./ (1 .+ exp.(-x))

println("Start Plot")
using Plots
plot(x,f(x))

println("save Plot")
savefig("sigmoid.png")
