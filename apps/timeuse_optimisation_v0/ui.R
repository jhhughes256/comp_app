# ui.R script for Time-Use Optimisation shinydashboard prototype App
# The user-interface and widget input for the Shiny application is defined here
# Sends user-defined input to server.R, calls created output from server.R
# ------------------------------------------------------------------------------
# Example of proposed shinydashboard structure for full app

# Header: More can be done here, but just simple for now
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  header <- dashboardHeader(
  	titleWidth = 300,
    title = "Time-Use Optimisation"
  )  #dashboardHeader
  
# Sidebar: Can contain tabs, can also contain inputs if desired
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Determines how many tabs exist in the body of the ui
  sidebar <- dashboardSidebar(
  	width = 300, #Width of sidebar the same as width of header
    
  # Sidebar options
    sidebarMenu(
  		menuItem("Patient Information", tabName = "patient-tab", 
  		  icon = icon("child")
  		),  # menuItem.patient-tab
  		menuItem("Time Allocation", tabName = "time-tab", 
  		  icon = icon("time", lib = "glyphicon")
  		),  # menuItem.time-tab
      menuItem("Results", tabName = "result-tab", 
        icon = icon("file")
      ),  # menuItem.result-tab
  		br(),
  		div(style = "padding-left: 90px", actionButton("console", "Debug Console"))
    )  # sidebarMenu
    
  )  # dashboardSidebar
  
# Body: Main content of each tab, as determined by sidebar
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  body <- dashboardBody(
    tabItems(
      
  ### Patient Information Tab
  		tabItem(tabName = "patient-tab",
  		  
  		# Covariate and Initial Composition Input
  		  fluidRow(
    			box(title = "Patient Data Input", width = 6, status = "primary",
    			  radioButtons("sex", "Sex", 
              choices = list("Male" = 1, "Female" = 0), inline = TRUE
            ),  # radioButtons.sex
            numericInput("age", "Age (years)", 
              value = 10
            ),  # numericInput.age
            numericInput("ses", "SES",
              value = 2, min = 1, max = 9, step = 1
            )  # numericInput.ses
    		  ),  # box.patient-input
  		    
  		    box(title = "Time Schedule Input (hours)", width = 6, status = "primary",
  		      numericInput("initSleep", "Sleep",
  		        value = 9
  		      ),  # numericInput.initSleep
  		      numericInput("initSB", "Sedentary Activity",
  		        value = 8.5
  		      ),  # numericInput.initSB
  		      numericInput("initLPA", "Light Physical Activity",
  		        value = 6
  		      ),  # numericInput.initLPA
  		      numericInput("initMVPA", "Moderate/Vigorous Physical Activity",
  		        value = 0.5
  		      )  # numericInput.initMVPA
  		    )  # box.time-input
  		  ),
  		  
  		# Model Selection Input
  		  box(title = "Patient Outcome Ranking", width = 12, status = "primary",
  		    orderInput("source", "Outcome Choices", 
  		      items = outcomes, as_source = T, connect = "select"
  		    ),  # orderInput.source
          orderInput("select", "Outcome Ranking", 
            items = NULL, placeholder = "Drag and rank outcomes here..."
          )  # orderInput.dest
  		  )  # box.outcomes-input
  		),  # patient-tab
      
  ### Time Allocation Tab
  		tabItem(tabName = "time-tab",
  		  
  		# Reallocation Heatmap input
        box(title = "Allocate New Time Schedule", width = 12, align = "center",
        # d3 Histogram
          d3Output("d3hist", width = "400px", height = "300px"),
        # Heatmap
          radioButtons("method", "Choose reallocation method:", inline = TRUE,
            choices = list("One-for-one", "One-for-remaining")
          ),  # radioButtons
          plotOutput("plot",
            click = clickOpts("plot_click"),
            height = 250, width = 300
          ),  # plotOutput
        # Reset buttons
          fluidRow(
            div(class = "Reset",
              actionButton("resetSliders", "Reset slider")
            ),  # div.resetSliders
            div(class = "Reset",
              actionButton("resetAll", "Reset all changes")
            ),  # div.resetAll
            tags$head(tags$style(type = "text/css", 
              ".Reset {display: inline-block}")
            )  # tags.inline
          ),  # fluidRow.reset
        # Slider
          uiOutput("slidersUI")
        )  # box.reallocation-output
  		),	# patient-tab
      
  ### Reallocation Results Tab
    	tabItem(tabName = "result-tab",
    		fluidRow(
    		  box(title = "Specific Outcome Changes", status = "warning",
    		    htmlOutput("specific")
    		  ),  # box.iresults
    		  box(title = "Overall Outcome Change", status = "success",
    		    htmlOutput("overall")
    		  )  # box.results
    		)  # fluidRow
    	)  # result-tab
    )  # tabItems
  )  # dashboardBody

# UI end
  dashboardPage(header, sidebar, body)