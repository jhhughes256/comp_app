# server.R script for for Time-Use Optimisation shinydashboard prototype App
# Reactive objects (i.e., those dependent on widget input) are written here
# ------------------------------------------------------------------------------
## Server: all reactive values, output and ui elements
  server <- function(input, output, session) {
    
# Initial Composition and Outcome Values
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Reactive objects based on user data from the patient-tab
    
  # Define initial times
    init.time <- reactive({
      data.frame(
        Sleep = input$initSleep + input$initSleepmin/60,
        DomSoc = input$initDomSoc + input$initDomSocmin/60,
        PA = input$initPA + input$initPAmin/60,
        QuietT = input$initQuietT + input$initQuietTmin/60,
        School = input$initSchool + input$initSchoolmin/60,
        Screen = input$initScreen + input$initScreenmin/60
      )
    })
    
  # Define initial composition
  # Based on input if it adds up to 24, otherwise based on mean composition
    init.comp <- reactive({
      if (sum(init.time()) == 24) {
        acomp(init.time())
      } else {
        m.comp
      }
    })
    
  # Define initial diet
    init.diet <- reactive({
      c("unH" = input$initUnH, "FV" = input$initFV, "w3sd" = input$initSD)
    })
    
  # Capture reallocated times
    reall.time <- reactive({
      c(input$Sleep, input$DomSoc, 
        input$PA, input$QuietT, 
        input$School, input$Screen)
    })
    
  # Define reactive times
    Rtime <- reactive({
      if (sum(reall.time()) == 0) {
        out <- init.time()[1,] + reall.time()/60
        names(out) <- c("Sleep", "DomSoc", "PA", "QuietT", "School", "Screen")
        return(out)
      } else {
        init.time()
      }
    })
    
  # Define reactive composition
    Rcomp <- reactive({
      acomp(Rtime())
    })
    
  # Define reactive diet
    Rdiet <- reactive({
      reall.diet <- c(
        input$UnH, input$FV, input$SD
      )
      init.diet() - reall.diet
    })
    
  # Define error text that checks whether initial time inputs adds up to 24
    output$err1 <- renderText({
      if (sum(init.time()) != 24) {
        diff <- 24 - sum(init.time())
        more.less <- ifelse(diff > 0, "add", "remove")
        hours <- floor(abs(diff))
        mins <- round((abs(diff) - hours)*60)
        hours.mins <- paste0(
          ifelse(hours == 0, "", paste(hours, "hour(s)")),
          ifelse(hours == 0 | mins == 0, "", " and "),
          ifelse(mins == 0, "", paste(mins, "minute(s)"))
        )
        paste(err1.string, "Please", more.less, hours.mins)
      } else {
        " "
      }
    })
    
  # Define error text that checks whether reallocation time inputs adds up to 0
    output$err2 <- renderText({
      if (sum(reall.time()) != 0) {
        diff <- 0 - sum(reall.time())
        more.less <- ifelse(diff > 0, "add", "remove")
        mins <- abs(diff)
        paste(err2.string, "Please", more.less, mins, "minute(s)")
      } else {
        " "
      }
    })
    
  # Reset all sliders on second tab
    observeEvent(input$reset_input, {
      inputs <- c("Sleep", "DomSoc", "PA", "QuietT", "School", "Screen", "FV", "SD", "UnH")
      for (i in 1:length(inputs)) {
        id <- inputs[i]
        session$sendInputMessage(id, list(value = 0))
      }
    })
    
# Reactive composition output
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Output for reactive d3 histogram
    
  # Create reactive object to send to d3 script
    d3.data <- reactive({

    # If less than an hour show in minutes
      rounded.comp <- round(Rcomp()[1,]*24, 1)
      comp.units <- rep(" hours", length(rounded.comp))
      comp.units[rounded.comp < 1] <- " mins"
      rounded.comp[rounded.comp < 1] <- round(Rcomp()[1,]*1440)[rounded.comp < 1]
      
    # Output dataframe for d3 script
      data.frame(
        prop = Rcomp()[1,]*2,  # affects maximal size of histogram columns
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
    
  # Define predictions for initial composition
    init.pred <- reactive({
      out <- predict(model.wai, 
        newdata = list(
          ilr.comp = ilr(init.comp()), 
          cov.sex = input$sex, 
          cov.age = input$age, 
          cov.ses = input$ses,
          diet.FV3 = init.diet()["FV"],
          diet.unH3 = init.diet()["unH"],
          diet.w3sd = init.diet()["w3sd"]
        )  #list
      )  #predict
      names(out) <- "Wai"
      return(out)
    })
    
  # Define predictions for reallocation composition
    reall.pred <- reactive({
      out <- predict(model.wai, 
        newdata = list(
          ilr.comp = ilr(Rcomp()), 
          cov.sex = input$sex, 
          cov.age = input$age, 
          cov.ses = input$ses,
          diet.FV3 = Rdiet()["FV"],
          diet.unH3 = Rdiet()["unH"],
          diet.w3sd = Rdiet()["w3sd"]
        )  #list
      )  #predict
      names(out) <- "Wai"
      return(out)
    })
    
  # Compute difference between initial and reallocated predictions
    delta.pred <- reactive({
      round(100*(init.pred() - reall.pred())/init.pred(), 2)
    })
    
  # Reallocation results
    output$specific <- renderText({
      paste0(delta.pred(), "%")
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