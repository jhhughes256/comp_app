# Model for Interactive Heatmap used with Compositions
# -----------------------------------------------------------------------------
# Prepare model workspace
# Load data
  raw.data <- read.csv("model/Fairclough.csv")
  raw.data <- raw.data[1:169, ] # Remove the last three empty rows

# Make activity data.frame
  activity <- with(raw.data, data.frame(
    Sleep = sleep,
    Sed = Sedentary,
    Light = Light,
    MVPA = MVPA
  ))
  
# Use acomp() to create Aitchison Composition
  act.comp <- acomp(activity)

# For reallocations use any ILR or ALR transformation - ILR here
  ilr.comp <- ilr(act.comp)
  
# Define variable vectors
  var.fit <- raw.data$Total.20m.Shuttles
  var.bmi <- raw.data$zBMI
  
# Define covariate vectors
  cov.sex <- factor(raw.data$Sex)
  cov.age <- raw.data$Decimal.Age..y.
  cov.ses <- raw.data$IMD.Decile
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Predictive Regression Model
  model <- lm(var.fit ~ ilr.comp + cov.sex + cov.age + cov.ses)

# To make predictions we need a reference composition - use mean composition
  m.comp <- as.vector(mean(act.comp))
  
# 
#   
# # Here we increase by 20 minutes or 20/1440 days
#   r <- 20/(1440*m[1])
#   s <- r*m[1]/(1 - m[1])
#   m1 <- c(m[1]*(1 + r), m[2]*(1 - s), m[3]*(1 - s), m[4]*(1 - s))
#   
# # Compositions can be converted into minutes/day using clo()
#   clo(m, total = 1440)
#   clo(m1, total = 1440)
#   # mean sleep is up 20 minutes, the rest has decreased a bit
#   
# # Using the reallocated composition, make a prediction using the model
#   m.fitness1 <- predict(model, 
#     newdata = list(
#       ilr.comp = ilr(m1), sex = "1", age = mean(age), ses = mean(ses)
#     )
#   )
#   
# # Compare the two compositions 
#   m.fitness1 - m.fitness  # 20 mins more sleep = 0.3 less shuttles
#   
# # Another example where MVPA is decreased
#   r <- 20/(1440*m[4])
#   s <- r*m[4]/(1 - m[4])
#   m2 <- c(m[1]*(1 + s), m[2]*(1 + s), m[3]*(1 + s), m[4]*(1 - r))
#   clo(m, total = 1440)
#   clo(m2, total = 1440)
#   m.fitness2 <- predict(model, 
#     newdata = list(
#       ilr.comp = ilr(m2), sex = "1", age = mean(age), ses = mean(ses)
#     )
#   )
#   m.fitness2 - m.fitness  # 20 mins less MVPA = ~18.6 less shuttles!
#   
# # Important to not let a composition go below zero, cannot have negative time
# # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# # "One-for-One" Reallocation  
# # Example where 10 minutes moved from MVPA to Sedentary time
#   m3 <- c(m[1], m[2]+10/1440, m[3], m[4]-10/1440)
#   clo(m3, total = 1440)
#   clo(m, total = 1440)
#   m.fitness3 <- predict(model, 
#     newdata = list(
#       ilr.comp = ilr(m3), sex = "1", age = mean(age), ses = mean(ses)
#     )
#   )
#   m.fitness3 - m.fitness # 10 mins from MVPA to sedentary = 6.25 less shuttles
#   
# # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# # Important Learning Points/Thoughts
# # 1. Important that a composition never goes below zero
# #     - could solve with conditional checking this if(x < 0) x <- 0
# #     - likely better to set minimum value
# #     - sliders will need to use reactiveUI() regardless
# # 2. The structure of Reallocation Settings will be crucial to usability
# #     - want a conditional for switching between one-for-one or one-for-rem
#         oneforone.settings <- c(0, 10, 0, -10)/1440  
#         oneforrem.settings <- c((1 + s), (1 + s), (1 + s), (1 - r))
# # 3. How to set up input of one-for-one settings
# #     - want a seemless way to interact with one-for-one
# #     - heatmap with interactive plots (pretty hacky)
# #     - grid of radio buttons (ugly, HTML nightmare to do text/borders)
# #     - custom buttons? (think you can reshape them, still a HTML nightmare)
# # 4. Implementation of reallocation should be fine using reactive.values()
#         reallocated.m3 <- as.matrix(m) + matrix(oneforone.settings)
#         all.equal(reallocated.m3[, 1], m3)
#         reallocated.m2 <- as.matrix(m)*matrix(oneforrem.settings)
#         all.equal(reallocated.m2[, 1], m2)
# # 5. Output seems super straight-forward
# #     - conditional determines which model is used
# #     - use Shiny jquery UI to provide drag and drop functionality
# 
#   