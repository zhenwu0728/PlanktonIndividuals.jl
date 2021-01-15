mutable struct Model_Input
    temp::AbstractArray{Float64,4}      # temperature
    PARF::AbstractArray{Float64,3}      # PARF
end

mutable struct PI_Model
    arch::Architecture          # architecture on which models will run
    t::Int64
    individuals::individuals    # initial individuals generated by `setup_agents`
    nutrients::NamedTuple       # initial nutrient fields
    grid::Grids                 # grid information
    input::Model_Input          # model input, temp and PAR
    params::Dict                # biogeochemical parameter set
    diags::Diagnostics          # diagnostics
    timestepper::timestepper    # operating Tuples and arrays for timestep
end

"""
    PI_model(arch, grid, RunParam; t, nutrients, individuals, PARF, temp, params, diag_ntrs, diag_nprocs)
Generate the `PI_Model` struct on `grid`. 

Keyword Arguments
=================
- `arch` (required): `CPUs()` or `GPUs()`. The computer architecture used to time-step `model`.
- `grid` (required): The resolution and discrete geometry on which `model` is solved.
- `RunParam` (required): Run time parameters for `model` including number of time steps, ΔT, etc.
- `nutrients` (required): Nutrient tracers initialized with `grid` and initial conditions.
- `individuals` (optional):  Individuals generated according to `RunParam`.
- `PARF` and `temp` (optional): External forcings of PAR and temperature.
- `params` (optional): Parameter set for biogeochemical processes modeled in the model.
- `diag_ntrs` (optional): `NamedTuple` containing the names of nutrient fields to be diagnosed
- `diag_nprocs` (optional): `NamedTuple` containing the names of physiological processes to be diagnosed
"""
function PI_Model(arch::Architecture, grid, RunParam;
                  t = 1-RunParam.ΔT,
                  nutrients,
                  individuals = individuals(RunParam.params, arch),
                  PARF = read_IR_input(RunParam.ΔT, grid),
                  temp = read_temp_input(RunParam.ΔT, grid),
                  params = RunParam.params,
                  diag_ntrs = (:PAR, :DOC, :NH4, :NO3),
                  diag_nprocs = (:num, :graz, :mort, :dvid),
                  )

    if arch == GPUs() && !has_cuda()
        throw(ArgumentError("Cannot create a GPU model. No CUDA-enabled GPU was detected!"))
    end

    if arch == GPUs()
        input = Model_Input(CuArray(temp), CuArray(PARF))
    else
        input = Model_Input(temp,PARF)
    end

    for plank in individuals.phytos
        gen_individuals!(plank, params["Nind"], grid, arch)
    end

    ts = timestepper(arch, grid, params["Nind"])

    diags = diags_setup(diag_ntrs, diag_nprocs, grid, params["Nsp"], arch)

    model = PI_Model(arch, t, individuals, nutrients, grid, input, params, diags, ts)

    if RunParam.Zoo == true
        model.params["grz_P"] = 0
    else
        nothing
    end
    return model
end

import Base: show

function show(io::IO, model::PI_Model)
    print(io, "grid: Nx = $(model.grid.Nx), Ny = $(model.grid.Ny), Nz = $(model.grid.Nz)\n",
              "individuals: $(model.params["Nsp"]) phytoplankton species each with $(model.params["Nind"]) individuals\n",
              "diagnostics of tracers: $(keys(model.diags.tr))\n",
              "diagnostics of individuals: $(keys(model.diags.spcs.sp1))\n")
end