# Server for Interactive Heatmap used with Compositions
# -----------------------------------------------------------------------------
# Reactive objects/expressions
  shinyServer(function(input, output, session) {
    
  # Prepare reactive environment
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Define intial values for reactiveValues object
    r <- reactiveValues(
    # heatmap matrix
      m = matrix(c(
        0, 0, 0, -1, 
        0, 0, -1, 0, 
        0, -1, 0, 0, 
        -1, 0, 0, 0
      ), ncol = 4),
    # composition residual
      rc = c("Sleep" = 0, "Sed" = 0, "Light" = 0, "MVPA" = 0),
    # reallocation vector
      rv = c("Sleep" = 0, "Sed" = 0, "Light" = 0, "MVPA" = 0),
    # I/O switch for re-rendering of reactiveSliders
      update = 1
    )  # r
    
  # Heatmap interactive-plot widget
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Create heatmap data
  # Dependent on r$m
    Rdata <- reactive({
      data <- expand.grid(activity, rev(activity))
      names(data) <- c("a1", "a2")
      data$v <- factor(as.vector(r$m))
      levels(data$v) <- c(0, 2, 1)
      return(data)
    })  # Rdata
    
  # Plot the heatmap matrix
  # Dependent on Rdata()
    output$plot <- renderPlot({
      ggplot(data = Rdata(), aes(x = a1, y = a2, fill = v)) + 
      geom_tile(colour = "black") + 
      scale_fill_manual(values = c("grey", "white", "red")) + 
      scale_x_discrete("Swap\n", position = "top") + 
      scale_y_discrete("\n\n\n\nFor  ") + 
      theme_minimal(base_size = 18) + 
      heatmap.theme
    })  # output$plot
    
  # Process data gained from clicking plot points
  # Dependent on user input using output$plot
    Rclick <- reactive({
    # Check to see if plot clicked since app start
      if (!is.null(input$plot_click)) {
      # Read in coordinates and round to integer
        coord <- list(
          x = round(input$plot_click$x),
          y = round(input$plot_click$y)
        )
      # Check and correct if user clicked outside of plot
        coord[names(which(coord < 1))] <- 1
        coord[names(which(coord > nact))] <- nact
      # Output
        return(coord)
    # If no click since app start pass NULL on to observeEvent()
      } else if (is.null(input$plot_click)) {
        return(input$plot_click)
      }
    })  # Rclick
    
  # Observe input$method to reset the matrix when changed
    observeEvent(input$method, {
      r$m[r$m != -1] <- 0
    }) 
    
  # Observe Rclick() to update matrix if plot is clicked
  # Dependent on Rclick(); changes r$m
    observeEvent(Rclick(), {
      if (!is.null(Rclick())) {  # if clicked since app start
      # Check to see what radioButton is pressed (reallocation method)
        if (input$method == "One-for-one") {
          # Check to see whether box clicked on is currently white (0) or red (1)
          if (r$m[Rclick()$x, Rclick()$y] == 0) {  # if white
            r$m[r$m != -1] <- 0  # set all spaces to white
            r$m[Rclick()$x, Rclick()$y] <- 1  # set clicked space to red
          } else if (r$m[Rclick()$x, Rclick()$y] == 1) {  # if red
            r$m[Rclick()$x, Rclick()$y] <- 0
          }  # if.white.red
        } else if (input$method == "One-for-remaining") {
          # Check to see whether box clicked on is currently white (0) or red (1)
          if (r$m[Rclick()$x, Rclick()$y] == 0) {  # if white
            r$m[r$m != -1] <- 0  # set all spaces to white
            r$m[Rclick()$x, r$m[Rclick()$x, ] != -1] <- 1  # set clicked column to red
          } else if (r$m[Rclick()$x, Rclick()$y] == 1) {  # if red
            r$m[Rclick()$x, r$m[Rclick()$x, ] != -1] <- 0
          }  # if.white.red
        }  # if.input$method
      }  # if.Rclick()
    })  # observeEvent.Rclick
    
  # # Output r$m ### DEBUG ###
  #   output$info1 <- renderPrint({
  #     t(r$m[, 4:1])
  #   })  # output$info1
    
  # Reactive Sliders
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Observe r$update to detect whether UI should be rendered
  # Dependent on r$update and r$rc; renderUI isolated unless r$update == 1
  # Checks to see if 
    observe({
      if (r$update == 1) {
        output$slidersUI <- renderUI({
          fluidRow(
            if (any(r$m[1,] == 1)) { reactiveSlider("Sleep", "Sleep", r$rc) },
            if (any(r$m[2,] == 1)) { reactiveSlider("Sed", "SB", r$rc) },
            if (any(r$m[3,] == 1)) { reactiveSlider("Light", "LPA", r$rc) },
            if (any(r$m[4,] == 1)) { reactiveSlider("MVPA", "MVPA", r$rc) }
          )
        })
        r$update <- 0
      }
    })
    
  # Observe inputs to detect when user has made an input
  # Dependent on user input using output$sliderUI; changes r$rv
  # If statement checks if input is different from stored value AND
  #   whether any boxes have been ticked in the heatmap
    observeEvent(input$Sleep, {
      if(input$Sleep != round(r$rc["Sleep"]) & any(r$m[1,] == 1)) {  
        r$rv["Sleep"] <- input$Sleep + (r$rv["Sleep"] - r$rc["Sleep"])*(input$Sleep)^0
      }
    })  # observeEvent(input$Sleep)
    
    observeEvent(input$Sed, {
      if(input$Sed != round(r$rc["Sed"]) & any(r$m[2,] == 1)) {
        r$rv["Sed"] <- input$Sed + (r$rv["Sed"] - r$rc["Sed"])*(input$Sleep)^0
      }
    })  # observeEvent(input$Sed)
    
    observeEvent(input$Light, {
      if(input$Light != round(r$rc["Light"]) & any(r$m[3,] == 1)) {
        r$rv["Light"] <- input$Light + (r$rv["Light"] - r$rc["Light"])*(input$Sleep)^0
      }
    })  # observeEvent(input$Light)
    
    observeEvent(input$MVPA, {
      if(input$MVPA != round(r$rc["MVPA"]) & any(r$m[4,] == 1)) {
        r$rv["MVPA"] <- input$MVPA + (r$rv["MVPA"] - r$rc["MVPA"])*(input$Sleep)^0
      }
    })  # observeEvent(input$MVPA)
    
  # Reallocation of compositional data
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Rcomp <- reactive({
      reallocation(m.comp, r$rv, 1440, t(r$m[,4:1]))
    })
    
  # Observe r$rv to detect when reactiveSliders have user input
    observeEvent(r$rv, {
      if (all.equal(Rcomp(), m.comp) != T) {
        isolate(r$rc[1:length(r$rc)] <- (Rcomp() - m.comp)*1440)
        r$update <- 1
      }
    })
    
  # Display new composition
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Create reactive object to send to d3 script
    d3data <- reactive({
      data.frame(
        comp = Rcomp()*2,
        val = round(Rcomp()*24, 1)
      )
    })  # d3data
    
  # Call d3 script
    output$d3 <- renderD3({
      r2d3(
        d3data(),
        script = "script.js"  # and here we call the script
      )  # r2d3
    })  # renderD3
    
  })  # shinyServer