# Server for Interactive Heatmap used with Compositions
# -----------------------------------------------------------------------------
# Non-reactive objects/expressions
# Load package libraries
  require(ggplot2)
  require(compositions)

# Source models
  source("model/model.R")
  
# Define activities
  activity <- c("Sleep", "SB", "LPA", "MVPA")
  nact <- length(activity)
  
# Define functions
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
  reactiveSlider <- function(id, name, rv) {
    sliderInput(id, name,
      min = -120, max = 120, ticks = FALSE, 
      value = rv[id]
    )
  }
  
# Function that automates reallocation for compositions
  reallocation <- function(comp, reall, total, hm) {
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
    prop <- 1 + rs
    
    # Multiply compositions by proportional values
    new.comp <- comp
    for(i in 1:dim(hm)[1]) {
      new.comp <- new.comp*prop[,i]
    }
    new.comp
  }
  
# Define heatmap theme
  heatmap.theme <- theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    axis.title.y = element_text(angle = 0),
    legend.position = "none"
  )
