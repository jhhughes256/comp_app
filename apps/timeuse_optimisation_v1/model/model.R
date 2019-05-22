# Model for Interactive Heatmap used with Compositions
# -----------------------------------------------------------------------------
# Prepare model workspace
# Load data
  raw.data <- read.csv("model/df_tool.csv")
names(raw.data)
# Make activity data.frame
activity.df <- with(raw.data, data.frame(
  Sleep = X6,
  DomSoc = X1, #includes self care
  PA = X2,
  QuietT = X3, #includes passive transport
  Screen = X5,
  School = X4
))
  
# Use acomp() to create Aitchison Composition
  act.comp <- acomp(activity.df)

# For reallocations use any ILR or ALR transformation - ILR here
  ilr.comp <- ilr(act.comp)
  
# Determine mean composition
  m.comp <- as.vector(mean(act.comp))
  names(m.comp) <- c("Sleep", "DomSoc", "PA", "QuietT","Screen", "School")
  
# Define variable vectors
  var.WAI <- raw.data$WAI

  # Define covariate vectors
  cov.sex <- factor(raw.data$sex)
  cov.age <- raw.data$age
  cov.ses <- raw.data$ses3
  
  # Define diet vectors
  diet.unH3 <- raw.data$unH3
  diet.FV3 <- raw.data$FV3
  diet.w3sd <- raw.data$w3sugardrinks
  
  # Predictive Regression Models
  model.wai <- lm(var.WAI ~ ilr.comp + diet.unH3 + diet.FV3 + diet.w3sd + cov.sex + cov.age + cov.ses)

# # Calculate mean fitness and mean bmi
#   # Calculate means
#   mean.wai <- predict(model.wai, 
#                       newdata = list(
#                         ilr.comp = ilr(m.comp), 
#                         cov.sex = "1", 
#                         cov.age = mean(cov.age), 
#                         cov.ses = mean(cov.ses)
#                       )
#   )