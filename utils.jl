function read_input(csv::String,myTime::Int64)
    # irradiance(μmol photons/m^2) and temperature
    # will change later to make it able to choose different month
    input = CSV.read(csv)
    days=myTime÷24 
    temp = copy(input.Temp_Aug)
    for i in 1:days-1
        tt = copy(input.Temp_Aug)
        tt = append!(temp,tt)
    end
    IR = copy(input.IR_Aug)
    for i in 1:days-1
        tt = copy(input.IR_Aug)
        tt = append!(IR,tt)
    end
    return temp,IR
end
function read_offline_vels(vfroot::String,itList,tN,t::Int64)
    fwvel = open(vfroot*"/WVEL/_."*lpad(string(itList[t+tN]),10,"0")*".data")
    wvel = reverse(reinterpret(Float32,reverse(read(fwvel,))));
    close(fwvel);
    wvel = reshape(wvel, 1080, 2700, 90);
    # seletc grids
    u = zeros(Float64,1,1,40); v = zeros(Float64,1,1,40);
    w = zeros(Float64,1,1,40);
    u .= 0.0; v .= 0.0; w[1,1,:] = wvel[500,1500,1:40];
    vel = velocity(u, v, w)
    return vel
end
function grid_offline(fieldroot::String)
    nx=1080;ny=2700;nz=40;
    fxg = open(fieldroot*"XG.data","r");
    fyg = open(fieldroot*"YG.data","r");
    fxc = open(fieldroot*"XC.data","r");
    fyc = open(fieldroot*"YC.data","r");
    fdx = open(fieldroot*"DXG.data","r");
    fdy = open(fieldroot*"DYG.data","r");
    fdrf= open(fieldroot*"DRF.data","r");
    fdxc= open(fieldroot*"DXC.data","r");
    fdyc= open(fieldroot*"DYC.data","r");
    fdrc= open(fieldroot*"DRC.data","r");
    fAz = open(fieldroot*"RAC.data","r");
    fhfc= open(fieldroot*"hFacC.data","r");
    fhfs= open(fieldroot*"hFacS.data","r");
    fhfw= open(fieldroot*"hFacW.data","r");
    xf = reverse(reinterpret(Float32,reverse(read(fxg,))));
    yf = reverse(reinterpret(Float32,reverse(read(fyg,))));
    xc = reverse(reinterpret(Float32,reverse(read(fxc,))));
    yc = reverse(reinterpret(Float32,reverse(read(fyc,))));
    dx = reverse(reinterpret(Float32,reverse(read(fdx,))));
    dy = reverse(reinterpret(Float32,reverse(read(fdy,))));
    drf= reverse(reinterpret(Float32,reverse(read(fdrf,))));
    dxc= reverse(reinterpret(Float32,reverse(read(fdxc,))));
    dyc= reverse(reinterpret(Float32,reverse(read(fdyc,))));
    drc= reverse(reinterpret(Float32,reverse(read(fdrc,))));
    Az = reverse(reinterpret(Float32,reverse(read(fAz,))));
    hFC= reverse(reinterpret(Float32,reverse(read(fhfc,))));
    hFS= reverse(reinterpret(Float32,reverse(read(fhfs,))));
    hFW= reverse(reinterpret(Float32,reverse(read(fhfw,))));
    close(fxg);close(fyg);close(fxc);close(fyc);close(fdx);close(fdy);
    close(fdrf);close(fAz);close(fhfc);close(fhfs);close(fhfw);
    xf = reshape(xf,nx,ny); yf = reshape(yf,nx,ny); 
    xc = reshape(xc,nx,ny); yc = reshape(yc,nx,ny);
    dx = reshape(dx,nx,ny); dy = reshape(dy,nx,ny);
    dxc= reshape(dxc,nx,ny);dyc= reshape(dyc,nx,ny);
    Az = reshape(Az,nx,ny); hFC= reshape(hFC,nx,ny,nz);
    hFS= reshape(hFS,nx,ny,nz);hFW= reshape(hFW,nx,ny,nz);
    zf = -cumsum(drf); pushfirst!(zf,0); zc = 0.5*(zf[1:end-1]+zf[2:end]);
    Δx = (xf[2:end,:] .- xf[1:end-1,:]); # unit: degree
    Δy = (yf[:,2:end] .- yf[:,1:end-1]); # unit: degree
    Ax = zeros(nx,ny,nz); Ay = zeros(nx,ny,nz); V = zeros(nx,ny,nz);
    for i in 1:nx
        for j in 1:ny
            for k in 1:nz
                Ax[i,j,k] = drf[k] * dy[i,j] * hFW[i,j,k]
                Ay[i,j,k] = drf[k] * dx[i,j] * hFS[i,j,k]
                V[i,j,k] = drf[k] * Az[i,j] * hFC[i,j,k]
            end
        end
    end
    # seletc grids
    xcS = zeros(Float32,1,1); ycS = zeros(Float32,1,1);
    xfS = zeros(Float32,1,1); yfS = zeros(Float32,1,1);
    dxS = zeros(Float32,1,1); dyS = zeros(Float32,1,1);
    dxcS= zeros(Float32,1,1);dycS = zeros(Float32,1,1);
    ΔxS = zeros(Float32,1,1); ΔyS = zeros(Float32,1,1);
    AzS = zeros(Float32,1,1); AxS = zeros(Float32,1,1,40);
    AyS = zeros(Float32,1,1,40); VS = zeros(Float32,1,1,40);
    xcS[1,1] = xc[500,1500]; ycS[1,1] = yc[500,1500];
    xfS[1,1] = xf[500,1500]; yfS[1,1] = yf[500,1500];
    dxS[1,1] = dx[500,1500]; dyS[1,1] = dy[500,1500];
    dxcS[1,1]= dxc[500,1500];dycS[1,1]= dyc[500,1500];
    ΔxS[1,1] = Δx[500,1500]; ΔyS[1,1] = Δy[500,1500];
    AzS[1,1] = Az[500,1500]; AxS[1,1,:] = Ax[500,1500,:];
    AyS[1,1,:] = Ay[500,1500,:];VS[1,1,:] = V[500,1500,:];
    g = grids(xcS, ycS, zc, xfS, yfS, zf, ΔxS, ΔyS, dxS, dyS, drf, dxcS, dycS, drc, AxS, AyS, AzS, VS, 1, 1, nz)
    return g
end

function create_output(B::Array{DataFrame,1})
    output = DataFrame(time=0, gen_ave=mean(B[1].gen), spec_ave = mean(B[1].sp), Cq1_ave=mean(B[1].Cq1), Cq2_ave=mean(B[1].Cq2), Nq_ave=mean(B[1].Nq), size_ave=mean(B[1].size), chl_ave=mean(B[1].chl), Population=size(B[1],1), dvid=0, graz=0, death = 0)
    return output
end

function write_output(t,phyts_b,dvid_ct,graz_ct,death_ct,output)
    # summary of current step
    gen_ave=mean(phyts_b.gen)
    spec_ave=mean(phyts_b.sp)
    Cq1_ave=mean(phyts_b.Cq1)
    Cq2_ave=mean(phyts_b.Cq2)
    Nq_ave=mean(phyts_b.Nq)
    size_ave=mean(phyts_b.size)
    chl_ave=mean(phyts_b.chl)
    push!(output,(time=t, gen_ave=gen_ave, spec_ave=spec_ave, Cq1_ave=Cq1_ave, Cq2_ave=Cq2_ave, Nq_ave=Nq_ave, size_ave=size_ave, chl_ave=chl_ave, Population=size(phyts_b,1), dvid=dvid_ct, graz=graz_ct, death=death_ct))
    return output
end

function count_chl(phyts_a, grid)
    cells = zeros(grid.Nx, grid.Ny, grid.Nz)
    for i in 1:size(phyts_a,1)
        phyt = phyts_a[i,:]
        z = trunc(Int, phyt.z)
        cells[1, 1, z] = cells[1, 1, z] + phyt.chl
    end
    return cells
end

function count_vertical_num(phyts_a)
    VD = zeros(500)
    for i in 1:size(phyts_a,1)
        phyt = phyts_a[i,:]
        z = -trunc(Int, phyt.z) + 1
        VD[z] = VD[z] + 1.0
    end
    return VD
end

function convert_coordinates(phyts, grid)
    for i in 1:size(phyts,1)
    phyt = phyts[i,:]
    z = trunc(Int, phyt.z);
    dz = phyt.z - z;
    phyt.z = grid.zF[z] - dz * grid.Lz[z];
    end
end

function sort_species(Bi, B1, B2)
    phyts1 = DataFrame(x=Float64[], y=Float64[], z=Float64[], gen=Int64[], size=Float64[], Cq1=Float64[], Cq2=Float64[], Nq=Float64[], chl=Float64[],sp=Int64[])
    phyts2 = DataFrame(x=Float64[], y=Float64[], z=Float64[], gen=Int64[], size=Float64[], Cq1=Float64[], Cq2=Float64[], Nq=Float64[], chl=Float64[],sp=Int64[])
    for j in 1:size(Bi,1)
        if Bi[j,:].sp == 1
            push!(phyts1,Bi[j,:])
        elseif Bi[j,:].sp == 2
            push!(phyts2,Bi[j,:])
        end
    end
    push!(B1,phyts1)
    push!(B2,phyts2)
end
    
function compute_mean_species(B1, B2, nTime)
    output1 = DataFrame(time=Int64[], gen_ave=Float64[], Cq1_ave=Float64[], Cq2_ave=Float64[], Nq_ave=Float64[], size_ave=Float64[], chl_ave=Float64[], Population=Int64[]);
    output2 = DataFrame(time=Int64[], gen_ave=Float64[], Cq1_ave=Float64[], Cq2_ave=Float64[], Nq_ave=Float64[], size_ave=Float64[], chl_ave=Float64[], Population=Int64[]);
    for i in 1:nTime
        gen_ave1=mean(B1[i].gen)
        Cq1_ave1=mean(B1[i].Cq1)
        Cq2_ave1=mean(B1[i].Cq2)
        Nq_ave1=mean(B1[i].Nq)
        size_ave1=mean(B1[i].size)
        chl_ave1=mean(B1[i].chl)
        push!(output1,(time=i, gen_ave=gen_ave1, Cq1_ave=Cq1_ave1, Cq2_ave=Cq2_ave1, Nq_ave=Nq_ave1, size_ave=size_ave1, chl_ave=chl_ave1, Population=size(B1[i],1)))
        gen_ave2=mean(B2[i].gen)
        Cq1_ave2=mean(B2[i].Cq1)
        Cq2_ave2=mean(B2[i].Cq2)
        Nq_ave2=mean(B2[i].Nq)
        size_ave2=mean(B2[i].size)
        chl_ave2=mean(B2[i].chl)
        push!(output2,(time=i, gen_ave=gen_ave2, Cq1_ave=Cq1_ave2, Cq2_ave=Cq2_ave2, Nq_ave=Nq_ave2, size_ave=size_ave2, chl_ave=chl_ave2, Population=size(B2[i],1)))
    end
    return output1, output2
end
function write_nut_nc(g::grids, nut::nutrient_fields, t::Int64)
    filepath = "results/nutrients/nut."*lpad(string(t),4,"0")*".nc"
    xC_attr = Dict("longname" => "Locations of the cell centers in the x-direction.", "units" => "m")
    yC_attr = Dict("longname" => "Locations of the cell centers in the y-direction.", "units" => "m")
    zC_attr = Dict("longname" => "Locations of the cell centers in the z-direction.", "units" => "m")
    C_attr = Dict("units" => "mmolC/m^3")
    N_attr = Dict("units" => "mmolN/m^3")
    isfile(filepath) && rm(filepath)
    nccreate(filepath, "DIC", "xC", g.xC[:,1], xC_attr, "yC", g.yC[1,:], yC_attr, "zC", g.zC, zC_attr, atts=C_attr);
    nccreate(filepath, "DIN", "xC", g.xC[:,1], xC_attr, "yC", g.yC[1,:], yC_attr, "zC", g.zC, zC_attr, atts=N_attr);
    nccreate(filepath, "DOC", "xC", g.xC[:,1], xC_attr, "yC", g.yC[1,:], yC_attr, "zC", g.zC, zC_attr, atts=C_attr);
    nccreate(filepath, "DON", "xC", g.xC[:,1], xC_attr, "yC", g.yC[1,:], yC_attr, "zC", g.zC, zC_attr, atts=N_attr);
    nccreate(filepath, "POC", "xC", g.xC[:,1], xC_attr, "yC", g.yC[1,:], yC_attr, "zC", g.zC, zC_attr, atts=C_attr);
    nccreate(filepath, "PON", "xC", g.xC[:,1], xC_attr, "yC", g.yC[1,:], yC_attr, "zC", g.zC, zC_attr, atts=N_attr);
    ncwrite(nut.DIC,filepath,"DIC"); ncwrite(nut.DIN,filepath,"DIN");
    ncwrite(nut.DOC,filepath,"DOC"); ncwrite(nut.DON,filepath,"DON");
    ncwrite(nut.POC,filepath,"POC"); ncwrite(nut.PON,filepath,"PON");
    ncclose(filepath)
    return nothing
end
function write_nut_cons(g::grids, gtr::nutrient_fields, nutₜ::nutrient_fields, vel::velocity,agent_num, t::Int64)
    Σgtrⁿ = sum(gtr.DIN .* g.V)+sum(gtr.DON .* g.V)+sum(gtr.PON .* g.V)
    Σgtrᶜ = sum(gtr.DIC .* g.V)+sum(gtr.DOC .* g.V)+sum(gtr.POC .* g.V)
    ΣsurFⁿ= sum((nutₜ.DIN[:,:,1]+nutₜ.DON[:,:,1]+nutₜ.PON[:,:,1]) .* g.Az .* vel.w[:,:,1])
    ΣsurFᶜ= sum((nutₜ.DIC[:,:,1]+nutₜ.DOC[:,:,1]+nutₜ.POC[:,:,1]) .* g.Az .* vel.w[:,:,1])
    ΣDIN = sum(nutₜ.DIN .* g.V)
    Cio = open("results/cons_C.txt","a"); Nio = open("results/cons_N.txt","a");
    DINio = open("results/cons_DIN.txt","a");
    println(Cio,@sprintf("%4.0f  %.16E  %.16E  %.8E",t,Σgtrᶜ,ΣsurFᶜ,Σgtrᶜ+ΣsurFᶜ))
    println(Nio,@sprintf("%4.0f  %.16E  %.16E  %.8E",t,Σgtrⁿ,ΣsurFⁿ,Σgtrⁿ+ΣsurFⁿ))
    println(DINio,@sprintf("%4.0f  %.16E %6.0f",t,ΣDIN,agent_num))
    close(Cio);close(Nio);close(DINio);
end
