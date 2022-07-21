using NLopt

# INSPIRED BY 'Utilitarian Benchmarks for Emissions and Pledges Promote Equity, Climate, and Development.'
# (https://github.com/Environment-Research/Utilitarianism/blob/master/src/helper_functions.jl)

"""
    optimise_model(mD16::Model=get_model(), n_objectives::Int=length(model_years), stop_time::Int=640, tolerance::Float64=1e-6, optimization_algorithm::Symbol=:LN_SBPLX) -> mD16::Model
    
Optimise DICE2016R2 model instance `mD16` and return the optimised and updated model.

`mD16` is not a mandatory argument. In case it is not provided, the function will use a newly constructed model from [`get_model`](@ref). It is worth manually passing a model instance if one wishes to optimise a modified version of DICE, e.g. with updated parameters or updated components.

## Keyword arguments:
- `n_objectives`: number of objectives, which corresponds to the number of time steps in the model
- `stop_time`: time in seconds after which optimisation routine, passed to [`ftol_rel!`](@ref)
- `tolerance`: tolerance requirement passed to [`ftol_rel!`](@ref)
- `optimization_algorithm`: algorithm passed to [`ftol_rel!`](@ref)

See also [`construct_objective`](@ref).
"""
function optimise_model(mD16::Model=get_model(), n_objectives::Int=length(model_years), stop_time::Int=640, tolerance::Float64=1e-6, optimization_algorithm::Symbol=:LN_SBPLX)
    # Create lower bound
    lower_bound = zeros(n_objectives)     
    # Create upper bound    
    upper_bound = 1.2 .* ones(n_objectives)                                                     # upper limit 1.2, however in GAMS code this only applies after 2150!
    
    # Create initial condition for algorithm (set at 50% of upper bound).
    # starting_point = upper_bound ./ 2
    starting_point = ones(n_objectives) .* 0.03 # 0.03 for the baseline and as start for optimised run (miu0 in GAMS code)
    
    opt = Opt(optimization_algorithm, n_objectives)
    
    # Set the bounds.
    lower_bounds!(opt, lower_bound)
    upper_bounds!(opt, upper_bound)
    
    # Assign the objective function to maximize.
    max_objective!(opt, (x, grad) -> construct_objective(mD16, x))
    
    # Set termination time.
    maxtime!(opt, stop_time)
    
    # Set optimizatoin tolerance (will stop if |Δf| / |f| < tolerance from one iteration to the next).
    ftol_rel!(opt, tolerance)
    
    # Optimize model.
    maximum_objective_value, optimised_policy_vector, convergence_result = optimize(opt, starting_point)
    
    return mD16
end
    
"""
    construct_objective(mD16::Model, optimised_mitigation::Array{Float64,1}) -> mD16[:welfare, :UTILITY]

Updates emissions control rate `:MIU` in model `mD16` and returns the resulting utility vector. This function is called by `optimise_model`[@ref]. `optimised_mitigation` is a vector of `:MIU` values that is being optimised.

See also [`optimise_model`](@ref).
"""
function construct_objective(mD16::Model, optimised_mitigation::Array{Float64,1})
    # update MIU (abatement variable) and re-build model to evaluate welfare effects
    update_param!(mD16, :MIU, optimised_mitigation)
    run(mD16)
    return mD16[:welfare, :UTILITY]
end
