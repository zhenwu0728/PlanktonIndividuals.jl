"""
    PI_TimeStep!(model, ΔT, resultpath)
Update physiology part and nutrient field of 'model' one time step forward
"""
function PI_TimeStep!(model::Model_Struct, ΔT, resultspath::String)
    model.t = model.t+ΔT
    clock = model.t % 86400 ÷ ΔT + 1
    diag_t = model.t ÷ model.params["diag_freq"] + 1

    model.timestepper.vel½.u.data .= (model.timestepper.vel₀.u.data .+ model.timestepper.vel₁.u.data) .* 0.5
    model.timestepper.vel½.v.data .= (model.timestepper.vel₀.v.data .+ model.timestepper.vel₁.v.data) .* 0.5
    model.timestepper.vel½.w.data .= (model.timestepper.vel₀.w.data .+ model.timestepper.vel₁.w.data) .* 0.5

    ##### clear operating array for physiological calculations
    zero_fields!(model.timestepper.plk)
    model.timestepper.chl .= 0.0
    model.timestepper.pop .= 0.0

    for plank in model.individuals.phytos
        plank.data[:,59] .= cumsum(plank.data[:,58])
        CUDA.@allowscalar plank.active_num = Int(copy(plank.data[end,59]))

        plankton_advectionRK4!(plank.data, model.arch, model.grid, model.timestepper.vel₀,
                               model.timestepper.vel½, model.timestepper.vel₁, ΔT, plank.active_num)

        gen_rand_adv!(plank.rnd, model.arch)
        plankton_diffusion!(plank.data, plank.rnd, model.params["κhP"], ΔT, plank.active_num)
        in_domain!(plank.data, model.arch, model.grid)

        ##### calculate accumulated chla quantity (not concentration)
        # find_inds!(plank.data, model.arch, model.grid, 12, 0)
        # acc_chla_field!(model.timestepper.chl, model.timestepper.pop, plank.data, Int.(plank.data[:,13:15]), model.arch)
    end

    # ##### calculate PAR
    # calc_par!(model.timestepper.par, model.arch, model.timestepper.chl, model.input.PARF[:,:,clock],
    #           model.grid, model.params["kc"], model.params["kw"])

    # for plank in model.individuals.phytos
    #     rand!(rng_type(model.arch), plank.rnd)
    #     plankton_update!(plank.data, plank.rnd, model.timestepper.plk,
    #                      model.timestepper.par, model.arch, model.input.temp[:,:,:,clock], model.timestepper.pop,
    #                      model.nutrients.DOC.data, model.nutrients.NH4.data, model.nutrients.NO3.data,
    #                      model.nutrients.PO4.data, model.grid, plank.p, ΔT, model.t)

    #     ##### diagnostics for each species and grazing
    #     # diags!(model.diags.spcs, plank.data, Int.(plank.data[:,13:15]), plank.sp, model.arch, diag_t)

    #     ##### grazing
    #     model.timestepper.tmp .= 0.0
    #     grazing!(plank.data, model.timestepper.tmp, model.arch,
    #             model.grid, model.timestepper.plk, plank.p)

    #     ###### mortality and its diagnostic
    #     # diags_mort!(model.diags.spcs, plank.data, Int.(plank.data[:,13:15]), plank.sp, model.arch, diag_t)

    #     model.timestepper.tmp .= 0.0
    #     mortality!(plank.data, model.timestepper.tmp, model.arch,
    #               model.grid, model.timestepper.plk, plank.p)

    #     ###### cell division and its diagnostic
    #     # diags_dvid!(model.diags.spcs, plank.data, Int.(plank.data[:,13:15]), plank.sp, model.arch, diag_t)

    #     ##### tidy up plank.data
    #     model.timestepper.tmp .= 0.0
    #     plank.data[:,59] .= 0.0
    #     plank.data[:,59] .= cumsum(plank.data[:,58])
    #     # CUDA.@allowscalar plank_num = copy(plank.data[end,59])
    #     copyto_tmp!(plank.data, model.timestepper.tmp, plank.data[:,58], Int.(plank.data[:,59]), false, model.arch)
    #     plank.data .= copy(model.timestepper.tmp)

    #     ##### copy individuals which are ready to divide to the end of plank.data
    #     # divide!(plank.data, model.arch, plank_num)

    #     # ##### calculate index for timestepper.tmp to move active individuals to tmp
    #     # plank.data[:,59] .= 0.0
    #     # plank.data[:,59] .= cumsum(plank.data[:,58])

    #     # ##### copy active individuals to timestepper.tmp
    #     # copyto_tmp!(plank.data, model.timestepper.tmp, plank.data[:,58], Int.(plank.data[:,59]), false, model.arch)

    #     # ##### copy individuals which are ready to divide to the end of active individuals
    #     # tmp_num = floor(Int64, sum(model.timestepper.tmp[:,58]))
    #     # divide_copy!(model.timestepper.tmp, model.arch, tmp_num)
    #     # divide_half!(model.timestepper.tmp, model.timestepper.tmp[:,33], model.arch)

    #     # plank.data .= copy(model.timestepper.tmp)
    # end
    write_species_dynamics(model.t, model.individuals.phytos, resultspath)

    ##### diagnostics for nutrients
    model.diags.tr[:,:,:,diag_t,1] += model.timestepper.par
    model.diags.tr[:,:,:,diag_t,2] += interior(model.nutrients.NO3.data, model.grid)
    model.diags.tr[:,:,:,diag_t,3] += interior(model.nutrients.NH4.data, model.grid)
    model.diags.tr[:,:,:,diag_t,4] += interior(model.nutrients.PO4.data, model.grid)
    model.diags.tr[:,:,:,diag_t,5] += interior(model.nutrients.DOC.data, model.grid)

    nut_update!(model.nutrients, model.timestepper.Gcs, model.timestepper.MD1,
                model.timestepper.MD2, model.timestepper.MD3, model.arch,
                model.grid, model.params, model.timestepper.vel₁, model.timestepper.plk, ΔT)

    write_nut_cons(model.grid, model.timestepper.Gcs, model.nutrients, model.t, resultspath)

    model.timestepper.vel₀.u.data .= model.timestepper.vel₁.u.data
    model.timestepper.vel₀.v.data .= model.timestepper.vel₁.v.data
    model.timestepper.vel₀.w.data .= model.timestepper.vel₁.w.data
end

