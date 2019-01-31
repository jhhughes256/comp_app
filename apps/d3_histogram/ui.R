# UI for d3 Histogram
# -----------------------------------------------------------------------------
# User Interface Expressions
  fluidPage(
    inputPanel(
      sliderInput("bar_max", label = "Max:",
        min = 0.1, max = 1.0, value = 0.2, step = 0.1
      )  # sliderInput
    ),  # inputPanel
    d3Output("d3")
  )