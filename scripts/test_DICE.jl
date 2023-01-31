##% GET PACKAGES

using Mimi
# include code of main model file, in which the module MimiDICE2016R2_opt is defined
include("../src/OptMimiDICE2016R2.jl")
# load module MimiDICE2016R2_opt with the respective exported functions constructdice, get_model, optimise_model
using Main.OptMimiDICE2016R2

# ----------------------------------------------------------
#%% GET MODELS
# ----------------------------------------------------------

# Get standard DICE2016R2 baseline model
m_base = get_model()
time_steps = length(OptMimiDICE2016R2.model_years)
t = collect(OptMimiDICE2016R2.model_years)

# Howard & Sterner damage specification including productivity effect
# update_param!(m_base, :damages, :a2, 0.01145)

run(m_base);

#%% Get standard DICE optimised model
m_opt = get_model()

# Howard & Sterner damage specification including productivity effect
# update_param!(m_opt, :damages, :a2, 0.01145)

run(m_opt)
@time m_opt, diagn_opt = optimise_model(m_opt, backup_timesteps=0);

# ----------------------------------------------------------
#%% GET RESULTS
# ----------------------------------------------------------

E_base = m_base[:emissions, :E]
E_opt = m_opt[:emissions, :E]

T_base = m_base[:climatedynamics, :TATM]
T_opt = m_opt[:climatedynamics, :TATM]

# ----------------------------------------------------------
#%% GET RESULTS
# ----------------------------------------------------------
