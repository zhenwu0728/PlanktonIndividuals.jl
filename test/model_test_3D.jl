using PhytoAgentModel, Serialization
samples=dirname(pathof(PhytoAgentModel))*"/../samples/"
RunOption=RunOptions(false, true, true, Dict(), true, Dict())
PhytoOpt = PlankOpt(1000, 2, Int(1e0), [1.8e-11, 1.8e-10], 1.0, 0.25)
RunParam=RunParams(10, 600, PhytoOpt, false, nothing)
g = deserialize(samples*"grid.bin");
store_vels = deserialize(samples*"uvw.bin");

nut_init = [2.0, 0.05,0.05,0.01,20.0, 0.0, 0.0, 0.0, 0.0, 0.0];
model = PA_Model(g, RunParam; nutrients = setup_nutrients(g,nut_init));

TP = sum((model.nutrients.PO4 .+ model.nutrients.DOP .+ model.nutrients.POP)
         .* g.V)
TP = TP + sum(model.individuals.phytos[:,11])
for i in 1:10
    t = model.t
    vel = store_vels[i]
    vel_itp = generate_vel_itp(model.grid, vel)
    PA_advect!(model, RunParam.ΔT, vel_itp)
    PA_TimeStep!(model, RunParam.ΔT, vel)
    model.t += 1
end

TPt = sum((model.nutrients.PO4 .+ model.nutrients.DOP .+ model.nutrients.POP)
          .* g.V)
TPt = TPt + sum(model.individuals.phytos[:,11])
