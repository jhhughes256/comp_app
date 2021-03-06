fluidPage(
  h2("jQuery Widgets for Shiny"),
  br(),
  h3("What order should I eat my meals?"),
  br(),
  p("Drag choices to make a decision."),
  orderInput("source", "Choices", items = meals, as_source = T, connect = "dest"),
  br(),
  orderInput("dest", "Decision", items = NULL, placeholder = "Drag meals here..."),
  hr(),
  verbatimTextOutput("order"),
  br(),
  p("Drag table elements to order the meals."),
  sortableTableOutput("tbl1"),
  hr(),
  verbatimTextOutput("index"),
  br(),
  h3("What should I eat right now?"),
  p("Use 'ctrl' to select multiple."),
  selectableTableOutput("tbl2", selection_mode = "row"),
  hr(),
  verbatimTextOutput("selected"),
  align = "center"
)