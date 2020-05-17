using Plots
using Random
using StatsBase

#=
 所属ID 0      家庭のみ
        1-40   社会組織
        41-60  学校

 地域ID 1-10   住宅地
        11-15  オフィス街
=#

NumberOfAgent   = 10000
NumberOfCompany = 40

mutable struct Agent
    infulState       :: UInt8
    org_id           :: UInt32
    count_of_contact :: UInt32
end

struct Family
    region     :: UInt16
    member_ids :: Array{UInt32,1}
end

struct Company
    region     :: UInt16
    member_ids :: Array{UInt32,1}
    table      :: Array{UInt32,2}
end

struct School
    member_ids :: Array{UInt32,1}
    table      :: Array{UInt32,2}
end

struct Vehicle
    passenger::Array{UInt32, 2} # 4x200 = 800
end

function initInhabitans(NumberOfAgent::Int64)

    inhabitants = Array{Agent,1}()
    families = Array{Family,1}()

    sizehint!(inhabitants, NumberOfAgent)

    parent_org_ids = zeros(UInt32,5000)

    # 所属IDを作成
    for i in 1:length(parent_org_ids)-1000
        parent_org_ids[i] = rem(i,40)+1 # 1-40
    end

    shuffle!(parent_org_ids)
    let
        hist = zeros(UInt32,5000)

        for i in 1:length(parent_org_ids)
            hist[parent_org_ids[i]+1]=hist[parent_org_ids[i]+1]+1
        end
        for i in 1:41
            j = i-1
            histj=hist[i]
            #println("$j,$histj")
        end
        #println(hist)
    end

    # 地域は1-10
    j=1
    for i::Int64 in 1:div(NumberOfAgent,4)

        region = div(i-1,250)+1
        # parent1
        push!(inhabitants, Agent(0,parent_org_ids[j],0))
        j += 1
        # parent2
        push!(inhabitants, Agent(0,parent_org_ids[j],0))
        j += 1

        # child 1
        push!(inhabitants, Agent(0,41+(region-1)*2,0))

        # child 2
        push!(inhabitants, Agent(0,41+(region-1)*2+1,0))


        push!(families,
              Family(region, [(i-1)*4+1,(i-1)*4+2,(i-1)*4+3,(i-1)*4+4]))
    end

    println("num of family: $(length(families))")

    #=
    num_family_in_region = zeros(Int64,10);
    for i in 1:length(families)
        println("family $i -> region: $(families[i].region)")
        num_family_in_region[families[i].region] += 1
    end

    for i in 1:length(num_family_in_region)
        println("region $i -> num of family : $(num_family_in_region[i])")
    end

    num_family_in_region = zeros(Int64,10)
    for i in 1:length(families)
        num_family_in_region[families[i].region] += 4
    end

    num_students_in_school = zeros(Int64,20)
    for i in 1:length(inhabitants)
        if 41 <= inhabitants[i].org_id <= 60
            num_students_in_school[inhabitants[i].org_id-40]+=1
        end
    end

    for i in 1:length(num_students_in_school)
        println("school $i -> num of student : $(num_students_in_school[i])")
    end
    =#

    return inhabitants, families;
end

function initCompany(inhabitans)

    companies = Array{Company,1}()

    for i in 1:NumberOfCompany
        push!(companies,Company(div(i-1,8)+11,[],zeros(UInt32, 10, 10)))
    end

    for i in 1:length(inhabitans)
        if 0 < inhabitans[i].org_id <= 40
            push!(companies[inhabitans[i].org_id].member_ids,i)
        end
    end

    # 席配置
    for i in 1:length(companies)
        #println("company $i -> region $(companies[i].region)")
        l = 1
        for j=1:10, k=1:10
            companies[i].table[j,k] = companies[i].member_ids[l]
            l = l + 1
        end
    end

    return companies
end

function initSchool(inhabitants)
    schools = Array{School,1}()

    for i in 1:20
        push!(schools,School([],zeros(UInt32,10,25)))
    end

    for i in 1:length(inhabitants)
        if 41 <= inhabitants[i].org_id <= 60
            schoolid = inhabitants[i].org_id-40
            push!(schools[schoolid].member_ids,i)
        end
    end

    for i in 1:length(schools)
        m = copy(schools[i].member_ids)
        shuffle!(m)
        for j=1:10,k=1:25
            schools[i].table[j,k] = m[(j-1)*25+k];
        end
    end

    return schools;
end

function ride_vehicles(companies::Array{Company,1},inhabitants::Array{Agent,1})
    vehicles = Array{Vehicle,1}()
    to_region_passengers = Array{Array{UInt32,1},1}()
    #num_of_p_in_region = zeros(UInt32, 5)

    for i in 11:15
        push!(to_region_passengers,[])
    end

    for i in 11:15, j in 1:length(companies)
        if companies[j].region == i
            #println("company $j -> $(companies[j].region)")
            #num_of_p_in_region[i-10] += length(companies[j].member_ids)
            to_region_passengers[i-10] = append!(to_region_passengers[i-10],companies[j].member_ids)
        end
    end
    #=
    for i in 1:length(to_region_passengers)
        println("region $i -> $(length(to_region_passengers[i]))")
    end
    =#
    for i in 1:5
        shuffle!(to_region_passengers[i])
        push!(vehicles,Vehicle(reshape(to_region_passengers[i],4,200)))
    end
    return vehicles
end

function create_familycell_array(families,inhabitans)
    familycell_array = zeros(UInt8,100,100)
    id = 1
    for i=1:50,j=1:50
        #println("($i,$j)")
        familycell_array[2*(i-1)+1,2*(j-1)+1] = inhabitans[families[id].member_ids[1]].infulState
        familycell_array[2*(i-1)+2,2*(j-1)+1] = inhabitans[families[id].member_ids[2]].infulState
        familycell_array[2*(i-1)+1,2*(j-1)+2] = inhabitans[families[id].member_ids[3]].infulState
        familycell_array[2*(i-1)+2,2*(j-1)+2] = inhabitans[families[id].member_ids[4]].infulState
        id = id + 1
    end
    return familycell_array
end

function create_company_plots(companies::Array{Company,1},inhabitants::Array{Agent,1})

    company_plots = Array{Plots.Plot,1}()

    for i in 1:length(companies)
        cell = zeros(UInt8,10,10)
        for j=1:10, k=1:10
            cell[j,k] = inhabitants[companies[i].table[j,k]].infulState
        end
        push!(company_plots,heatmap(cell,
                                    c=cgrad(:matter,3),
                                    legend=false,
                                    xlims=(1,10),
                                    title="company $i"))
    end

    println("plots = $(length(company_plots))")

    return plot(company_plots[1],company_plots[2], company_plots[3], company_plots[4], company_plots[5],
                company_plots[6],company_plots[7], company_plots[8], company_plots[9], company_plots[10],
                company_plots[11],company_plots[12], company_plots[13], company_plots[14], company_plots[15],
                company_plots[16],company_plots[17], company_plots[18], company_plots[19], company_plots[20],
                company_plots[21],company_plots[22], company_plots[23], company_plots[24], company_plots[25],
                company_plots[26],company_plots[27], company_plots[28], company_plots[29], company_plots[30],
                company_plots[31],company_plots[32], company_plots[33], company_plots[34], company_plots[35],
                company_plots[36],company_plots[37], company_plots[38], company_plots[39], company_plots[40],
                layout=(5,8))
end

function create_school_plots(schools::Array{School,1}, inhabitants)
    school_plots = Array{Plots.Plot,1}()
    for i in 1:length(schools)
        cell = zeros(UInt8,10,25)
        for j=1:10, k=1:25
            cell[j,k] = inhabitants[schools[i].table[j,k]].infulState
        end
        push!(school_plots,heatmap(cell,
                                   c=cgrad(:matter,3),
                                   legend=false,
                                   title="school $i"))
    end
    return plot(school_plots[1],school_plots[2],school_plots[3],school_plots[4],
                school_plots[5],school_plots[6],school_plots[7],school_plots[8],
                school_plots[9],school_plots[10],school_plots[11],school_plots[12],
                school_plots[13],school_plots[14],school_plots[15],school_plots[16],
                school_plots[17],school_plots[18],school_plots[19],school_plots[20],
                layout=(5,4))
end

function create_vehilcle_plots(vehilcles::Array{Vehicle,1}, inhabitants::Array{Agent,1})

    vehilcle_plots = Array{Plots.Plot,1}()
    for i in 1:length(vehilcles)
        cell = zeros(UInt8,4,200)
        for j=1:4, k=1:200
            cell[j,k] = inhabitants[vehilcles[i].passenger[j,k]].infulState
        end
        push!(vehilcle_plots,heatmap(cell,
                                     c=cgrad(:matter,3),
                                     legend=false,
                                     title="vehilcle $i"))
    end
    println(length(vehilcle_plots))
    return plot(vehilcle_plots[1],
                vehilcle_plots[2],
                vehilcle_plots[3],
                vehilcle_plots[4],
                vehilcle_plots[5],
                layout = (5,1))
end

inhabitants,families = initInhabitans(NumberOfAgent)

inhabitants[1].infulState = 1
inhabitants[2].infulState = 1
inhabitants[3].infulState = 1
inhabitants[4].infulState = 1

#println(familycell_array)

companies = initCompany(inhabitants)
schools = initSchool(inhabitants)

for d in 1:1
    # 3時間が通勤時間
    # 8時間が会社
    # 学校を11時間
    # 家を13時間
    vehilcles = ride_vehicles(companies, inhabitants)
end

family_plot = heatmap(create_familycell_array(families,inhabitants),
                      c=cgrad(:matter,3,categorical=true),
                      legend=false,
                      gridstyle=:solid,
                      title="family")

company_plot  = create_company_plots(companies, inhabitants)

school_plot   = create_school_plots(schools, inhabitants)

vehilcle_plot = create_vehilcle_plots(vehilcles, inhabitants)

plot(family_plot,
     school_plot,
     company_plot,
     vehilcle_plot,
     layout=@layout[a c; b; d],legend=false,size=(2600,2200))



#=
anim = Animation()

for i in 1:10
    graph_plot = plot(t->sinpi(t+i/5), range(0, 2, length=100), label="sin(t)")
    plot!(graph_plot,t->cospi(t+i/5), range(0, 2, length=100), label="cos(t)")
    frame(anim, graph_plot)
end

gif(anim, "plot.gif", fps=15)
=#
