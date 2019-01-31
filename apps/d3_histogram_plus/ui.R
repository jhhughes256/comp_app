# UI for d3 Histogram
# -----------------------------------------------------------------------------
# User Interface Expressions
  fluidPage(
    inputPanel(
      sliderInput("barcol1", label = "Column 1:",
        min = 0.1, max = 10, value = 2, step = 0.1
      ),  # sliderInput.barcol1
      sliderInput("barcol2", label = "Column 2:",
        min = 0.1, max = 10, value = 2, step = 0.1
      ),  # sliderInput.barcol2
      sliderInput("barcol3", label = "Column 3:",
        min = 0.1, max = 10, value = 2, step = 0.1
      ),  # sliderInput.barcol3
      sliderInput("barcol4", label = "Column 4:",
        min = 0.1, max = 10, value = 2, step = 0.1
      )  # sliderInput.barcol4
    ),  # inputPanel
    d3Output("d3"),
    verbatimTextOutput("selected")
  )