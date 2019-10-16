library("shiny")

shinyUI(fluidPage(
  fluidPage(
    titlePanel("Boggle Game"),
    wellPanel(
      fluidRow(
        actionButton("shuffle", "Shuffle"),
        textOutput("timeout")
      ),
      fluidRow(plotOutput(
        outputId = "board",
        click = "board_click",
        hover = hoverOpts(id = "board_hover", delayType = "throttle")
      )),
      fluidRow(conditionalPanel(
        "output.timeout == '-1 seconds left.'",
        selectInput("solutions", label = "Present words: ", choices = NULL)
      ))
    )
  )
))
