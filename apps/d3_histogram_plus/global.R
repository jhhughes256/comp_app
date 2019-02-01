# Global Non-reactive objects/expressions
# -----------------------------------------------------------------------------
# Load libraries
# Debug if having issues installing new enough version of shiny
  # if (packageVersion("shiny") < "1.1") {
  #   require(devtools)
  #   devtools::install_version("httpuv", version = "1.4.4.1",
  #     repos = "http://cran.us.r-project.org")
  #   devtools::install_version("shiny", version = "1.1.0", 
  #     repos = "http://cran.us.r-project.org")
  # }
# Important as r2d3 is needed for both server AND ui
  library(shiny)
  library(r2d3)
