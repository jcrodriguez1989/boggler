library("shiny")

shinyUI(fluidPage(
  fluidPage(
    titlePanel("Boggle Game"),
    wellPanel(
      fluidRow(actionButton("shuffle", "Shuffle")),
      fluidRow(plotOutput(
        outputId = "board",
        click = "board_click",
        hover = hoverOpts(id = "board_hover", delayType = "throttle")
      ))
    )
  )
))
