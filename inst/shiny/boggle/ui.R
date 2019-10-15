library("shiny")

shinyUI(fluidPage(
  fluidPage(
    titlePanel("Boggle Game"),
    wellPanel(
      fluidRow(actionButton("shuffle", "Shuffle")),
      fluidRow(plotOutput(outputId = "board"))
    )
  )
))
