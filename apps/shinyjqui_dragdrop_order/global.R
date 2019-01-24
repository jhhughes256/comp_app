# Non-reactive objects/expressions
# Load package libraries
  library(ggplot2)
  library(shinyjqui)
  
# Define meals
  meals <- c("breakfast", "lunch", "dinner", "dessert")
  df.meals <- data.frame(Meal = meals)
  nmeals <- length(meals)