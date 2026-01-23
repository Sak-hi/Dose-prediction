# PD-PK combined
plot(sol.t, concentration,
     label="Concentration",
     xlabel="Time (hours)",
     ylabel="Value",
     linewidth=3)

plot!(sol.t, effect,
      label="Effect",
      linewidth=3)
