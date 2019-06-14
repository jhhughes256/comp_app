# ui.R script for Time-Use Optimisation shinydashboard prototype App
# The user-interface and widget input for the Shiny application is defined here
# Sends user-defined input to server.R, calls created output from server.R
# ------------------------------------------------------------------------------
# Example of proposed shinydashboard structure for full app

# Header: More can be done here, but just simple for now
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  header <- dashboardHeader(
  	titleWidth = 250,
    title = "Time-Use Optimisation"
  )  #dashboardHeader
  
# Sidebar: Can contain tabs, can also contain inputs if desired
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Determines how many tabs exist in the body of the ui
  sidebar <- dashboardSidebar(
  	width = 250, #Width of sidebar the same as width of header
    
  # Sidebar options
    sidebarMenu(
  		menuItem("Patient Information", tabName = "patient-tab", 
  		  icon = icon("child")
  		),  # menuItem.patient-tab
  		menuItem("Time Allocation", tabName = "time-tab", 
  		  icon = icon("time", lib = "glyphicon")
  		),  # menuItem.time-tab
  		br(),
  		div(style = "padding-left: 60px", actionButton("console", "Debug Console"))
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
    			box(title = "Patient Data Input", width = 12, status = "primary",
    			  column(width = 4,
    			    radioButtons("sex", "Sex", 
                choices = list("Male" = 1, "Female" = 0), inline = TRUE
              )  # radioButtons.sex
    			  ), # column.sex
            column(width = 4,
              numericInput("age", "Age (years)", 
                value = 10
              )  # numericInput.age
            ), # column.age
    			  column(width = 4,
    			    numericInput("ses", "SES",
                value = 2, min = 1, max = 9, step = 1
              )  # numericInput.ses
    			  )  # column.ses
    		  )  # box.patient-input
  		  ), # fluidRow.patient-input  
  		  
  		  fluidRow(
    			box(title = "Current Time Allocation Input", width = 6, status = "primary",
    			  fluidRow(
    			    column(width = 8,
    			      numericInput("initSleep", "Sleep (hours)",
                  value = 11, step = 1
  			        )  # numericInput.initSleep.hours
    			    ),
    			    column(width = 4,
    			      numericInput("initSleepmin", "(mins)",
    			        value = 42, step = 1, min = 0, max = 60
    			      )  # numericInput.initSleep.minutes
    			    )
    			  ),  # fluidRow.initSleep
    			  
    			  fluidRow(
    			    column(width = 8,
    			      numericInput("initDomSoc", "Domestic/Social/SelfCare (hours)",
                  value = 4, step = 1
  			        )  # numericInput.initDomSoc.hours
    			    ),
    			    column(width = 4,
    			      numericInput("initDomSocmin", "(mins)",
                  value = 36, step = 1, min = 0, max = 60
  			        )  # numericInput.initDomSoc.minutes
    			    )
    			  ),  # fluidRow.initDomSoc
    			  
    			  fluidRow(
    			    column(width = 8,
      			    numericInput("initPA", "Physical Activity (hours)",
                  value = 2, step = 1
      			    ) # numericInput.initPA.hours
    			    ),
    			    column(width = 4,
    			      numericInput("initPAmin", "(mins)",
                  value = 54, step = 1, min = 0, max = 60
  			        )  # numericInput.initPA.minutes
    			    )
    			  ),  # fluidRow.initPA
    			  
    			  fluidRow(
    			    column(width = 8,
      			    numericInput("initQuietT", "Quiet Time/Passive Transport (hours)",
                  value = 1, step = 1
      			    ) # numericInput.initQuietT
    			    ),
    			    column(width = 4,
    			      numericInput("initQuietTmin", "(mins)",
                  value = 24, step = 1, min = 0, max = 60
  			        )  # numericInput.initQuietT.minutes
    			    )
    			  ),  # fluidRow.initQuietT
    			  
    			  fluidRow(
    			    column(width = 8,
      			    numericInput("initSchool", "School-Related",
                  value = 1, step = 1
      			    )  # numericInput.initSchool
    			    ),
    			    column(width = 4,
    			      numericInput("initSchoolmin", "(mins)",
                  value = 24, step = 1, min = 0, max = 60
  			        )  # numericInput.initSchool.minutes
    			    )
    			  ),  # fluidRow.initSchool
    			  
    			  fluidRow(
    			    column(width = 8,
      			    numericInput("initScreen", "Screen Time",
                  value = 1.5, step = 1
      			    )  # numericInput.initScreen
    			    ),
    			    column(width = 4,
    			      numericInput("initScreenmin", "(mins)",
                  value = 30, step = 1, min = 0, max = 60
  			        )  # numericInput.initScreen.minutes
    			    )
    			  ), # fluidRow.initScreen
    			  div(textOutput("err1"), style = "color: red")
    			), # box.time-input
    			
    			box(title = "Current Dietary Intake Input (serves)", width = 6, status = "primary",
    			  numericInput("initFV", "Fruit and Veg",
              value = 3.3, step = 0.1
  			    ), # numericInput.initFV
  			    numericInput("initSD", "Sugary Drinks",
              value = 1.1,  step = 0.1
  			    ), # numericInput.initSugaryDrinks
  			    numericInput("initUnH", "Unhealthy food items",
              value = 1.7,  step = 0.1
  			    )  # numericInput.initUnH
    			)  # box.dietary-input
  		  )  # fluidRow.timediet-input
  		), # patient-tab
      
  ### Time Allocation Tab
  		tabItem(tabName = "time-tab",
  		  
  		# Time Allocation
  		  column(width = 6,
  		    box(title = "Allocate New Time Schedule", width = 12, 
            sliderInput("Sleep", "Sleep", 
              value = 0, min = -60, max = 60, ticks = FALSE
            ), # sliderInput.Sleep
  		      sliderInput("DomSoc", "Domestic/Social/SelfCare", 
  		        value = 0, min = -60, max = 60, ticks = FALSE
  		      ), # sliderInput.DomSoc
  		      sliderInput("PA", "Physical Activity", 
  		        value = 0, min = -60, max = 60, ticks = FALSE
  		      ), # sliderInput.PA
  		      sliderInput("QuietT", "Quiet Time/Passive Transport", 
  		        value = 0, min = -60, max = 60, ticks = FALSE
  		      ), # sliderInput.QuietT
  		      sliderInput("School", "School-Related", 
  		        value = 0, min = -60, max = 60, ticks = FALSE
  		      ), # sliderInput.School
  		      sliderInput("Screen", "Screen-Time", 
  		        value = 0, min = -60, max = 60, ticks = FALSE
  		      ),  # sliderInput.Screen
    			  div(textOutput("err2"), style = "color: red")
          ), # box.changetime
  		    
  		    box(title = "Allocate New Diet Servings", width = 12,
  		      sliderInput("FV", "Fruit and Veg", 
  		        value = 0, step = 0.1, min = -3, max = 3, ticks = FALSE
  		      ), # sliderInput.FV
  		      sliderInput("SD", "Sugary Drinks", 
  		        value = 0, step = 0.1, min = -3, max = 3, ticks = FALSE
  		      ), # sliderInput.SD
  		      sliderInput("UnH", "Unhealthy food items", 
  		        value = 0, step = 0.1, min = -3, max = 3, ticks = FALSE
  		      )  # sliderInput.UnH
  		    )  # box.changediet
  		  ), # column.left
          
  		# d3 Histogram
  		  column(width = 6,
  		    box(width = 12, align = "center",
  		      d3Output("d3hist", width = "100%", height = "520px")
  		    ), # box.d3hist
  		# Outcomes
  		    box(title = "Outcomes", width = 12, align = "center",
  		      valueBox(textOutput("specific"), "Wai", width = 12),
  		      actionButton("reset_input", "Reset Sliders")
  		    )  # box.outcome
  		  )  # column.right
  		)	# time-tab
    )  # tabItems
  )  # dashboardBody

# UI end
  dashboardPage(header, sidebar, body)