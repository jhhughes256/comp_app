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
  		    
    			
    			box(title = "Current Time Allocation Input (hours)", width = 6, status = "primary",
    			    numericInput("initSleep", "Sleep",
    			                 value = 11.7, step = 0.1
    			    ),  # numericInput.initSleep
    			    numericInput("initDomSoc", "Domestic/Social/SelfCare",
    			                 value = 4.6, step = 0.1
    			    ),  # numericInput.initDomSoc
    			    numericInput("initPA", "Physical Activity",
    			                 value = 2.9, step = 0.1
    			    ),# numericInput.initPA
    			    numericInput("initQuietT", "Quiet Time/Passive Transport",
    			                 value = 1.9, step = 0.1
    			    ),# numericInput.initPassivT
    			    numericInput("initSchool", "School-Related",
    			                 value = 1.4, step = 0.1
    			    ),# numericInput.initSchool
    			    numericInput("initScreen", "Screen Time",
    			                 value = 1.5, step = 0.1
    			    )# numericInput.initScreen
    			),  # box.time-input
    			
    			box(title = "Current Dietary Intake Input (serves)", width = 6, status = "primary",
    			    numericInput("initFV", "Fruit and Veg",
    			                 value = 3.3, step = 0.1
    			    ),  # numericInput.initFV
    			    numericInput("initSugaryDrinks", "Sugary Drinks",
    			                 value = 1.1,  step = 0.1
    			    ),  # numericInput.initSugaryDrinks
    			    numericInput("initUnH", "Unhealthy food items",
    			                 value = 1.7,  step = 0.1
    			    )  # numericInput.initUnH
    			)  # box.dietary-input
  		)
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
            height = 250, width = 600
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
  		),	# time-tab
      
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