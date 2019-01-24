# UI for Interactive Heatmap used with Compositions
# -----------------------------------------------------------------------------

fluidPage(
  h2("Heatmap Buttons"),
  br(),
  plotOutput("plot",
    click = clickOpts("plot_click"),
    height = 250, width = 300
  ),  # plotOutput
  hr(),
  verbatimTextOutput("info1"),
  uiOutput("slidersUI"),
  verbatimTextOutput("info2"),
  align = "center"
)