# Storage of inputs for one-for-one reallocation
# -----------------------------------------------------------------------------
# This script describes a function which completes one-for-one and one-for-
#   remaining reallocation. It is designed to use inputs from a interactive
#   heatmap widget (multiple button user interface).
# This script then tests the function using compositional calculations from
#   an external script.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Prepare workspace
# Remove previous objects from environment
  rm(list = ls(all = TRUE))
  graphics.off()

# Load libraries
  library(compositions)
  
# Load data for testing
  data1 <- read.csv("raw_data/Fairclough.csv")
  data1 <- data1[1:169, ] # Remove the last three empty rows

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Function Layout
# Values stored as an upside-down and transposed matrix
# Shown here in converted form (use 'm <- t(r$m[, 4:1])')
# -1 is a space that cant be input, 
# 0's are buttons that haven't been pressed, 1's are buttons that have
  hm <- t(matrix(c(
#   SLP SED LPA MVPA
    -1,  0,  0,  1,  # SLP
     0, -1,  0,  1,  # SED
     0,  0, -1,  0,  # LPA
     0,  0,  0, -1   # MVPA
  ), ncol = 4))
  
# in 24 hours our mean activity hours are:
  total <- 1440
  test.act <- c(9*60, 10*60, 4.5*60, 0.5*60)
  test.comp <- as.vector(acomp(test.act))
  
# The input slider for MVPA is moved up by half an hour
  reall <- c(0, 0, 0, 30)
  
# Create function
  reallocation <- function(comp, reall, total, hm) {
    # Remove negative ones from heatmap matrix
    hm[which(hm == -1)] <- 0
    
    # Create inverse heatmap matrix
    inv.hm <- 1 - hm
    
    # Determine r value
    r <- reall/(total*comp)
  
    # Determine remaining
    rem <- 1 - apply(inv.hm, 2, function(x) { matrix(sum(x*comp)) })
    
    # Determine s value
    s <- -r*comp/rem
    s[is.nan(s)] <- 0
    
    # Create matrices for r and s values, then convert to proportional values
    rs <- t(apply(hm, 1, function(x) { x*s }))
    diag(rs) <- r
    prop <- 1 + rs
    
    # Multiply compositions by proportional values
    new.comp <- comp
    for(i in 1:dim(hm)[1]) {
      new.comp <- new.comp*prop[,i]
    }
    new.comp
  }
  
# Does the function appear to work?
  reallocation(test.comp, c(0, 0, 0, 30), 1440, hm)  # maybe lets run some tests
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Prepare compositional data
# Make activity data.frame
  activity <- with(data1, data.frame(
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
  fitness <- data1$Total.20m.Shuttles
  bmi <- data1$zBMI
  
# Define covariate vectors
  sex <- factor(data1$Sex)
  age <- data1$Decimal.Age..y.
  ses <- data1$IMD.Decile
  

# Predictive Regression Model
  model <- lm(fitness ~ ilr.comp + sex + age + ses)

# To make predictions we need a reference composition - use mean composition
  m <- mean(act.comp)
  
# Composition is acomp class, change to vector
  m.vec <- as.vector(m)
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Function Testing
# Test 1:
# In this example sleep time was increased by 20 minutes using one-for-remaining
# Run Rmarkdown code
  r <- 20/(1440*m[1])
  s <- r*m[1]/(1 - m[1])
  m1 <- c(m[1]*(1 + r), m[2]*(1 - s), m[3]*(1 - s), m[4]*(1 - s))
  
# Create reallocation vector
  r.vec1 <- c(20, 0, 0, 0)
  
# Set up heatmap matrix as one-for-remaining on sleep
  hm1 <- t(matrix(c(
#   SLP SED LPA MVPA
    -1,  0,  0,  0,  # SLP
     1, -1,  0,  0,  # SED
     1,  0, -1,  0,  # LPA
     1,  0,  0, -1   # MVPA
  ), ncol = 4))
  
# See if function gives same value as m1 (reallocation according to original)
  fn.m1 <- reallocation(m.vec, r.vec1, 1440, hm1)
  names(fn.m1) <- c("Sleep", "Sed", "Light", "MVPA")
  all.equal(fn.m1, m1)
  
# Test 2:
# In this example MVPA time was decreased by 20 minutes
# Run Rmarkdown code
  r <- 20/(1440*m[4])
  s <- r*m[4]/(1 - m[4])
  m2 <- c(m[1]*(1 + s), m[2]*(1 + s), m[3]*(1 + s), m[4]*(1 - r))
  
# Create reallocation vector
  r.vec2 <- c(0, 0, 0, -20)
  
# Set up heatmap matrix as one-for-remaining on MVPA
  hm2 <- t(matrix(c(
#   SLP SED LPA MVPA
    -1,  0,  0,  1,  # SLP
     0, -1,  0,  1,  # SED
     0,  0, -1,  1,  # LPA
     0,  0,  0, -1   # MVPA
  ), ncol = 4))
  
  fn.m2 <- reallocation(m.vec, r.vec2, 1440, hm2)
  names(fn.m2) <- c("Sleep", "Sed", "Light", "MVPA")
  all.equal(fn.m2, m2)
  
# Test 3:
# In this example 10 minutes was moved from MVPA to Sedentary time
# Run Rmarkdown code
  m3 <- c(m[1], m[2]+10/1440, m[3], m[4]-10/1440)
  
# Create reallocation vector
  r.vec3 <- c(0, 0, 0, -10)
  
# Set up heatmap matrix as one-for-one from MVPA to sedentary
  hm3 <- t(matrix(c(
#   SLP SED LPA MVPA
    -1,  0,  0,  0,  # SLP
     0, -1,  0,  1,  # SED
     0,  0, -1,  0,  # LPA
     0,  0,  0, -1   # MVPA
  ), ncol = 4))
  
  fn.m3 <- reallocation(m.vec, r.vec3, 1440, hm3)
  names(fn.m3) <- c("Sleep", "Sed", "Light", "MVPA")
  all.equal(fn.m3, m3)