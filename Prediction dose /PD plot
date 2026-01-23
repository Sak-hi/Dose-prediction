# PD parameters
Emax = maximum(df.avg_lab_value)
EC50 = median(df.avg_lab_value)

# Simulate Effect-Time
concentration = [c[1] for c in sol.u]
effect = [Emax * c / (EC50 + c) for c in concentration]

# PD Plot
plot(sol.t, effect,
     xlabel="Time (hours)",
     ylabel="Effect",
     title="PD Response (Lab-Derived)",
     linewidth=3,
     color=:red)
