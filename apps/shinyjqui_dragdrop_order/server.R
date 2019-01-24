# Reactive objects/expressions
  shinyServer(function(input, output, session) {
  # orderOutput
    output$order <- renderPrint({ print(input$dest_order) })
    
  # sortableTableOutput
    output$tbl1 <- renderTable({ df.meals })
    
    output$index <- renderPrint({ print(input$tbl1_row_index) })
    
  # selectableTableOutput
    output$tbl2 <- renderTable({ df.meals })
    
    output$selected <- renderPrint({ print(input$tbl2_selected) })
    
  })  # shinyServer