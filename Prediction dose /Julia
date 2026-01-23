# Load required packages
using Pkg
Pkg.add(["DataFrames", "XLSX",  "GLM", "StatsPlots", "DifferentialEquations"])

# Use them
using DataFrames, XLSX, GLM, StatsPlots, DifferentialEquations, Statistics

# Read file
file_path = "C:/Users/Admin/Downloads/A mimic clinical data/clinical MIMIC/Combined_table.xlsx"

# Display data
df = XLSX.readtable(file_path, 1) |> DataFrame

# Check if data loaded correctly
first(df, 5)

# Column names
df.age            = Float64.(df.age)
df.sex            = Float64.(df.sex)          
df.los_hours      = Float64.(df.los_hours)
df.avg_urine_ml   = Float64.(df.avg_urine_ml)
df.avg_lab_value  = Float64.(df.avg_lab_value)
df.num_diagnoses  = Float64.(df.num_diagnoses)
df.rate = Float64.(df.rate)
df.avg_daily_dose = Float64.(df.avg_daily_dose)


# Dose prediction
model = lm(
    @formula(avg_daily_dose ~ age + sex + los_hours + avg_urine_ml +
                              avg_lab_value + num_diagnoses),
    df
)
println(coeftable(model))

# Dose prediction for each patient
df.predicted_dose = predict(model, df)
 
Fig. 15: Dose prediction for each patient

Check
first(select(df, :avg_daily_dose, :predicted_dose), 5)
