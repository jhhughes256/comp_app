# UI for Interactive Heatmap used with Compositions
# -----------------------------------------------------------------------------
# Basic fluidPage UI with title, alignment centre
fluidPage(align = "center",
  h2("Compositions Core"),
  br(),
    
# Radio buttons for choosing which reallocation method is selected
  radioButtons("method", "Choose reallocation method:", inline = TRUE,
    choices = list("One-for-one", "One-for-remaining")
  ),  # radioButtons
  
# Heatmap for interacting with the reallocation matrix
  plotOutput("plot",
    click = clickOpts("plot_click"),
    height = 250, width = 300
  ),  # plotOutput
  hr(),
# Debug UI
  actionButton("console","Debug Console"),
  verbatimTextOutput("info1"),
  
# Histogram output based on the reactive composition
# Incorporates changes made with the heatmap and the sliders
  d3Output("d3hist", width = "400px", height = "300px"),
  br(),
  
# Make two reset buttons for resetting current changes or all changes
# CSS tags make the buttons inline and same width
  fluidRow(
    div(class = "Reset",
      actionButton("resetSliders", "Reset slider")
    ),
    div(class = "Reset",
      actionButton("resetAll", "Reset all changes")
    ),
    tags$head(tags$style(type = "text/css", ".Reset {display: inline-block}"))
  ),  # fluidRow.resetButtons
  br(),
  
# Reactive slider UI from server
# Changes the reactive composition based on the reallocation matrix
  uiOutput("slidersUI")
)  # fluidPage