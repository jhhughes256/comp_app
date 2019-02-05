# ui.R script for Time-Use Optimisation shinydashboard prototype App
# The user-interface and widget input for the Shiny application is defined here
# Sends user-defined input to server.R, calls created output from server.R
# ------------------------------------------------------------------------------
# Example of proposed shinydashboard structure for full app
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## Header: More can be done here, but just simple for now
  header <- dashboardHeader(
  	titleWidth = 300,
    title = "Time-Use Optimisation"
  )  #dashboardHeader
  
## Sidebar: Can contain tabs, can also contain inputs if desired
# Determines how many tabs exist in the body of the ui
  sidebar <- dashboardSidebar(
  	width = 300, #Width of sidebar the same as width of header
    sidebarMenu(
  		menuItem("Patient Information", tabName = "patient-tab", 
  		  icon = icon("child")
  		),  # menuItem.patient-tab
  		menuItem("Time Allocation", tabName = "time-tab", 
  		  icon = icon("time", lib = "glyphicon")
  		),  # menuItem.time-tab
      menuItem("Results", tabName = "result-tab", 
        icon = icon("file")
      )  # ,  # menuItem.result-tab
  		# br(),
  		# div(style = "padding-left: 90px", actionButton("console","Debug Console"))
    )  # sidebarMenu
  )  # dashboardSidebar
  
## Body: Main content of each tab, as determined by sidebar
  body <- dashboardBody(
    tabItems(
  	## Patient Information Tab
  		tabItem(tabName = "patient-tab",
  			box(title = "Patient Data Input", width = 12, status = "primary",
  			  radioButtons("sex", "Sex", 
  			    choices = list("Male" = 1, "Female" = 0), inline = TRUE
  			  ),  # radioButtons.sex
  			  numericInput("age", "Age (years)", 
  			    value = 35
  			   ),  # numericInput.age
  			  numericInput("weight", "Weight (kg)", 
  			    value = 70
  			   ),  # numericInput.weight
  			  numericInput("gfr", "GFR (mL/min)", 
  			    value = 80
  			   )  # numericInput.gfr
  		  ),  # box.patient-input
  		  box(title = "Patient Outcome Ranking", width = 12, status = "primary",
  		    orderInput("source", "Outcome Choices", 
  		      items = outcomes, as_source = T, connect = "dest"
  		    ),  # orderInput.source
          orderInput("dest", "Outcome Ranking", 
            items = NULL, placeholder = "Drag and rank outcomes here..."
          )  # orderInput.dest
  		  )  # box.outcomes-input
  		),  # patient-tab
  	## Time Allocation Tab
  		tabItem(tabName = "time-tab",
        fluidRow(
          box(title = "Allocate New Time Schedule", width = 12, status = "info",
            p("compositions_core app goes here")
          )  # box.time-input
  		  )  #fluidRow
  		),	# patient-tab
    ## Reallocation Results Tab
    	tabItem(tabName = "result-tab",
    		fluidRow(
    		  box(title = "Specific Outcome Changes", status = "warning",
    		    p("placeholder"),
    		    p("Depression: +5%"),
    		    p("Coolness: +10%"),
    		    p("Wellbeing: -20%")
    		  ),  # box.iresults
    		  box(title = "Overall Outcome Change", status = "success",
    		    p("placeholder"),
    		    p("Overall Change: -5%")
    		  )  # box.results
    		)  # fluidRow
    	)  # result-tab
    )  # tabItems
  )  # dashboardBody

# UI end
  dashboardPage(header, sidebar, body)