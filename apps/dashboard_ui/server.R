# server.R script for for Time-Use Optimisation shinydashboard prototype App
# Reactive objects (i.e., those dependent on widget input) are written here
# ------------------------------------------------------------------------------
## Server: all reactive values, output and ui elements
  server <- function(input, output, session) {
  
  # Define session behaviour
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Close the R session when Chrome closes
    session$onSessionEnded(function() {
      stopApp()
    })

  # Open console for R session
    # observe(label = "console", {
    #   if(input$console != 0) {
    #     options(browserNLdisabled = TRUE)
    #     isolate(browser())
    #   }
    # })
  
  }  #server