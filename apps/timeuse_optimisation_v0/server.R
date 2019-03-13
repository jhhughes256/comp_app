# server.R script for for Time-Use Optimisation shinydashboard prototype App
# Reactive objects (i.e., those dependent on widget input) are written here
# ------------------------------------------------------------------------------
## Server: all reactive values, output and ui elements
  server <- function(input, output, session) {
    
# Prepare reactive environment
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Handles I/O switches and intermediate objects
    
  # Define initial values for reactiveValues object
  r <- reactiveValues(
  # model selection
    select = NULL,
  # heatmap matrix
    m = matrix(c(
      0, 0, 0, -1, 
      0, 0, -1, 0, 
      0, -1, 0, 0, 
      -1, 0, 0, 0
    ), ncol = 4),
  # saved reactive composition
    rc = m.comp,
  # reallocation vector
    rv = c("Sleep" = 0, "SB" = 0, "LPA" = 0, "MVPA" = 0),
  # I/O switch for re-rendering of reactiveSliders
    update = 1,
  # Error state
    negerr = 0
  )  # r
    
# Initial Composition and Outcome Values
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Reactive objects based on user data from the patient-tab
    
  # Define initial composition
    init.comp <- reactive({
      acomp(data.frame(
        Sleep = input$initSleep,
        SB = input$initSB,
        LPA = input$initLPA,
        MVPA = input$initMVPA
      ))
    })
    
  # Set saved reactive composition to initial composition
    observeEvent(init.comp(), {
      r$rc <- as.vector(init.comp())
      names(r$rc) <- activity
    })
    
# Heatmap interactive-plot/widget
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Reactivity in regards to re-allocation matrix from time-tab
    
  # Create heatmap data - dependent on r$m
    heat.grid <- reactive({
      data <- expand.grid(activity, rev(activity))
      names(data) <- c("a1", "a2")
      data$v <- factor(as.vector(r$m))
      levels(data$v) <- c(0, 2, 1)
      return(data)
    })  # heat.grid
    
  # Plot the heatmap matrix - dependent on heat.grid()
    output$plot <- renderPlot({
      ggplot(data = heat.grid(), aes(x = a1, y = a2, fill = v)) + 
      geom_tile(colour = "black") + 
      scale_fill_manual(values = c("grey", "white", "red")) + 
      scale_x_discrete("Swap\n", position = "top") + 
      scale_y_discrete("\n\n\n\nFor  ") + 
      theme_minimal(base_size = 18) + 
      heatmap.theme
    })  # output$plot
    
  # Process input from heatmap - dependent on input$plot_click
    heat.click <- reactive({
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
    })  # heat.click
    
  # Observe input$method to reset the matrix when changed
    observeEvent(input$method, {
      r$m[r$m != -1] <- 0
      r$update <- 1
    }) 
    
  # Observe heat.click() to update matrix if plot is clicked - dependent on heat.click()
    observeEvent(heat.click(), {
      if (!is.null(heat.click())) {  # if clicked since app start
      # Check to see what radioButton is pressed (reallocation method)
        if (input$method == "One-for-one") {
          # Check to see whether box clicked on is currently white (0) or red (1)
          if (r$m[heat.click()$x, heat.click()$y] == 0) {  # if white
            r$m[r$m != -1] <- 0  # set all spaces to white
            r$m[heat.click()$x, heat.click()$y] <- 1  # set clicked space to red
          } else if (r$m[heat.click()$x, heat.click()$y] == 1) {  # if red
            r$m[heat.click()$x, heat.click()$y] <- 0
          }  # if.white.red
        } else if (input$method == "One-for-remaining") {
          # Check to see whether box clicked on is currently white (0) or red (1)
          if (r$m[heat.click()$x, heat.click()$y] == 0) {  # if white
            r$m[r$m != -1] <- 0  # set all spaces to white
            r$m[heat.click()$x, r$m[heat.click()$x, ] != -1] <- 1  # set clicked column to red
          } else if (r$m[heat.click()$x, heat.click()$y] == 1) {  # if red
            r$m[heat.click()$x, r$m[heat.click()$x, ] != -1] <- 0
          }  # if.white.red
        }  # if.input$method
      # Finally update the reactive composition
        r$update <- 1
      }  # if.heat.click()
    })  # observeEvent.heat.click
    
# Reallocation of Compositional Data
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Reallocation of time points in time-tab from initial composition
    
  # Observe r$update to detect whether UI should be rendered
  # Dependent on r$update and r$rc; renderUI isolated unless r$update == 1
  # Checks to see if either reset button is pressed as well, this invalidates
  #   the expression and causes the reactiveSlider to be remade without updating
  #   the saved reactive composition. It also resets the values for r$rv and/or
  #   r$rc
    observe({
      output$slidersUI <- renderUI({
        fluidRow(
          if (any(r$m == 1)) { reactiveSlider(r$m) }
        )
      })
      input$resetAll
      input$resetSliders
      r$negerr
    })
    
  # Debounce slider inputs so that they don't invalidate the server until they
  #   have ceased movement.
    debounce.Sleep <- debounce(reactive(input$Sleep), debounceSettings)
    debounce.SB <- debounce(reactive(input$SB), debounceSettings)
    debounce.LPA <- debounce(reactive(input$LPA), debounceSettings)
    debounce.MVPA <- debounce(reactive(input$MVPA), debounceSettings)
    
  # Observe inputs to detect when user has made an input
  # Dependent on user input using output$sliderUI; changes r$rv
  # If statement checks if input is different from stored value AND
  #   whether any boxes have been ticked in the heatmap
    observeEvent(input$Sleep, {
      if(input$Sleep != round(r$rc["Sleep"]) & any(r$m[1,] == 1)) {  
        r$rv <- reallocation(r$rc, c(input$Sleep, 0, 0, 0), t(r$m[, 4:1]))
      }
    })  # observeEvent(input$Sleep)
    
    observeEvent(input$SB, {
      if(input$SB != round(r$rc["SB"]) & any(r$m[2,] == 1)) {
        r$rv <- reallocation(r$rc, c(0, input$SB, 0, 0), t(r$m[, 4:1]))
      }
    })  # observeEvent(input$SB)
    
    observeEvent(input$LPA, {
      if(input$LPA != round(r$rc["LPA"]) & any(r$m[3,] == 1)) {
        r$rv <- reallocation(r$rc, c(0, 0, input$LPA, 0), t(r$m[, 4:1]))
      }
    })  # observeEvent(input$LPA)
    
    observeEvent(input$MVPA, {
      if(input$MVPA != round(r$rc["MVPA"]) & any(r$m[4,] == 1)) {
        r$rv <- reallocation(r$rc, c(0, 0, 0, input$MVPA), t(r$m[, 4:1]))
      }
    })  # observeEvent(input$MVPA)
    
  # Define a reactive composition which will be called upon by the reactive
  #   parts of the server, such as the d3 histogram.
    Rcomp <- reactive({
      r$rc + r$rv
    })
    
  # Check to see if Rcomp is ever negative. If so display an error message and
  #   reset the sliders.
    observe(
      if (any(Rcomp() < 0)) {
        neg.act <- activity[which(Rcomp() < 0)]
        r$rv[1:length(r$rv)] <- 0
        showNotification(paste(neg.act, neg.act.error),
          closeButton = FALSE, type = "error"
        )  # errorNotification
        r$negerr <- r$negerr + 1
      }
    )  # observe Rcomp() < 0

  # When user changes the method or clicks on the heatmap, r$update is set to
  #   one. This adds the reallocation vector to the reactive composition and
  #   resets the reallocation vector for the next slider.
    observeEvent(r$update == 1, {
      r$rc <- r$rc + r$rv
      r$rv[1:length(r$rv)] <- 0
      r$update <- 0
    })  #observeEvent(r$update)
    
  # Observe for when the user presses the reset buttons and set values to
  #   their original state accordingly.
    observeEvent(input$resetSliders, {
      r$rv[1:length(r$rv)] <- 0
    })  #observeEvent(input$resetSliders)
      
    observeEvent(input$resetAll, {
      r$rv[1:length(r$rv)] <- 0
      r$rc <- init.comp()
    })  #observeEvent(input$resetAll)
    
# Reactive composition output
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Output for reactive d3 histogram
    
  # Create reactive object to send to d3 script
    d3.data <- reactive({
    # Recalculate the dataset for the d3 histogram if user clicks the reset
    #   buttons.
      input$resetAll
      input$resetSliders
      
    # If less than an hour show in minutes
      rounded.comp <- round(Rcomp()*24, 1)
      comp.units <- rep(" hours", length(rounded.comp))
      comp.units[rounded.comp < 1] <- " mins"
      rounded.comp[rounded.comp < 1] <- round(Rcomp()*1440)[rounded.comp < 1]
      
    # Output dataframe for d3 script
      data.frame(
        prop = Rcomp()*2,  # affects maximal size of histogram columns
        val = rounded.comp,  # rounded composition values
        lab = activity,  # labels for histogram
        unit = comp.units  # composition units
      )
    })  # d3.data
    
  # Call d3 script to make histogram
    output$d3hist <- renderD3({
      r2d3(
        d3.data(),
        script = "script.js"  # and here we call the script
      )  # r2d3
    })  # renderD3
    
# Model Outcomes output
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Predicted outcomes from selected models on result-tab
    
  # Split the input of input$select_order into selected and ordered models
  # This prevents the models being rerun unnecessarily
    observeEvent(input$select_order, {
      conditional <- any(!(names(init.pred()) %in% input$select_order)) |
        any(!(input$select_order %in% names(init.pred())))
      if (conditional) {
        r$select <- input$select_order
      }
    })
    
  # Define predictions for initial composition
    init.pred <- reactive({
      mod.in <- r$select
      out <- llply(mod.in, function(x) {
        predict(model.list[[x]]$mod, 
          newdata = list(
            ilr.comp = ilr(init.comp()), 
            cov.sex = input$sex, 
            cov.age = input$age, 
            cov.ses = input$ses
          )
        )
      })
      names(out) <- mod.in
      return(out)
    })
    
  # Define predictions for reallocation composition
    reall.pred <- reactive({
      mod.in <- r$select
      out <- llply(mod.in, function(x) {
        predict(model.list[[x]]$mod, 
          newdata = list(
            ilr.comp = ilr(Rcomp()), 
            cov.sex = input$sex, 
            cov.age = input$age, 
            cov.ses = input$ses
          )
        )
      })
      names(out) <- mod.in
      return(out)
    })
    
  # Compute difference between initial and reallocated predictions
    delta.pred <- reactive({
      out <- llply(input$select_order, function(x) {
        round(100*(reall.pred()[[x]] - init.pred()[[x]])/init.pred()[[x]], 2)
      })
      names(out) <- input$select_order
      return(out)
    })
    
  # Reallocation results
    output$specific <- renderText({
      paste(unlist(llply(names(delta.pred()), function(x) {
        paste0("<p>", x, ": ", delta.pred()[[x]], "%</p>")
      })), collapse = "")
    })

    output$overall <- renderText({
      paste0("<p>Overall: ", sum(unlist(delta.pred())), "%</p>")
    })
  
# Define session behaviour and error messages
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Reactive objects handling errors and debug
    
  # Close the R session when browser closes
    session$onSessionEnded(function() {
      stopApp()
    })

  # Open console for R session
    observe(label = "console", {
      if(input$console != 0) {
        options(browserNLdisabled = TRUE)
        isolate(browser())
      }
    })
  
  }  #server