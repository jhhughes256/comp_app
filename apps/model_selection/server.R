# Server for Model Selection App
# -----------------------------------------------------------------------------
# Reactive objects/expressions
  shinyServer(function(input, output, session) {
    
  Rdata <- reactive({
    newdata = list(
      ilr.comp = ilr(m.comp), 
      cov.sex = "1", 
      cov.age = mean(cov.age), 
      cov.ses = mean(cov.ses)
    )
  })
    
  Routcomes <- reactive({
    ord.in <- input$select_order
    out <- llply(ord.in, function(x) {
      predict(models[[x]]$mod, 
        Rdata()
      )
    })
    names(out) <- ord.in
    out
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