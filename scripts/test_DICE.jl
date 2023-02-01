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
#%% PLOT
# ----------------------------------------------------------
using PyCall
using PyPlot
plt = pyimport("matplotlib.pyplot")

fig = plt.figure(figsize=(10, 5))
ax  = fig.add_subplot(111)
ax.grid()

xlabel="Year"
yll1 = get_labels_lims(vars[1])

ax.set_xlabel(xlabel)
ax.set_ylabel(yll1[1])
ax.set_xlim(xlims)
ax.set_ylim(yll1[2])

# variable that determines how many trajectories are plotted on first ax
# initially assume only one plotted variable
n_traj = length(result_keys)

if length(vars) == 2
    yll2 = get_labels_lims(vars[2])
    ax2 = ax.twinx()
    ax2.set_ylabel(yll2[1])
    ax2.set_ylim(yll2[2])
    n_traj = Int(length(result_keys)/2)
end

for k in 1:n_traj
    key = result_keys[k]
    ax.plot(t, results[key], label=key)
end

if length(vars) == 2
    for k in n_traj+1:length(result_keys)
        key = result_keys[k]
        ax2.plot(t, results[key], ":", label=key)
    end
end 

lines, labels = ax.get_legend_handles_labels()
lines2, labels2 = ax2.get_legend_handles_labels()
ax.legend(vcat(lines, lines2), vcat(labels, labels2), loc=1)

display(plt.gcf())