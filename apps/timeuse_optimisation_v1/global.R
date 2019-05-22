# global.R script for Time-Use Optimisation shinydashboard prototype App
# Objects that are not reactive are written here
# -----------------------------------------------------------------------------
# Load package libraries
  require(shinydashboard)
  require(shinyjqui)
  require(ggplot2)
  require(compositions)
  require(r2d3)
  require(plyr)

# Define options
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Define heatmap theme
  heatmap.theme <- theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    axis.title.y = element_text(angle = 0),
    legend.position = "none"
  )
  
# Define debounce settings
  debounceSettings <- 500

# Define model objects
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Source models
  source("model/model.R")

# Create model list
  model.list <- list(
    mod = model.wai,
    mean = mean.wai
  )
  
# Define activity names and number of activities
  activity <- names(activity.df)
  nact <- length(activity)
  
# Define outcome names
  outcomes <- names(model.list)
  
# Define error messages
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Negative composition error
  neg.act.error <- paste0(
    "cannot be performed for less than zero hours. Sliders have been reset."
  )
  
# Define functions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Function used for heatmaps to ensure that user clicks stay within the plot
  inGrid <- function(coord, axis, n) {
    out <- coord
    if (coord[axis] < 1) {
      out[axis] <- 1
    } else if (coord[axis] > n) {
      out[axis] <- n
    }
    out
  }
  
# Function used to make reactiveSliders when used in app server
  reactiveSlider <- function(rm, labs = activity) {
    trm <- t(rm[,6:1])
    act.col <- which(apply(trm, 2, function(x) { any(x == 1) }))
    act.swap <- labs[act.col]
    act.for <- paste(labs[trm[, act.col] == 1], collapse = ", ")
    sliderInput(act.swap, paste("Swap", act.swap, "for", act.for),
      min = -120, max = 120, ticks = FALSE, 
      value = 0, width = "80%"
    )
  }
  
# Function that automates reallocation for compositions
  reallocation <- function(comp, reall, hm, total = 1440) {
    # Remove negative ones from heatmap matrix
    diag(hm) <- 0
    
    # Create inverse heatmap matrix
    inv.hm <- 1 - hm
    
    # Determine r value
    r <- reall/(total*comp)
  
    # Determine remaining
    rem <- 1 - apply(inv.hm, 2, function(x) { matrix(sum(x*comp)) })
    
    # Determine s value
    s <- -r*comp/rem
    s[!is.finite(s)] <- 0
    
    # Create matrices for r and s values, then convert to proportional values
    rs <- t(apply(hm, 1, function(x) { x*s }))
    if(any(rs != 0)) { diag(rs) <- r }
    prop <- rs
    
    # Determine change in composition
    delta.comp <- rep(0, length(comp))
    for(i in 1:dim(hm)[1]) {
      delta.comp <- delta.comp + comp*prop[,i]
    }
    delta.comp
  }