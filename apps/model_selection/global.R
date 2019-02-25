# Global objects for Model Selection App
# -----------------------------------------------------------------------------
# Non-reactive objects/expressions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Load package libraries
  # require(ggplot2)
  require(compositions)
  # require(r2d3)
  require(shinyjqui)
  require(plyr)

# Source models
  source("model/model.R")
  
# Create model list
  models <- list(
    Fitness = list(
      mod = model.fit,
      mean = mean.fit
    ),
    zBMI = list(
      mod = model.bmi,
      mean = mean.bmi
    )
  )
  
# Define outcome names
  outcomes <- names(models)
  
# Define functions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
