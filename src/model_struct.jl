mutable struct RunOptions
    GridChoice::Bool      # `true` for use default grid
    GridOfflineOpt::Dict  # include path to offline grid information and grid selection
    VelChoice::Bool       # `true` for use default velocity fields
    VelOfflineOpt::Dict   # include path to offline velocity fields, grid selection and vel time step information
end

mutable struct RunParams
    nTime::Int64                     # number of time steps
    ΔT::Int64                        # seconds of each time step
    params::Dict                     # model parameters
    Zoo::Bool                        # Whether include zooplankton
end

mutable struct velocity #for offline only, include time series
    u::Array{Float64,3}
    v::Array{Float64,3}
    w::Array{Float64,3}
end

struct grids
    xC::Array{Real,1}
    yC::Array{Real,1}
    zC::Array{Real,1}
    xF::Array{Real,1}
    yF::Array{Real,1}
    zF::Array{Real,1}
    dxF::Array{Real,1} # unit: meter
    dyF::Array{Real,1} # unit: meter
    dzF::Array{Real,1} # unit: meter
    dxC::Array{Real,1} # unit: meter, distance from center to center
    dyC::Array{Real,1} # unit: meter, distance from center to center
    dzC::Array{Real,1} # unit: meter, distance from center to center
    Ax::Array{Real,3} # unit: m²
    Ay::Array{Real,3} # unit: m²
    Az::Array{Real,2} # unit: m²
    V ::Array{Real,3} # unit: m³
    Nx::Int
    Ny::Int
    Nz::Int
end

mutable struct individuals
    phytos::Array
    zoos::Union{Nothing,Array}
end

mutable struct nutrient_fields # for tendencies, forcings and consumptions
    DIC::Array{Float64,3}
    NH4::Array{Float64,3}
    NO3::Array{Float64,3}
    PO4::Array{Float64,3}
    DOC::Array{Float64,3}
    DON::Array{Float64,3}
    DOP::Array{Float64,3}
    POC::Array{Float64,3}
    PON::Array{Float64,3}
    POP::Array{Float64,3}
end

mutable struct Model_Input
    temp::Array{Float64,4}      # temperature
    PAR::Array{Float64,3}       # PAR
end

mutable struct Diagnostics
    spcs::Array{Float64,6}       # for each species
    tr::Array{Float64,5}         # for tracers
end

mutable struct Model_Struct
    t::Int64
    individuals::individuals    # initial individuals generated by `setup_agents`
    nutrients::nutrient_fields  # initial nutrient fields
    grid::grids                 # grid information
    input::Model_Input          # model input, temp and PAR
    params::Dict                # biogeochemical parameter set
    diags::Diagnostics          # diagnostics
end

mutable struct pop_counts
    divid::Array{Int64,1}
    death::Array{Int64,1}
    graze::Array{Int64,1}
end

