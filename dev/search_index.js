var documenterSearchIndex = {"docs":
[{"location":"#PlanktonIndividuals.jl-1","page":"Home","title":"PlanktonIndividuals.jl","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"Documentation for PlanktonIndividuals.jl which simulates the behavior of an ensemble of phytoplankton individuals.","category":"page"},{"location":"#Use-Example-1","page":"Home","title":"Use Example","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"Here we use Oceananigans.jl to generate velocity fields and then use those to drive the individual-based model.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Pkg.develop(PackageSpec(path=\"PlanktonIndividuals.jl\"))\nusing PlanktonIndividuals\np = dirname(pathof(PlanktonIndividuals))\ninclude(joinpath(p,\"Oceananigans_PlanktonIndividuals.jl\"))","category":"page"},{"location":"#Unit-Testing-1","page":"Home","title":"Unit Testing","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"The tests use input files from samples/. The test suite includes zero-, one-, two-, and three-dimensional simulations.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Pkg.develop(PackageSpec(path=\"PlanktonIndividuals.jl\"))\nPkg.test(\"PlanktonIndividuals\")","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Contents:","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Pages = [\"index.md\",\"various.md\"]\nDepth = 3","category":"page"},{"location":"#API-Guide-1","page":"Home","title":"API Guide","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Modules = [PlanktonIndividuals]\nOrder   = [:type,:function]","category":"page"},{"location":"#PlanktonIndividuals.PI_Model-Tuple{Any,Any}","page":"Home","title":"PlanktonIndividuals.PI_Model","text":"PI_model(grid, RunParam)\n\nGenerate the model structure for time step Default distribution of individuals is Normal distribution with 1.0 as mean and 0.25 as SD Default PAR and temp are from ../samples\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.PI_TimeStep!-Tuple{PlanktonIndividuals.Model_struct,Any,velocity,Any}","page":"Home","title":"PlanktonIndividuals.PI_TimeStep!","text":"PI_TimeStep!(model, RunParam, velᵇ)\n\nUpdate physiology part and nutrient field of 'model' one time step forward\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.PI_advect!-Tuple{Any,Any,Any}","page":"Home","title":"PlanktonIndividuals.PI_advect!","text":"PI_advect!(individuals, ΔT, vel)\n\nIndividual advection using a simple scheme Particle sinking included\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.PI_advectRK4!-Tuple{Any,Any,Any}","page":"Home","title":"PlanktonIndividuals.PI_advectRK4!","text":"PI_advectRK4!(individuals, ΔT, vel_field, grid)\n\nIndividual advection using a RK4 method Used for 3D double grids Particle sinking not included\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.PrepRunDir","page":"Home","title":"PlanktonIndividuals.PrepRunDir","text":"PrepRunDir(res::String=\"results/\")\n\nCreate res/ folder if needed. Remove old files from it if needed.\n\n\n\n\n\n","category":"function"},{"location":"#PlanktonIndividuals.count_horizontal_num-Tuple{Any,Any}","page":"Home","title":"PlanktonIndividuals.count_horizontal_num","text":"count_horizontal_num(phyts_a, grid)\n\nCount individual numbers in each horizontal grid cell, accumulate in vertical direction\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.count_vertical_num-Tuple{Any}","page":"Home","title":"PlanktonIndividuals.count_vertical_num","text":"count_vertical_num(phyts_a)\n\nCount individual numbers in each meter vertically, accumulate horizontally\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.generate_vel_itp-Tuple{Any,Any}","page":"Home","title":"PlanktonIndividuals.generate_vel_itp","text":"generate_vel_itp(grid, vel)\n\nUse Interpolations.jl to generate interpolation objects\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.grid_offline-Tuple{Dict}","page":"Home","title":"PlanktonIndividuals.grid_offline","text":"grid_offline(GridOfflineOpt)\n\nRead grid information of selected grids from cluster Return a grid 'struc'\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.read_IR_input","page":"Home","title":"PlanktonIndividuals.read_IR_input","text":"read_default_IR_input(nTime, ΔT, grid)\n'nTime' -> number of time step\n'ΔT' -> length of each time step\n'grid' -> grid information\n\nRead input of irradiance from default binary file\n\n\n\n\n\n","category":"function"},{"location":"#PlanktonIndividuals.read_Ogrids-Tuple{Any}","page":"Home","title":"PlanktonIndividuals.read_Ogrids","text":"grid_Ogrids(Ogrid)\n\nRead grid information from Oceananigans Return a grid 'struc' 'z' starts from the bottom\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.read_temp_input","page":"Home","title":"PlanktonIndividuals.read_temp_input","text":"read_default_temp_input(nTime, ΔT, grid, ∂T∂z)\n'nTime' -> number of time step\n'ΔT' -> length of each time step\n'grid' -> grid information\n'∂T∂z' -> linear vertical temp gradient\n\nRead input of temperature from default binary file\n\n\n\n\n\n","category":"function"},{"location":"#PlanktonIndividuals.setup_agents-Tuple{RunParams,Any}","page":"Home","title":"PlanktonIndividuals.setup_agents","text":"setup_agents(RunParams,grid)\n\nSet up a series of agents following a normal distribution (mean,var) 'Nindivi' is agent number for each species, 'sp' is number of species, 'Nsuper' is the number of cells one agent represents, 'Cquota' is the initial biomass for one cell '(x,y,z)' of an individual is the actual location not grid indices\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.setup_nutrients-Tuple{Any,Any}","page":"Home","title":"PlanktonIndividuals.setup_nutrients","text":"setup_nutrients(g,nut)\n\nSet up initial nutrient fields according to grid information 'Nut' is an array of 10 elements, each element is a kind of nutrient\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.update_params-Tuple{Dict,Dict}","page":"Home","title":"PlanktonIndividuals.update_params","text":"update_params(parameters, tmp)\n\nUpdate parameter values based on .yaml file 'parameters' is default parameter set 'tmp' is the parameters need to update\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.write_nut_nc_alltime","page":"Home","title":"PlanktonIndividuals.write_nut_nc_alltime","text":"write_nut_nc_alltime(a, DIC, NH4, NO3, PO4, DOC, DON, DOP, POC, PON, POP, nTime)\n\nWrite a NetCDF file of nutrient fields for the whole run, especially for 0D configuration Default filepath -> \"results/nutrients.nc\"\n\n\n\n\n\n","category":"function"},{"location":"#PlanktonIndividuals.write_nut_nc_each_step-Tuple{grids,nutrient_fields,Int64,String}","page":"Home","title":"PlanktonIndividuals.write_nut_nc_each_step","text":"write_nut_nc_each_step(g, nut, t)\n\nWrite a NetCDF file of nutrient fields at each time step Default filepath -> \"results/nutrients/nut.\"lpad(string(t),4,\"0\")\".nc\"\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.write_output-Tuple{Any,Any,Any}","page":"Home","title":"PlanktonIndividuals.write_output","text":"write_output(individuals,filepath,time)\n\nwrite model output of individuals at each time step in a binary file time = model.t*ΔT\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.agent_advection-Tuple{Any,Any,Any,Int64}","page":"Home","title":"PlanktonIndividuals.agent_advection","text":"agent_advection(phyts_a,vel_itp,g,ΔT)\n\nUpdate grid indices of all the individuals according to velocity fields of each time step Periodic domain is used 'phytsa' is a dataframe contains all the individuals of current time step 'velitp' is the tuple contains interpolations of u, v, w velocites of current time step 'g' is the grid information and 'ΔT' is time step\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.agent_advectionRK4-Tuple{Any,Any,Any,Int64}","page":"Home","title":"PlanktonIndividuals.agent_advectionRK4","text":"agent_advectionRK4(phyts_a, vel_itps, g, ΔT::Int64)\n\n'vel_itps' is an array of tuples containing interpolations of u, v, w velocites of current time step\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.agent_diffusionX-Tuple{Any,Any,Any}","page":"Home","title":"PlanktonIndividuals.agent_diffusionX","text":"agent_diffusionX(phyt,g,κh)\n\nUsing a random walk algorithm for horizontal diffusion\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.agent_diffusionY-Tuple{Any,Any,Any}","page":"Home","title":"PlanktonIndividuals.agent_diffusionY","text":"agent_diffusionX(phyt,g,κh)\n\nUsing a random walk algorithm for horizontal diffusion\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.agent_diffusionZ-Tuple{Any,Any,Any}","page":"Home","title":"PlanktonIndividuals.agent_diffusionZ","text":"agent_diffusionZ(phyt,g,κv)\n\nUsing a random walk algorithm for vertical diffusion\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.chase_prey-Tuple{Array,Any,Float64,Any}","page":"Home","title":"PlanktonIndividuals.chase_prey","text":"chase_prey(zplk, cord, travel_dist, grid)\n\nZooplankton chase after the nearest prey return the distance the predator traveled\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.count_chl-Tuple{Any,Any}","page":"Home","title":"PlanktonIndividuals.count_chl","text":"count_chl(phyts_a, grid)\n\nCompute total chl concentration in each grid cell\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.divide-Tuple{Array{Float64,1}}","page":"Home","title":"PlanktonIndividuals.divide","text":"divide(phyt)\n\nAn adult cell divides evenly into two daughter cells Two daughter cells will be in the same place of the adult cell\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.find_feeding_area-Tuple{Array,Array,Float64}","page":"Home","title":"PlanktonIndividuals.find_feeding_area","text":"find_feeding_area(zplk, phyts, radius)\n\n'zplk' is a individual of zooplankton 'phyts' is the collection of all phytoplankton at current time step 'radius' is the radius of a sphere represent the feeding area The function finds all preys within the sphere Return 'false' if no prey is in this sphere with the nearest prey Return 'true' if there is at least on prey in this sphere along with a dataframe containing all preys (temporal ID and rd) and the nearest prey\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.get_vels-NTuple{4,Any}","page":"Home","title":"PlanktonIndividuals.get_vels","text":"get_vels(x, y, z, vel_itp)\n\nRead and interpolate velocity at '(x,y,z)' '(x,y,z)' is actual location of an individual 'vel_itp' is interpolation objects\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.nut_advection-NTuple{4,Any}","page":"Home","title":"PlanktonIndividuals.nut_advection","text":"nut_advection(g, nutrients, velᵇ, ΔT)\n\ncompute nutrient advection using DST3FL shceme\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.nut_diffusion-NTuple{4,Any}","page":"Home","title":"PlanktonIndividuals.nut_diffusion","text":"nut_diffusion(g, nutrients, params)\n\ncompute diffusion for each nutrient tracer\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.nut_forcing-NTuple{4,Any}","page":"Home","title":"PlanktonIndividuals.nut_forcing","text":"nut_forcing(nut, g, params)\n\ncompute remineralization and nitrification of nutrients\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.nut_update-NTuple{4,Any}","page":"Home","title":"PlanktonIndividuals.nut_update","text":"function nut_update(model, velᵇ, consume, ΔT, Dim)\n\nUpdate nutrient fields to next time step with source term and consumption by phytoplankton ('consume')\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.nutrients_init-Tuple{Any}","page":"Home","title":"PlanktonIndividuals.nutrients_init","text":"nutrients_init(g)\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.periodic_domain-Tuple{Any,Any}","page":"Home","title":"PlanktonIndividuals.periodic_domain","text":"periodic_domain(xF, x)\n\n'xF' is the array containing the faces of grids 'x' is the coordinate of an individual\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.phyt_update-Tuple{Any,Int64}","page":"Home","title":"PlanktonIndividuals.phyt_update","text":"phyt_update(t, ΔT, g, phyts_a, nutrients, IR, temp)\n\nUpdate the individuals of current time step into next time step Control flow: Graze ->Grow(photosynthesis, biosynthesis, maintenance) -> Natural Death -> Division Return a dataframe of next time step individuals, graze number, divide number, death number, and nutrient consumption\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.rand_walk!-Tuple{Array,Any,Any}","page":"Home","title":"PlanktonIndividuals.rand_walk!","text":"rand_walk(zplk::DataFrameRow, grid, travel_dist)\n\nIf zooplankton cannot find any prey, it will swim randomly\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.read_offline_vels-Tuple{Dict,Int64}","page":"Home","title":"PlanktonIndividuals.read_offline_vels","text":"read_offline_vels(VelOfflineOpt, t)\n\nRead velocity fields of selected grids at 't' from cluster Return a velocity 'struc' extra cols & rows are read in for double grids z starts from the bottom\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.setup_zooplkt-Tuple{Any,Any}","page":"Home","title":"PlanktonIndividuals.setup_zooplkt","text":"setup_zooplkt(ZooOpt, grid)\n\nSet up zooplankton individuals according to 'ZooOpt' from 'RunParam'\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.sloppy_feed-Tuple{Array,Array,Any}","page":"Home","title":"PlanktonIndividuals.sloppy_feed","text":"sloppy_feed(zplk, phyts_feed, params)\n\nzooplankton feed on selected phytoplankton return C and N content as exports to environment\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.sum_nut_tendency-Tuple{nutrient_fields,nutrient_fields}","page":"Home","title":"PlanktonIndividuals.sum_nut_tendency","text":"sum_nut_tendency(consume_p, consume_z)\n\nsum up 2 nut tendencies\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.which_grid-Tuple{Any,Any}","page":"Home","title":"PlanktonIndividuals.which_grid","text":"which_grid(phyt,g)\n\ndecide which grid an individual is in return grid indices\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.write_nut_cons-Tuple{grids,nutrient_fields,nutrient_fields,Int64,Any}","page":"Home","title":"PlanktonIndividuals.write_nut_cons","text":"write_nut_cons(g, gtr, nutₜ, vel, t, filepath)\n\nCompute total gtr (supposed to be 0), and surface vertical tracer flux(supposed to be 0) Write a brief summary of each time step into a txt file\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.write_pop_dynamics-Tuple{Int64,Any,Any,Any}","page":"Home","title":"PlanktonIndividuals.write_pop_dynamics","text":"write_pop_dynamics(t, agent_num, counts, filepath)\n\nWrite a brief summary of population changes at each time step into a txt file\n\n\n\n\n\n","category":"method"},{"location":"#PlanktonIndividuals.zoo_update-Tuple{Any,Int64}","page":"Home","title":"PlanktonIndividuals.zoo_update","text":"zoo_update(zoos, phyts, ΔT)\n\nupdate individuals of zooplankton one time step forward both physiology processes and active movement Control flow: Death -> Graze & Swim & Grow -> Reproduction\n\n\n\n\n\n","category":"method"},{"location":"various/#Function-Inventory-1","page":"Various","title":"Function Inventory","text":"","category":"section"},{"location":"various/#","page":"Various","title":"Various","text":"Use cases:","category":"page"},{"location":"various/#","page":"Various","title":"Various","text":"Oceananigans_PlanktonIndividuals.jl","category":"page"},{"location":"various/#","page":"Various","title":"Various","text":"Infrastructure functions:","category":"page"},{"location":"various/#","page":"Various","title":"Various","text":"model_struct.jl defines velocity, grids, nutrient_fields, and rem structs.\nmodel.jl deals with the model basic functionalities.\nmodel_setup.jl is setup_agents and setup_nutrients\noption_params.jl and param_defaults.jl deal with model parameter values\nutils.jl utility functions for IO and operations.","category":"page"},{"location":"various/#","page":"Various","title":"Various","text":"process functions:","category":"page"},{"location":"various/#","page":"Various","title":"Various","text":"phyt_process.jl = daynight, PAR_cal, PC, Nuptake, chl_sync, divide, phyt_update\nnutrient_processes.jl = compute_nut_biochem, compute_source_term, nut_update\ndst3fl.jl 3rd order DST Scheme with flux limiting\n2nd_adv_diffu.jl right hand side term functions (?)\nagent_div.jl = is mostly agent_move, agent_move_1D + double_grid, trilinear_itpl, simple_itpl","category":"page"},{"location":"various/#Model-Variables-1","page":"Various","title":"Model Variables","text":"","category":"section"},{"location":"various/#","page":"Various","title":"Various","text":"The lists and text below likely is out of date","category":"page"},{"location":"various/#)-state-variables-1","page":"Various","title":"1) state variables","text":"","category":"section"},{"location":"various/#","page":"Various","title":"Various","text":"phyts_a\nnutrients","category":"page"},{"location":"various/#)-input-variables-1","page":"Various","title":"2) input variables","text":"","category":"section"},{"location":"various/#","page":"Various","title":"Various","text":"g from grid_offline() (grid variables)\ntemp, IR from read_input() (before loop)\nremin from rem() (before loop)\nvelᵇ from read_offline_vels() (in loop)","category":"page"},{"location":"various/#","page":"Various","title":"Various","text":"Notes:","category":"page"},{"location":"various/#","page":"Various","title":"Various","text":"IR and temp get cycle through / interpolated inside phyt_update (via IR[trunc(Int,t*ΔT/3600)]). Not sure about daynight(t,IR) in phyt_update. \nread_offline_vels receives trunc(Int,t*ΔT/3600) as argument.\nremin is time-invariant; like g.","category":"page"},{"location":"various/#)-intermediate-variables-1","page":"Various","title":"3) intermediate variables","text":"","category":"section"},{"location":"various/#","page":"Various","title":"Various","text":"F = compute_nut_biochem(nutrients, remin)\ngtr = compute_source_term(nutrients, velᵇ, g, F)\nnutₜ = nut_update(nutrients, consume, g, gtr, ΔT)","category":"page"},{"location":"various/#)-diagnostic-variables-1","page":"Various","title":"4) diagnostic variables","text":"","category":"section"},{"location":"various/#","page":"Various","title":"Various","text":"dvid_ct, graz_ct, death_ct from phyt_update\ngtr, nutₜ, velᵇ, agent_num from ","category":"page"},{"location":"various/#Output-Files-1","page":"Various","title":"Output Files","text":"","category":"section"},{"location":"various/#","page":"Various","title":"Various","text":"The lists and text below likely is out of date","category":"page"},{"location":"various/#)-listing-1","page":"Various","title":"1) listing","text":"","category":"section"},{"location":"various/#","page":"Various","title":"Various","text":"B1.bin\t\tall agents at all time steps for species 1\nB2.bin\t\t... species 2\ncons_C.txt\ttotal carbon for each time step\ncons_DIN.txt\t... DIN ...\ncons_N.txt\t... N ...\ngrid.bin\tgrid (input)\nIR.bin\t\tirradiance (input)\nnutrients/nut.0001.nc (all nitrients for 1 time step)\t\nnutrients/nut.0002.nc (same...)\noutput1.bin\taverage for all agents for each time step for species 1\noutput2.bin\t... 2\noutput.bin\t... for the two species\nVD1.bin\t\tvertical profile of the agents opouplation for species 1\nVD2.bin\t\t... species 2","category":"page"},{"location":"various/#)-netcdf-output-1","page":"Various","title":"2) netcdf output","text":"","category":"section"},{"location":"various/#","page":"Various","title":"Various","text":"netcdf nut.0001 {\ndimensions:\n        yC = 1 ;\n        xC = 1 ;\n        zC = 40 ;\nvariables:\n        double DIC(zC, yC, xC) ;\n                DIC:units = \"mmolC/m^3\" ;\n        float yC(yC) ;\n                yC:units = \"m\" ;\n                yC:longname = \"Locations of the cell centers in the y-direction.\" ;\n        float xC(xC) ;\n                xC:units = \"m\" ;\n                xC:longname = \"Locations of the cell centers in the x-direction.\" ;\n        float zC(zC) ;\n                zC:units = \"m\" ;\n                zC:longname = \"Locations of the cell centers in the z-direction.\" ;\n        double DIN(zC, yC, xC) ;\n                DIN:units = \"mmolN/m^3\" ;\n        double DOC(zC, yC, xC) ;\n                DOC:units = \"mmolC/m^3\" ;\n        double DON(zC, yC, xC) ;\n                DON:units = \"mmolN/m^3\" ;\n        double POC(zC, yC, xC) ;\n                POC:units = \"mmolC/m^3\" ;\n        double PON(zC, yC, xC) ;\n                PON:units = \"mmolN/m^3\" ;","category":"page"},{"location":"various/#Data-Structures-1","page":"Various","title":"Data Structures","text":"","category":"section"},{"location":"various/#","page":"Various","title":"Various","text":"The lists and text below likely is out of date","category":"page"},{"location":"various/#","page":"Various","title":"Various","text":" output = DataFrame(time=0, \n gen_ave=mean(B[1].gen), \n spec_ave = mean(B[1].sp),\n Cq1_ave=mean(B[1].Cq1), \n Cq2_ave=mean(B[1].Cq2), \n Nq_ave=mean(B[1].Nq),\n size_ave=mean(B[1].size),\n chl_ave=mean(B[1].chl),\n Population=size(B[1],1),\n dvid=0,\n graz=0,\n death = 0)","category":"page"},{"location":"various/#Plotting-Functions-1","page":"Various","title":"Plotting Functions","text":"","category":"section"},{"location":"various/#","page":"Various","title":"Various","text":"The lists and text below likely is out of date","category":"page"},{"location":"various/#","page":"Various","title":"Various","text":"julia> using DataFrames, Serialization\njulia> output=open(deserialize,\"results/output.bin\");\njulia> plot(output.Population)","category":"page"}]
}
