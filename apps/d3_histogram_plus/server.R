# Shiny Server for d3 Histogram
# -----------------------------------------------------------------------------
# Reactive objects/expressions
  shinyServer(function(input, output) {
    # The dataset in this example comes from the four sliders in the UI
    # The user selects the value for each of the histogram columns
    # This is then stored in two ways, as the direct input AND as a proportion
    #   of the maximum value selected. This is stored like a data.frame to 
    #   ensure that r2d3 can convert it to the appropriate format.
    Rdata <- reactive({
      val <- c(input$barcol1, input$barcol2, input$barcol3, input$barcol4)
      prop <- val/max(val)
      data.frame(val, prop)
    })
    
    # d3 output
    output$d3 <- renderD3({
      r2d3(
        Rdata(),  # here we provide the d3 script with data
        script = "script.js"  # and here we call the script
      )  # r2d3
    })  # renderD3
    
    # selected column output
    output$selected <- renderText({
      as.numeric(req(input$bar_clicked))
    })
  })  # shinyServer