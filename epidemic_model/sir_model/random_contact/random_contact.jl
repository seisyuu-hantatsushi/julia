
using StatsBase

N = 10000
recover_day = 10
days = 360

persons_state = zeros(Int32, N)
infected = sample(1:N,1)

for i in infected
    persons_state[i] = 1
end

R0=2
γ=1/(recover_day*contant_time_per_day)
β=γ*R0/(N-1)

result = []
for d in 1:days

    # 感染の判定
    new_infected = []
    for i in 1:length(persons_state)
        if (persons_state[i] == 1) && i ∉ new_infected
            for j in 1:length(persons_state)
                if persons_state[j] == 0 && j != i
                    b = rand()
                    if b < β
                        persons_state[j] = 1
                        push!(new_infected,j)
                    end
                end
            end
        end
    end

    # 回復の判定
    for i in 1:length(persons_state)
        if persons_state[i] == 1
            r = rand()
            if r <= γ
                persons_state[i] = 2
            end
        end
    end

    # 人数を数える
    S = 0
    I = 0
    R = 0
    for i in 1:length(persons_state)
        if persons_state[i] == 0
            S = S + 1
        elseif  persons_state[i] == 1
            I = I + 1
        else
            R = R + 1
        end
    end

    SIR=(d, [S,I,R])

    println("$SIR")

    push!(result, SIR)
end

plot_graph = plot(map(t->t[1][1], result),map(t->t[2][1], result))
plot!(plot_graph, map(t->t[1][1], result),map(t->t[2][2], result))
plot!(plot_graph, map(t->t[1][1], result),map(t->t[2][3], result))

display(plot_graph)
