using Plots

mutable struct Agent
    infulState       :: UInt8
    family_id        :: UInt32
    org_id           :: UInt32
    count_of_contact :: UInt32
end

function initInhabitans(inhabitants::Array{Agent,1}, NumberOfAgent::Int64)
    for i::Int64 in 1:NumberOfAgent
        agent = Agent(0,div(i,4),0,0)
        push!(inhabitants, agent)
    end
end

NumberOfAgent = 10000

inhabitants = Array{Agent,1}()

sizehint!(inhabitants, NumberOfAgent)

initInhabitans(inhabitants, NumberOfAgent)

familycell = Array{Array{Agent,1},1}()
for i=1:div(NumberOfAgent,4)
    push!(familycell,[inhabitants[(i-1)*4+1],inhabitants[(i-1)*4+2],inhabitants[(i-1)*4+3],inhabitants[(i-1)*4+4]])
end

function create_familycell_array(familycell)
    familycell_array = zeros(UInt8,100,100)
    id = 1
    for i=1:50,j=1:50
        println("($i,$j)")
        familycell_array[2*(i-1)+1,2*(j-1)+1] = familycell[id][1].infulState
        familycell_array[2*(i-1)+2,2*(j-1)+1] = familycell[id][2].infulState
        familycell_array[2*(i-1)+1,2*(j-1)+2] = familycell[id][3].infulState
        familycell_array[2*(i-1)+2,2*(j-1)+2] = familycell[id][4].infulState
        id = id + 1
    end
    return familycell_array
end

familycell_array = create_familycell_array(familycell)

println(familycell_array)

heatmap(familycell_array)

#=
anim = Animation()

for i in 1:10
    graph_plot = plot(t->sinpi(t+i/5), range(0, 2, length=100), label="sin(t)")
    plot!(graph_plot,t->cospi(t+i/5), range(0, 2, length=100), label="cos(t)")
    frame(anim, graph_plot)
end

gif(anim, "plot.gif", fps=15)
=#
