# UI for Model Selection App
# -----------------------------------------------------------------------------
# Basic fluidPage UI with title, alignment centre
fluidPage(align = "center",
  h2("Model Selection"),
  br(),
  
  actionButton("console","Debug Console"),
  
# Original Time Allocation
  fluidRow(
		div(class = "MyClass", numericInput("Sleep", "Sleep (mins)", 
		  value = 549, width = "100px")),
		div(class = "MyClass", numericInput("SB", "SB (mins)", 
		  value = 510, width = "100px")),
		div(class = "MyClass", numericInput("LPA", "LPA (mins)", 
		  value = 355, width = "100px")),
    div(class = "MyClass", numericInput("MVPA", "MVPA (mins)", 
      value = 26, width = "100px")),
		tags$head(tags$style(type = "text/css", ".MyClass {display: inline-block}"))
	),  # fluidRow
  
# Covariate UI
  radioButtons("sex", "Sex", 
    choices = list("Male" = 1, "Female" = 0), inline = TRUE
  ),  # radioButtons.sex
  numericInput("age", "Age (years)", 
    value = 10
  ),  # numericInput.age
  numericInput("ses", "SES",
    value = 2, min = 1, max = 9, step = 1
  ),
  
# Drag and drop model selection
  orderInput("source", "Outcome Choices", 
    items = outcomes, as_source = T, connect = "select"
  ),  # orderInput.source
  orderInput("select", "Outcome Ranking", 
    items = NULL, placeholder = "Drag and rank outcomes here..."
  ),  # orderInput.dest
  
# Model output
  htmlOutput("outcomes")
    
)  # fluidPage