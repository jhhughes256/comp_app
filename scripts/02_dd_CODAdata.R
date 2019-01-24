# CODAdata
# -----------------------------------------------------------------------------
# Implementation of R markdown document sent via email on 16th Jan 2019.
# Requires R 3.4.x to run!!!
# Looks at a different dataset... unsure if this is the final dataset
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Prepare work environment
# Load packages
  library(compositions)
  library(zCompositions)
  library(lmtest)

# Load data
  rawdata <- read.csv("raw_data/subset of codadata.csv")
  
# Clean data
# Activity data come from accelerometry - exclude invalid values
  dataset <- rawdata[
    !is.na(rawdata$fcsalspt1) &  # valid sleep
    rawdata$fcvalidwkwe == "1" &  # valid waking wear time
    rawdata$fcvalidmin == "1" &  # some other measure of validity
    rawdata$fcflaccel == "0"  # some other measure of validity
  , ]
  
# Get activity composition
  act.df <- with(dataset, data.frame(
    sl = fcsalspt1,
    sb = fcallsdtm,
    lpa = fcallligtm,
    mvpa = fcallmvtm
  ))
  
# Zeros are a problem because we can't do log-ratios with zeros
# Standard practice is to replace them with a very small value
  missingSummary(act.df)  # only 1 zero, in MVPA
  
# Replace zeros with a "detection limit" (65% of a minute)
  act.comp <- acomp(act.df, detectionlimit = -0.65*1/1440)
  missingSummary(act.comp)  # no missings now
  
# Express as isometric log ratios
  ilr.comp <- ilr(act.comp)
  
# Define outcomes
  ql <- dataset$fcpqtot  # quality of life
  sbp <- dataset$fcbrspmn  # systolic blood pressure
  dbp <- dataset$fcbrdpmn  # diastolic blood pressure
  bmi <- dataset$fcbmizc  # zBMI
  waist <- dataset$fcwaist  # waist circumference, in cm
  fat <- dataset$fcfatper  # % body fat
  triglyc <- dataset$fcb02c14a2  # triglycerides
  chol <- dataset$fcb02c11a2  # cholesterol
  ldl <- dataset$fcb02c11d2  # LDL
  hdl <- dataset$fcb02c11e2  # HDL
  glyca <- dataset$fcb02c042  # GlycA

# Define covariates
  age <- dataset$fcage
  sep <- dataset$fsep2  # socioeconomic position
  sex <- factor(dataset$zf02m1cp)
  pub <- dataset$fcpds  # puberty
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Models
# Quality of Life
  model <- lm(ql ~ ilr.comp + age + sep + sex + pub)
  summary(model)
  car::Anova(model)
  plot(model)
