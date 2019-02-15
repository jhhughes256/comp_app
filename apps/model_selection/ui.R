# UI for Model Selection App
# -----------------------------------------------------------------------------
# Basic fluidPage UI with title, alignment centre
fluidPage(align = "center",
  h2("Model Selection"),
  br(),
  
  actionButton("console","Debug Console"),
  
# Covariate UI
  radioButtons("sex", "Sex", 
    choices = list("Male" = 1, "Female" = 0), inline = TRUE
  ),  # radioButtons.sex
  numericInput("age", "Age (years)", 
    value = 35
  ),  # numericInput.age
  numericInput("ses", "SES",
    value = 3, min = 1, max = 9, step = 1
  ),
  
# Drag and drop model selection
  orderInput("source", "Outcome Choices", 
    items = outcomes, as_source = T, connect = "select"
  ),  # orderInput.source
  orderInput("select", "Outcome Ranking", 
    items = NULL, placeholder = "Drag and rank outcomes here..."
  )  # orderInput.dest
    
)  # fluidPage