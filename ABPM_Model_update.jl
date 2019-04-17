using DataFrames, CSV, LaTeXStrings, Plots, NetCDF, ProgressMeter
using Random
using Distributions
cd("/home/zhenwu/ABPM_3D")
include("parameters.jl")
include("phyt_process.jl")
include("utils.jl")
include("agent_div.jl")
include("model_setup.jl")
include("model_struct.jl")
include("nutrient_processes.jl")
include("flux_div_diffusion_operators.jl")
# Read input files
nTime = 720 # number of time steps
ΔT = 3600 # time step: 1h
temp,IR = read_input("T_IR.csv",nTime);
fieldroot = "/nobackup1b/users/zhenwu/vel_fields/";
vel = read_offline_vels(fieldroot);
g = grid_offline(fieldroot);
# SETUP
N = 60000   # Number of initial individuals of each species
Nsp = 2     # Number of species
B=setup_agents(N,Cquota,1.1,0.18,g) # Normal distribution with mean and variance
# model initialization
# create output file
output = create_output(B);
nut = [2.0, 0.5, 20.0, 2.0, 1.0, 1.0,] #DIC, DIN, DOC, DON, POC, PON, mmol/m3
nut₀ = setup_nutrients(g,nut)
CN = [nut₀]
remin = rem(kDOC,kDON,kPOC,kPON)
# model update
for t in 1:nTime
    phyts_a = copy(B[t]) # read data from last time step
    velᵇ = read_offline_vels(vfroot, itList, tN, t); 
    velᵈ = double_grid(velᵇ,g)
    agent_move(phyts_a,velᵈ,g,ΔT)
    phyts_b,dvid_ct,graz_ct,consume=phyt_update(t, ΔT, g, phyts_a, nutrients, IR, temp)
    push!(B,phyts_b)
    write_output(t,phyts_b,dvid_ct,graz_ct,output)
    convert_coordinates(B[t],g) # convert grids to lon, lat and depth
    F = compute_nut_biochem(nutrients, remin)
    gtr = compute_source_term(nutrients, velᵇ, g, F)
    nutₜ = nut_update(nutrients, consume, g, gtr, ΔT)
end
B1 = []; B2 = [];
@showprogress 1 "Computing..." for i in 1:720
    sort_species(B[i], B1, B2)
end
output1, output2 = compute_mean_species(B1, B2)
###########################################################
# to save all the agents of all time steps run code below #
###########################################################
 using JLD, FileIO
 f = JLD.jldopen("results/output.jld", "w", compress=true)
 JLD.@write f B1
 JLD.@write f B2
 JLD.@write f output
 JLD.@write f output1
 JLD.@write f output2
 JLD.@write f nutrients
 JLD.@write f g
 JLD.@write f IR
 close(f)

