# Model for Interactive Heatmap used with Compositions
# -----------------------------------------------------------------------------
# Prepare model workspace
# Load data
  raw.data <- read.csv("model/Fairclough.csv")
  raw.data <- raw.data[1:169, ] # Remove the last three empty rows

# Make activity data.frame
  activity <- with(raw.data, data.frame(
    Sleep = sleep,
    Sed = Sedentary,
    Light = Light,
    MVPA = MVPA
  ))
  
# Use acomp() to create Aitchison Composition
  act.comp <- acomp(activity)

# For reallocations use any ILR or ALR transformation - ILR here
  ilr.comp <- ilr(act.comp)
  
# Determine mean composition
  m.comp <- as.vector(mean(act.comp))
  names(m.comp) <- c("Sleep", "SB", "LPA", "MVPA")
  
# Define variable vectors
  var.fit <- raw.data$Total.20m.Shuttles
  var.bmi <- raw.data$zBMI
  
# Define covariate vectors
  cov.sex <- factor(raw.data$Sex)
  cov.age <- raw.data$Decimal.Age..y.
  cov.ses <- raw.data$IMD.Decile
  
# Predictive Regression Models
  model.fit <- lm(var.fit ~ ilr.comp + cov.sex + cov.age + cov.ses)
  model.bmi <- lm(var.bmi ~ ilr.comp + cov.age + cov.sex)

# Calculate mean fitness and mean bmi
  mean.fit <- predict(model.fit, 
    newdata = list(
      ilr.comp = ilr(m.comp), 
      cov.sex = "1", 
      cov.age = mean(cov.age), 
      cov.ses = mean(cov.ses)
    )
  )
  mean.bmi <- predict(model.bmi, 
    newdata = list(
      ilr.comp = ilr(m.comp), 
      cov.sex = "1", 
      cov.age = mean(cov.age)
    )
  )