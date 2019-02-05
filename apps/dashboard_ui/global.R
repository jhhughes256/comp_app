# global.R script for Time-Use Optimisation shinydashboard prototype App
# Objects that are not reactive are written here
# -----------------------------------------------------------------------------
# Load package libraries
  require(shinydashboard)
  require(shinyjqui)
  require(ggplot2)
  require(compositions)
  require(r2d3)

# State outcome string
  outcomes <- c("depression", "well-being", "coolness")