# Global objects for Model Selection App
# -----------------------------------------------------------------------------
# Non-reactive objects/expressions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Load package libraries
  require(ggplot2)
  require(compositions)
  require(r2d3)

# Source models
  source("model/model.R")
  
# Define activities
  activity <- c("Sleep", "SB", "LPA", "MVPA")
  nact <- length(activity)
  
# Define functions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
