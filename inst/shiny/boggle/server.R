library("ggplot2")
library("magrittr")
library("reshape2")
library("shiny")

m <- 4
n <- 4
dices <- boggler::en_boggle_dices
dict <- boggler::spark_intro_dict
word_min_len <- 3

new_board <- function() {
  board <- boggler::new_board(m, n, dices) %T>% print() %>% melt()
  colnames(board) <- c("row", "col", "letter")
  board$clicked <- FALSE
  board
}

get_word <- function(path, board) {
  cells <-
    apply(path, 1, function(cell) which(colSums(cell == t(board[, 1:2])) == 2))
  res <- NULL
  if (!any(duplicated(cells)) && length(cells) >= word_min_len) {
    curr_word <- board$letter[cells] %>%
      as.character() %>%
      paste(collapse = "") %>%
      tolower()
    if (curr_word %in% dict) {
      res <- c(
        Word = curr_word,
        Path = paste(apply(path, 1, function(cell)
          paste0("(", cell[[1]], ", ", cell[[2]], ")")), collapse = " ~> ")
      )
    } else {
      print(paste0("Invalid word: ", curr_word))
    }
  }
  res
}

shinyServer(function(input, output, session) {
  act_board <- reactiveVal(new_board())

  observeEvent(input$shuffle, {
    act_board(new_board())
    in_path(FALSE)
    act_path(NULL)
  })

  output$board <- renderPlot({
    ggplot(act_board()) +
      geom_text(
        aes(x = col, y = row, label = letter, color = clicked),
        size = 8
      ) +
      theme(
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position = "none"
      ) +
      scale_y_reverse()
  })

  in_path <- reactiveVal(FALSE)
  act_path <- reactiveVal()

  observeEvent(input$board_click, {
    if (in_path()) {
      # new click restarts path
      curr_path <- act_path()
      curr_board <- act_board()
      curr_board$clicked <- FALSE
      act_board(curr_board)
      act_path(NULL)

      # check if word was correct
      new_word <- get_word(curr_path, curr_board)
      if (!is.null(new_word)) {
        print(new_word)
      }
    }
    in_path(!in_path())
  })

  observeEvent(input$board_hover, {
    if (in_path()) {
      evt <- input$board_hover
      new_cell <- rev(round(c(evt$x, evt$y)))
      act_path(unique(rbind(act_path(), new_cell)))
      curr_board <- act_board()
      curr_board$clicked[colSums(t(curr_board[, 1:2]) == new_cell) == 2] <- TRUE
      act_board(curr_board)
    }
  })
})
