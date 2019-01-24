fluidPage(
  h2("Heatmap Buttons"),
  br(),
  plotOutput("plot",
    click = clickOpts("plot_click"),
    height = 250, width = 300
  ),  # plotOutput
  hr(),
  fluidRow(
    verbatimTextOutput("info")
  ),  # fluidRow
  align = "center"
)