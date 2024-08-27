module OptMimiDICEUPDATE

using Mimi
using XLSX: readxlsx
using NLsolve

include("helpers.jl")
include("parameters_UPDATE.jl")

include("marginaldamage.jl")

include("components/totalfactorproductivity_component.jl")
include("components/grosseconomy_component.jl")
include("components/emissions_component.jl")
include("components/co2cycle_UPDATE_component.jl")  # updated component
include("components/radiativeforcing_UPDATE_component.jl")   # updated component
include("components/climatedynamics_UPDATE_component.jl")  # updated component
include("components/damages_component.jl")  # only update parameter below
include("components/neteconomy_component.jl")
include("components/welfare_component.jl")  # only update parameter values below
include("optimise.jl")

export constructdice, get_model, optimise_model, compute_scc

const model_years = 2015:5:2510

function constructdice(params)

    m = Model()
    set_dimension!(m, :time, model_years)

    #--------------------------------------------------------------------------
    # Add components in order
    #--------------------------------------------------------------------------

    add_comp!(m, totalfactorproductivity, :totalfactorproductivity)
    add_comp!(m, grosseconomy, :grosseconomy)
    add_comp!(m, emissions, :emissions)
    add_comp!(m, co2cycle, :co2cycle)
    add_comp!(m, radiativeforcing, :radiativeforcing)
    add_comp!(m, climatedynamics, :climatedynamics)
    add_comp!(m, damages, :damages)
    add_comp!(m, neteconomy, :neteconomy)
    add_comp!(m, welfare, :welfare)
    
    #--------------------------------------------------------------------------
    # Make internal parameter connections
    #--------------------------------------------------------------------------
    
    # Socioeconomics
    connect_param!(m, :grosseconomy, :AL, :totalfactorproductivity, :AL)
    connect_param!(m, :grosseconomy, :I, :neteconomy, :I)
    connect_param!(m, :emissions, :YGROSS, :grosseconomy, :YGROSS)

    # Climate
    connect_param!(m, :co2cycle, :E, :emissions, :E)
    connect_param!(m, :radiativeforcing, :MAT, :co2cycle, :MAT)
    connect_param!(m, :climatedynamics, :FORC, :radiativeforcing, :FORC)

    # Damages
    connect_param!(m, :damages, :TATM, :climatedynamics, :TATM)
    connect_param!(m, :damages, :YGROSS, :grosseconomy, :YGROSS)
    connect_param!(m, :neteconomy, :YGROSS, :grosseconomy, :YGROSS)
    connect_param!(m, :neteconomy, :DAMAGES, :damages, :DAMAGES)
	connect_param!(m, :neteconomy, :SIGMA, :emissions, :SIGMA)
    connect_param!(m, :welfare, :CPC, :neteconomy, :CPC)

    #--------------------------------------------------------------------------
    # NEW internal parameter connections
    #--------------------------------------------------------------------------

    connect_param!(m, :co2cycle, :TATM_1750, :climatedynamics, :TATM_1750)
    connect_param!(m, :co2cycle, :CCA, :emissions, :CCA) #before CCA (cumulative industrial emissions) did not go into the co2cycle component
    connect_param!(m, :co2cycle, :CUMETREE, :emissions, :CUMETREE) #before CUMETREE (cumulative land use emissions) did not go into the co2cycle component       

    #--------------------------------------------------------------------------
    # Set external parameter values 
    #--------------------------------------------------------------------------
    # Set unshared parameters - name is a Tuple{Symbol, Symbol} of (component_name, param_name)
    for (name, value) in params[:unshared]
        update_param!(m, name[1], name[2], value)
    end

    # Set shared parameters - name is a Symbol representing the param_name, here
    # we will create a shared model parameter with the same name as the component
    # parameter and then connect our component parameters to this shared model parameter
    add_shared_param!(m, :fco22x, params[:shared][:fco22x]) #Forcings of equilibrium CO2 doubling (Wm-2)
    connect_param!(m, :climatedynamics, :fco22x, :fco22x)
    connect_param!(m, :radiativeforcing, :fco22x, :fco22x)

    add_shared_param!(m, :l, params[:shared][:l], dims = [:time]) #Level of population and labor (millions)
    connect_param!(m, :grosseconomy, :l, :l)
    connect_param!(m, :neteconomy, :l, :l)
    connect_param!(m, :welfare, :l, :l)

    add_shared_param!(m, :MIU, params[:shared][:MIU], dims = [:time]) #Optimized emission control rate results from DICE2016R (base case)
    connect_param!(m, :neteconomy, :MIU, :MIU)
    connect_param!(m, :emissions, :MIU, :MIU)

    #--------------------------------------------------------------------------
    # Add new parameters
    #--------------------------------------------------------------------------
    
    # adjustment parameter to compare to 1850-1900 temperature levels
    set_param!(m, :climatedynamics, :deltaT, 0.115)
    
    # Speed of adjustment parameter for atmospheric temperature
    set_param!(m, :climatedynamics, :xi1, 7.3)
    
    # Coefficient of heat loss from atmosphere to oceans
    set_param!(m, :climatedynamics, :xi3, 0.73)
    
    # Coefficient of heat gain by deep oceans
    set_param!(m, :climatedynamics, :xi4, 106)
    
    # Initial atmospheric temp change (°C from 1750) 
    update_param!(m, :climatedynamics, :tatm0, 1.243) 
    
    # Initial ocean temp change (°C from 1750) 
    update_param!(m, :climatedynamics, :tocean0, 0.324) 
    
    # tscales
    tscale_params = [1000000,394.4,36.54,4.304]
    set_param!(m, :co2cycle, :tscale, tscale_params)
    
    # fractions
    fraction_params = [0.217,0.224,0.282,0.276]
    set_param!(m, :co2cycle, :fraction, fraction_params)
    
    # carbon cycle starting parameters
    ccycle0_params = [127.159,93.313,37.840,7.721]
    set_param!(m, :co2cycle, :ccycle0, ccycle0_params)   
    
    # initial CO2 concentration in atmosphere
    update_param!(m, :co2cycle, :mat0, 854.033)
    
    # damages coefficient
    update_param!(m, :damages, :a2, 0.007438)
    
    # initial cumulative industrial emissions
    update_param!(m, :emissions, :cca0, 400.00)
    
    # initial industrial emissions
    update_param!(m, :emissions, :e0, 35.85)
    
    # initial cumulative land emissions
    update_param!(m, :emissions, :cumetree0, 197)
    
    # exogenous non-CO2 emissions forcings (REMIND SSP2 2.6)
    Fex = zeros(100)
    Fex[1:17] = [0.310 0.455 0.514 0.580 0.586 0.592 0.562 0.533 0.496 0.462 0.443 0.425 0.411 0.397 0.382 0.367 0.352] 
    for i in 18:100
        Fex[i] = 0.337
    end
    set_param!(m, :radiativeforcing, :FORCOTH, Fex)
    
    # inequality aversion parameter to elasmu=1.0000001
    update_param!(m, :welfare, :elasmu, 1.0000001)
    
    # discount fractor
    rho = 0.005 # 0.015 in Nordhaus DICE2016R2
    t = range(0,99,step=1)
    R = zeros(100)
    for i in 1:100
        R[i] = 1/((1+rho)^(5*t[i]))
    end
    update_param!(m, :welfare, :rr, R)

    return m

end

function getdiceexcel(;datafile = joinpath(dirname(@__FILE__), "..", "data", "DICE2016R-090916ap-v2-REVISEDtoR2.xlsm"))
    params = getdice2016r2excelparameters(datafile)

    m = constructdice(params)

    return m
end

# get_model function for standard Mimi API: use the Excel version
"""
    get_model -> m::Model

Gets model as in standard Mimi API.
"""
get_model = getdiceexcel

#include("mcs.jl")

end # module