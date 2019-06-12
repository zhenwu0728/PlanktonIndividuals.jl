# set up a series of agents following a normal distribution
function setup_agents(N::Int64,Cquota::Array,Nn::Int64,mean::Float64,var::Float64,grid)
    phyts0 = DataFrame(x=Float64[], y=Float64[], z=Float64[], gen=Int64[], size=Float64[], Cq1=Float64[], Cq2=Float64[], Nq=Float64[], chl=Float64[], sp=Int64[])
    for i in 1:N
        # agent location
        x = 1
        y = 1
        z = rand(3.5*10:grid.Nz*8)/10
        # a normal distribution with mean variance
        radm = max(0.05, rand(Normal(mean,var)))
        gen  = 1
        size = radm
        Cq1  = Cquota[1]*Nn # Nn is the number of cells one super agent repersents
        Cq2  = Cquota[1]*Nn*radm
        Nq   = 13/106*2*Cq2
        chl  = Cq2*0.4
        sp   = 1
        push!(phyts0,(x=x,y=y,z=z,gen=gen,size=size,Cq1=Cq1,Cq2=Cq2,Nq=Nq,chl=chl,sp=sp))
    end
    for i in N+1:2N
        # agent location
        x = 1
        y = 1
        z = rand(3.5*10:grid.Nz*8)/10
        # a normal distribution with mean variance
        radm = max(0.05, rand(Normal(mean,var)))
        gen  = 1
        size = radm
        Cq1  = Cquota[2]*Nn
        Cq2  = Cquota[2]*Nn*radm
        Nq   = 13/106*2*Cq2
        chl  = Cq2*0.4
        sp   = 2
        push!(phyts0,(x=x,y=y,z=z,gen=gen,size=size,Cq1=Cq1,Cq2=Cq2,Nq=Nq,chl=chl,sp=sp))
    end
    B = [phyts0]
    return B
end

# set up initial nutrients fields according to grids
# nut is an array of 6 elements, each element is a kind of nutrient
function setup_nutrients(g,nut)
    DIC = zeros(g.Nx, g.Ny, g.Nz)
    DIN = zeros(g.Nx, g.Ny, g.Nz)
    DOC = zeros(g.Nx, g.Ny, g.Nz)
    DON = zeros(g.Nx, g.Ny, g.Nz)
    POC = zeros(g.Nx, g.Ny, g.Nz)
    PON = zeros(g.Nx, g.Ny, g.Nz)
    for i in 1:1
        for j in 1:1 
            for k in 1:Int(0.625*g.Nz)
                DIC[i, j, k] = DIC[i, j, k] + nut[1]
                DIN[i, j, k] = DIN[i, j, k] + nut[2]*0.5
                DOC[i, j, k] = DOC[i, j, k] + nut[3]
                DON[i, j, k] = DON[i, j, k] + nut[4]
                POC[i, j, k] = POC[i, j, k] + nut[5]
                PON[i, j, k] = PON[i, j, k] + nut[6]
            end
            for k in Int(0.625*g.Nz)+1:Int(0.80*g.Nz)
                DIC[i, j, k] = DIC[i, j, k] + nut[1]
                DIN[i, j, k] = DIN[i, j, k] + nut[2]*1.0
                DOC[i, j, k] = DOC[i, j, k] + nut[3]
                DON[i, j, k] = DON[i, j, k] + nut[4]
                POC[i, j, k] = POC[i, j, k] + nut[5]
                PON[i, j, k] = PON[i, j, k] + nut[6]
            end
        end
    end
    nutrients = nutrient_fields(DIC, DIN, DOC, DON, POC, PON)
    return nutrients
end


