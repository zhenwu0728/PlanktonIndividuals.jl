using PlanktonIndividuals, Serialization

grid = gen_Grid(size = (1, 1, 16), spacing = (32, 32, 2), halo = (2, 2, 2))

nut_init = [2.0, 0.05,0.05,0.01,20.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0]

model = PI_Model(CPUs(), grid, RunParam; nutrients = gen_nutrients(CPUs(), grid, nut_init))

TP = sum((interior(model.nutrients.PO4.data, grid) .+ 
          interior(model.nutrients.DOP.data, grid) .+ 
          interior(model.nutrients.POP.data, grid)) .* grid.V)
TP = TP + sum(model.individuals.phytos.sp1.data.Pq .+ 
              model.individuals.phytos.sp1.data.Bm .* model.individuals.phytos.sp1.p.R_PC)

vel_copy!(model.timestepper.vel₀, zeros(3,3,18), zeros(3,3,18), randn(3,3,18) .* 1e-4, model.grid)

for i in 1:RunParam.nTime
    vel_copy!(model.timestepper.vel₁, zeros(3,3,18), zeros(3,3,18), randn(3,3,18) .* 1e-4, model.grid)
    PI_TimeStep!(model, RunParam.ΔT)
end

TPt = sum((interior(model.nutrients.PO4.data, grid) .+ 
          interior(model.nutrients.DOP.data, grid) .+ 
          interior(model.nutrients.POP.data, grid)) .* grid.V)
TPt = TPt + sum(model.individuals.phytos.sp1.data.Pq .+ 
                model.individuals.phytos.sp1.data.Bm .* model.individuals.phytos.sp1.p.R_PC)

