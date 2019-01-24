# Storage of inputs for one-for-one reallocation
# -----------------------------------------------------------------------------
# One-for-one reallocation requires a reasonably complex input method to
#  achieve. Here we experiment with how to store information for a heatmap.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Prepare work environment
# Load libraries
  library(ggplot2)

# The structure will be a data.frame with 3 columns
# Activity 1, Activity 2 and Values
# We have four activities
  activity <- c("Sleep", "SB", "LPA", "MVPA")
  
# we want every combination of these values
# Use expand.grid to apply activity to its reverse
  storage <- expand.grid(activity, rev(activity))
  names(storage) <- c("a1", "a2")
# Values act as an upside down representation of the matrix
  storage$v <- factor(c(
    0, 0, 1, -1,
    0, 0, -1, 0,
    1, -1, 0, 0,
    -1, 0, 0, 0
  ))
  
# Therefore when looking at the plot you see
# [4, 1] [4, 2] [4, 3] [4, 4]   |   [Slp, Slp] [Slp, Sed] [Slp, LPA] [Slp, MPA]
# [3, 1] [3, 2] [3, 3] [3, 4]   |   [Sed, Slp] [Sed, Sed] [Sed, LPA] [Sed, MPA]
# [2, 1] [2, 2] [2, 3] [2, 4]   |   [LPA, Slp] [LPA, Sed] [LPA, LPA] [LPA, MPA]
# [1, 1] [1, 2] [1, 3] [1, 4]   |   [MPA, Slp] [MPA, Sed] [MPA, LPA] [MPA, MPA]
  matrix(storage$v, ncol = 4)
  
# Now we plot this
  p <- ggplot(storage, aes(x = a1, y = a2, fill = v))
  p <- p + geom_tile(colour = "black")
  p <- p + scale_fill_manual(values = c("grey", "white", "red"))
  p <- p + scale_x_discrete(NULL, position = "top")
  p <- p + scale_y_discrete(NULL)
  p <- p + theme_minimal()
  p <- p + theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    legend.position = "none"
  )
  p