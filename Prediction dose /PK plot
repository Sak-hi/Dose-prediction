# PK Parameters
V = (mean(df.age)*0.4)+(mean(df.rate)*0.2)
CL = (mean(df.avg_urine_ml)*24)/1000
k = CL / V

# PK ODE
function pk_model!(dC, C, p, t)
    dose, V, k = p
    dC[1] = (dose / V) - k * C[1]
end

# Simulate Concentration -Time
dose = mean(df.predicted_dose)
p = (dose, V, k)
C0 = [0.0]
tspan = (0.0, 24.0)
prob = ODEProblem(pk_model!, C0, tspan, p)
sol = solve(prob)

# PK Plot
plot(sol,
     xlabel="Time (hours)",
     ylabel="Concentration",
     title="PK Profile (Data-Derived)",
     linewidth=3)
