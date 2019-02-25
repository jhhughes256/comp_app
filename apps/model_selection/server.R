# Server for Model Selection App
# -----------------------------------------------------------------------------
# Reactive objects/expressions
  shinyServer(function(input, output, session) {
    
  # Data input from patient
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    input.comp <- reactive({
      acomp(data.frame(
        Sleep = input$Sleep,
        SB = input$SB,
        LPA = input$LPA,
        MVPA = input$MVPA
      ))
    })
    
    Rdata <- reactive({
      newdata <- list(
        ilr.comp = ilr(input.comp()), 
        cov.sex = input$sex, 
        cov.age = input$age, 
        cov.ses = input$ses
      )
    })
    
  # Model output selection
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Run models based on user selection
  # Currently reruns whenever user changes order
  # Ideally, it would rerun only when different models are selected
  # Then another function would reorder the model output dependent on input
    Routcomes <- reactive({
      ord.in <- input$select_order
      out <- llply(ord.in, function(x) {
        predict(models[[x]]$mod, 
          Rdata()
        )
      })
      names(out) <- ord.in
      return(out)
    })
    
    output$outcomes <- renderText({
      paste(unlist(llply(names(Routcomes()), function(x) {
        paste0("<p>", x, ": ", signif(Routcomes()[[x]], 3), "</p>")
      })), collapse = "")
    })
  
  # Define session behaviour
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Close the R session when Chrome closes
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
    
  })  # shinyServer