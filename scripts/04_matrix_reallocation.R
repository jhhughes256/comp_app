# Storage of inputs for reallocation
# -----------------------------------------------------------------------------
# Using the matrix heatmap widget output, this script describes how to 
#   implement one-for-one and one-for-remaining reallocation.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Prepare workspace
  library(compositions)

# Values stored as an upside-down and transposed matrix
# Shown here in converted form (use 'm <- t(r$m[, 4:1])')
# -1 is a space that cant be input, 0's are no 
  m <- t(matrix(c(
#   SLP SED LPA MVPA
    -1,  0,  0,  1,  # SLP
     0, -1,  0,  1,  # SED
     0,  0, -1,  1,  # LPA
     0,  0,  0, -1   # MVPA
  ), ncol = 4))
  
# First remove the negative ones now that we no longer need them for heatmap
  m[which(m == -1)] <- 0
# We will also need an inverse matrix
  inv.m <- (1 - m)
  
# in 24 hours our mean activity hours are:
  total <- 1440
  m.act <- c(9*60, 10*60, 4.5*60, 0.5*60)
  m.comp <- as.vector(acomp(m.act))
  
# The input slider for MVPA is moved up by half an hour
  reall <- c(0, 0, 0, 30)
  
# Determine r value
  r <- reall/(total*comp)

# Determine remaining
  rem <- 1 - apply(inv.m, 2, function(x) { matrix(sum(x*m.comp)) })
  
# Determine s value
  s <- -r*m.comp/rem
  s[is.nan(s)] <- 0
  
# Create matrices for r and s values, then convert to proportional values
  rs <- t(apply(m, 1, function(x) { x*s }))
  diag(rs) <- r
  prop <- 1 + rs
  
# Multiply compositions by proportional values
  new.comp <- m.comp
  for(i in 1:dim(m)[1]) {
    new.comp <- new.comp*prop[,i]
  }
  new.comp
  