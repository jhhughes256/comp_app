# global.R script for Time-Use Optimisation shinydashboard prototype App
# Objects that are not reactive are written here
# -----------------------------------------------------------------------------
# Load package libraries
  require(shinydashboard)
  require(ggplot2)
  require(compositions)
  require(r2d3)

# Define model objects
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Source models
  source("model/model.R")
  
# Define activity names and number of activities
  activity <- names(activity.df)
  nact <- length(activity)

# Define error messages
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Negative composition error
  err1.string <- paste0(
    "Time allocation does not add up to 24 hours."
  )
  
  err2.string <- paste0(
    "Reallocated times must add up to zero hours."
  )