using PhytoAgentModel, JLD
#path names
samples=dirname(pathof(PhytoAgentModel))*"/../samples/"
results=dirname(pathof(PhytoAgentModel))*"/../results/"
#                   Dim output, NutOutput, GridChoice, Gridoff, VelChoice, Veloff, SaveGrid, SaveVel, Test
RunOption=RunOptions(0, false,  true,      true,       Dict(),  true,      Dict(), false,    false,   false)

g=load(samples*"grid_0D.jld", "grid")

model = PA_Model(g, RunParam;
              nutrients = setup_nutrients(g,[2.0, 0.05, 20.0, 0.0, 0.0, 0.0])) #DIC, DIN, DOC, DON, POC, PON, mmol/m3

PA_ModelRun(model, RunParam, RunOption)

# ### post-processing steps
B1 = []; B2 = [];
for i in 1:size(model.individuals,1)
    sort_species(model.individuals[i], B1, 1)
    sort_species(model.individuals[i], B2, 2)
end

for i in 1:size(model.individuals,1)
    convert_coordinates(B1[i],g) # convert grids to lon, lat and depth
    convert_coordinates(B2[i],g) # convert grids to lon, lat and depth
end

output1 = compute_mean_species(B1, RunParam.nTime);
output2 = compute_mean_species(B2, RunParam.nTime);

RunOption.SaveTest ? CSV.write(samples*"testB1B2_0D.csv",testB1B2(B1,B2)) : nothing
