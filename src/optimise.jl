using NLopt
using Mimi

# INSPIRED BY 'Utilitarian Benchmarks for Emissions and Pledges Promote Equity, Climate, and Development.'
# (https://github.com/Environment-Research/Utilitarianism/blob/master/src/helper_functions.jl)

"""
    optimise_model(m::Model=get_model(); kwargs) -> m::Model, diagnostic::Dict
    
Optimise DICE2016R2 model instance `m` and return the optimised and updated model.

The model instance `m` is not a mandatory argument. In case it is not provided, the function will use a newly constructed model from [`OptMimiDICE2016R2.get_model`](@ref). It is worth manually passing a model instance if one wishes to optimise a modified version of DICE, e.g. with updated parameters or updated components.

## Keyword arguments:
- `n_objectives::Int=length(model_years)`: number of objectives, which corresponds to the number of time steps in the model
- `stop_time::Int=640`: time in seconds after which optimisation routine stops, passed to `NLopt.ftol_rel!`
- `tolerance::Float64=1e-6`: tolerance requirement passed to `NLopt.ftol_rel!`
- `optimization_algorithm::Symbol=:LN_SBPLX`: algorithm passed to `NLopt.ftol_rel!`

## Notes
- Importantly, this implementation of DICE2016R2 has no restrictions on NETs. A rate of emissions reduction `:MIU` of up to 1.2 is allowed throughout.
- The second return value is purely for diagnostic purposes and comes directly from the NLopt optimisation. In normal usage, it can be ignored.

See also [`construct_objective`](@ref).
"""
function optimise_model(m::Model=get_model(); n_objectives::Int=length(model_years), stop_time::Int=640, tolerance::Float64=1e-6, optimization_algorithm::Symbol=:LN_SBPLX)
    # Create lower bound
    lower_bound = zeros(n_objectives)     
    # Create upper bound    
    upper_bound = 1.2 .* ones(n_objectives)                                                     # upper limit 1.2, however in GAMS code this only applies after 2150!
    
    # Create initial condition for algorithm (set at 50% of upper bound).
    starting_point = ones(n_objectives) .* 0.03 # 0.03 as a start for the baseline and for optimised run (miu0 in GAMS code)
    
    opt = Opt(optimization_algorithm, n_objectives)
    
    # Set the bounds.
    lower_bounds!(opt, lower_bound)
    upper_bounds!(opt, upper_bound)
    
    # Assign the objective function to maximize.
    max_objective!(opt, (x, grad) -> construct_objective(m, x))
    
    # Set termination time.
    maxtime!(opt, stop_time)
    
    # Set optimizatoin tolerance (will stop if |Δf| / |f| < tolerance from one iteration to the next).
    ftol_rel!(opt, tolerance)
    
    # Optimize model.
    maximum_objective_value, optimised_policy_vector, convergence_result = optimize(opt, starting_point)
    
    diagnostic = Dict([("Maximum objective value", maximum_objective_value),
                       ("Optimised policy vector", optimised_policy_vector),
                       ("Convergence result", convergence_result)])

    return m, diagnostic
end
    
"""
    construct_objective(m::Model, optimised_mitigation::Array{Float64,1}) -> m[:welfare, :UTILITY]

Updates emissions control rate `:MIU` in model `m` and returns the resulting utility vector. This function is called by [`optimise_model`](@ref). `optimised_mitigation` is a vector of `:MIU` values that is being optimised.

See also [`optimise_model`](@ref).
"""
function construct_objective(m::Model, optimised_mitigation::Array{Float64,1})
    # update MIU (abatement variable) and re-build model to evaluate welfare effects
    update_param!(m, :MIU, optimised_mitigation)
    run(m)
    return m[:welfare, :UTILITY]
end
