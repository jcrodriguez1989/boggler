library("ggplot2")
library("magrittr")
library("reshape2")
library("shiny")

shinyServer(function(input, output, session) {
  act_board <- reactiveVal(boggler::new_board())

  observeEvent(input$shuffle, {
    act_board(boggler::new_board())
  })

  output$board <- renderPlot({
    melted_board <- act_board() %>% melt()
    ggplot(melted_board) +
      geom_text(aes(x = Var1, y = Var2, label = value), size = 8) +
      theme(axis.title.x = element_blank(),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank())
  })
})
