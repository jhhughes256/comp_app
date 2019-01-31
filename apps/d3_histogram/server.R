# Shiny Server for d3 Histogram
# -----------------------------------------------------------------------------
# Reactive objects/expressions
  shinyServer(function(input, output) {
    # d3 output
    output$d3 <- renderD3({
      r2d3(
        runif(5, 0, input$bar_max),  # here we provide the d3 script with data
        script = "script.js"  # and here we call the script
      )  # r2d3
    })  # renderD3
  })  # shinyServer