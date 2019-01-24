# Non-reactive objects/expressions
# Load package libraries
  library(ggplot2)
  
# Define activities
  activity <- c("Sleep", "SB", "LPA", "MVPA")
  nact <- length(activity)
  
# Define functions
  inGrid <- function(coord, axis, n) {
    out <- coord
    if (coord[axis] < 1) {
      out[axis] <- 1
    } else if (coord[axis] > n) {
      out[axis] <- n
    }
    out
  }
  
# Define heatmap theme
  heatmap.theme <- theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    axis.title.y = element_text(angle = 0),
    legend.position = "none"
  )

# -----------------------------------------------------------------------------
# Reactive objects/expressions
  shinyServer(function(input, output, session) {
    
  # Set up reactive values to keep track of heatmap matrix
    rv <- reactiveValues(v = matrix(c(
      0, 0, 0, -1, 
      0, 0, -1, 0, 
      0, -1, 0, 0, 
      -1, 0, 0, 0), ncol = 4)
    )  # rv
    
  # Create heatmap data
    Rdata <- reactive({
      data <- expand.grid(activity, rev(activity))
      names(data) <- c("a1", "a2")
      data$v <- factor(as.vector(rv$v))
      levels(data$v) <- c(0, 2, 1)
      return(data)
    })  # Rdata
    
  # Plot the heatmap matrix
    output$plot <- renderPlot({
      ggplot(data = Rdata(), aes(x = a1, y = a2, fill = v)) + 
      geom_tile(colour = "black") + 
      scale_fill_manual(values = c("grey", "white", "red")) + 
      scale_x_discrete("Swap\n", position = "top") + 
      scale_y_discrete("\n\n\n\nFor  ") + 
      theme_minimal(base_size = 18) + 
      heatmap.theme
    })  # output$plot
    
  # Output the info gained from clicking on plot points
    output$info <- renderPrint({
      t(rv$v[, 4:1])
    })  # output$info
    
  # Process data gained from clicking plot points
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
    
  # Observe Rclick() to update matrix if plot is clicked
    observeEvent(Rclick(), {
    # Check to see if plot clicked since app start, if not nothing happens
      if (!is.null(Rclick())) {
      # Check to see whether box clicked on is currently white (0) or red (1)
      # If white turn red, if red turn white
        if (rv$v[Rclick()$x, Rclick()$y] == 0) {
          rv$v[Rclick()$x, Rclick()$y] <- 1
        } else if (rv$v[Rclick()$x, Rclick()$y] == 1) {
          rv$v[Rclick()$x, Rclick()$y] <- 0
        }
      }
    })  # observeEvent.Rclick
    
  })  # shinyServer