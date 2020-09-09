"""
    PI_TimeStep!(model, RunParam, velᵇ)
Update physiology part and nutrient field of 'model' one time step forward
"""
function PI_TimeStep!(model::Model_Struct, ΔT, vel₁::NamedTuple, resultspath::String)
    model.t = model.t+ΔT
    clock = model.t % 86400 ÷ ΔT + 1
    consume = nutrients_init(model.arch, model.grid)
    model.velocities.vel₁ = vel₁

    plankton_advectionRK4!(model.individuals.phytos, model.arch, model.grid,
                           model.velocities.vel₀, model.velocities.vel₁, ΔT)
    plankton_diffusion!(model.individuals.phytos, model.arch, model.grid,
                        model.params["κhP"], ΔT)

    plankton_update!(model.individuals.phytos, consume, model.diags, model.arch,
                     model.input.temp[:,:,:,clock], model.input.PAR[:,:,clock],
                     model.nutrients.DOC, model.nutrients.NH4, model.nutrients.NO3, model.nutrients.PO4,
                     model.grid, model.params, ΔT, model.t)

    gtr = nutrients_init(model.arch, model.grid)

    nut_update!(model.nutrients, gtr, model.arch, model.grid, model.params, vel₁, consume, ΔT)

    write_nut_cons(model.grid, gtr, model.nutrients, model.t, resultspath)

    model.velocities.vel₀ = model.velocities.vel₁
end
function PI_TimeStep!(model::Model_Struct, ΔT, vel₁::NamedTuple)
    model.t = model.t+ΔT
    clock = model.t % 86400 ÷ ΔT + 1
    consume = nutrients_init(model.arch, model.grid)
    model.velocities.vel₁ = vel₁

    plankton_advectionRK4!(model.individuals.phytos, model.arch, model.grid,
                           model.velocities.vel₀, model.velocities.vel₁, ΔT)
    plankton_diffusion!(model.individuals.phytos, model.arch, model.grid,
                        model.params["κhP"], ΔT)

    plankton_update!(model.individuals.phytos, consume, model.diags, model.arch,
                     model.input.temp[:,:,:,clock], model.input.PAR[:,:,clock],
                     model.nutrients.DOC, model.nutrients.NH4, model.nutrients.NO3, model.nutrients.PO4,
                     model.grid, model.params, ΔT, model.t)

    gtr = nutrients_init(model.arch, model.grid)

    nut_update!(model.nutrients, gtr, model.arch, model.grid, model.params, vel₁, consume, ΔT)

    model.velocities.vel₀ = model.velocities.vel₁
end
function PI_TimeStep!(model::Model_Struct, ΔT, resultspath::String)
    model.t = model.t+ΔT
    clock = model.t % 86400 ÷ ΔT + 1
    consume = nutrients_init(model.arch, model.grid)

    plankton_update!(model.individuals.phytos, consume, model.diags, model.arch,
                     model.input.temp[:,:,:,clock], model.input.PAR[:,:,clock],
                     model.nutrients.DOC, model.nutrients.NH4, model.nutrients.NO3, model.nutrients.PO4,
                     model.grid, model.params, ΔT, model.t)

    gtr = nutrients_init(model.arch, model.grid)

    nut_update!(model.nutrients, gtr, model.arch, model.grid, model.params, consume, ΔT)

    write_nut_cons(model.grid, gtr, model.nutrients, model.t, resultspath)
end

