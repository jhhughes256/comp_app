# UI for Interactive Heatmap used with Compositions
# -----------------------------------------------------------------------------

fluidPage(
  h2("Heatmap Buttons"),  
  actionButton("console","Debug Console"),
  br(),
  radioButtons("method", "Choose reallocation method:", inline = TRUE,
    choices = list("One-for-one", "One-for-remaining")
  ),  # radioButtons
  plotOutput("plot",
    click = clickOpts("plot_click"),
    height = 250, width = 300
  ),  # plotOutput
  hr(),
  # verbatimTextOutput("info1"),  # debug
  d3Output("d3hist", width = "600px", height = "300px"),
  br(),
  uiOutput("slidersUI"),
  align = "center"
)