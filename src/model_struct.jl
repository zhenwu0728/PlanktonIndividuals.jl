mutable struct RunOptions
    Dim::Int64   # Choose model dimensions,e.g. 3 for 3D
    OutputChoice::Bool # `true` for save output files
    NutOutputChoice::Bool # `true` for save each timestep separately, `false` for save all timesteps in one file
    GridChoice::Bool # `true` for use default grid
    GridOfflineOpt::Dict # include path to offline grid information and grid selection
    VelChoice::Bool # `true` for use default velocity fields
    VelOfflineOpt::Dict # include path to offline velocity fields, grid selection and vel time step information
    SaveGrid::Bool # `true` for save grid information
    SaveVel::Bool # `true` for save velocity fields
    SaveTest::Bool # `true` for save test results
end

mutable struct RunParams
    nTime::Int64 # number of time steps
    DelT::Int64  # seconds of each time step
    Nindivi::Int64 # number of individuals in each species
    Nsp::Int64 # number of species
    Nsuper::Int64 # number of cells each super individual represents
    Cquota::Array # Average C quota in cell (mmolC/cell)
end

mutable struct velocity #for offline only, include time series
    u::Array{Float64,3}
    v::Array{Float64,3}
    w::Array{Float64,3}
end

struct grids
    xC::Array{Float32,2}
    yC::Array{Float32,2}
    zC::Array{Float32,1}
    xF::Array{Float32,2}
    yF::Array{Float32,2}
    zF::Array{Float32,1}
    dxF::Array{Float32,2} # unit: meter
    dyF::Array{Float32,2} # unit: meter
    dzF::Array{Float32,1} # unit: meter
    dxC::Array{Float32,2} # unit: meter, distance from center to center
    dyC::Array{Float32,2} # unit: meter, distance from center to center
    dzC::Array{Float32,1} # unit: meter, distance from center to center
    Ax::Array{Float32,3} # unit: m²
    Ay::Array{Float32,3} # unit: m²
    Az::Array{Float32,2} # unit: m²
    V ::Array{Float32,3} # unit: m³
    Nx::Int
    Ny::Int
    Nz::Int
end

mutable struct nutrient_fields # for tendencies, forcings and consumptions
    DIC::Array{Float64,3}
    DIN::Array{Float64,3}
    DOC::Array{Float64,3}
    DON::Array{Float64,3}
    POC::Array{Float64,3}
    PON::Array{Float64,3}
end

mutable struct Model_struct
    t::Int64
    individuals::Array{Any,1}   # initial individuals generated by `setup_agents`
    nutrients::nutrient_fields  # initial nutrient fields
    grid::grids                 # grid information
    PAR::Array{Float64,3}       # surface PAR
    temp::Array{Float64,4}      # temperature
    params::Dict                # biogeochemical parameter set
    output::DataFrame           # DataFrame created to record the summary of all individuals at each time step
end
