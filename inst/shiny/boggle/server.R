library("ggplot2")
library("magrittr")
library("reshape2")
library("shiny")

m <- 4
n <- 4
dices <- boggler::en_boggle_dices
dict <- boggler::spark_intro_dict
word_min_len <- 3
time <- 3 * 60

new_board <- function() {
  rand_board <- boggler::new_board(m, n, dices)
  board <- rand_board %T>% print() %>% melt()
  colnames(board) <- c("row", "col", "letter")
  board$clicked <- FALSE
  list(board = board, solution = boggler::solve(rand_board, dict, word_min_len))
}

get_word <- function(path, board) {
  res <- NULL
  if (is.null(path)) {
    return(res)
  }

  # check that user didnt stroked from outside the limits
  neighbor_cells <- all(unlist(lapply(seq_len(nrow(path) - 1), function(i)
    abs(path[i, 1] - path[i + 1, 1]) <= 1 &&
      abs(path[i, 2] - path[i + 1, 2]) <= 1)))

  cells <-
    apply(path, 1, function(cell) which(colSums(cell == t(board[, 1:2])) == 2))
  if (!any(duplicated(cells)) && neighbor_cells &&
    length(cells) >= word_min_len) {
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
  # one second timer
  timeout <- reactiveTimer()

  # set starting board
  board <- new_board()
  act_board <- reactiveVal(board$board)
  board_solution <- reactiveVal(board$solution)
  time_left <- reactiveVal(time)
  words_found <- reactiveVal()

  in_path <- reactiveVal(FALSE) # indicates if user is stroking
  act_path <- reactiveVal() # current stroked path

  # start new game
  observeEvent(input$shuffle, {
    board <- new_board()
    act_board(board$board)
    board_solution(board$solution)
    time_left(time)
    words_found(NULL)
    in_path(FALSE)
    act_path(NULL)
  })

  # timer settings
  output$timeout <- renderText(paste0(time_left(), " seconds left."))
  observeEvent(timeout(), {
    time_lft <- time_left()
    if (time_lft > 0) { # while we have time, decrease by one second
      time_left(time_lft - 1)
    } else if (time_lft == 0) { # if no more time, get score
      score <- boggler::get_points(words_found())
      final_score <- ifelse(nrow(score) > 0, sum(score[, 2]), 0)
      sols <- board_solution()
      total_score <- boggler::get_points(sols[, 1])
      total_score <- ifelse(nrow(total_score) > 0, sum(total_score[, 2]), 0)
      showModal(modalDialog(
        title = paste0(
          "Final score: ", final_score, "; of a total of: ", total_score
        ),
        paste0(
          apply(as.matrix(score), 1, paste0, collapse = " ~> "),
          collapse = "; "
        ),
        easyClose = TRUE
      ))

      # fill selectInput with solution words
      poss_words <- ""
      if (!is.null(sols)) {
        poss_words <- sols[, 1]
      }
      updateSelectInput(session, "solutions", choices = poss_words)

      time_left(-1)
    }
  })

  # board rendering
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

  # path stroking events
  observeEvent(input$board_click, {
    curr_path <- act_path()
    curr_board <- act_board()
    if (!in_path()) {
      # we were not stroking, then starts; restarts path
      act_path(NULL)
    } else {
      # finished stroking, so check if stroked word is correct
      curr_board$clicked <- FALSE
      act_board(curr_board)
      new_word <- get_word(curr_path, curr_board)
      if (!is.null(new_word)) {
        words_found(c(words_found(), new_word[[1]]))
        showNotification(paste0("Correct word: ", new_word[[1]]))
      }
    }
    in_path(!in_path())
  })

  observeEvent(input$board_hover, {
    if (in_path()) {
      evt <- input$board_hover
      new_cell <- rev(round(c(evt$x, evt$y)))
      act_path(unique(rbind(act_path(), new_cell))) # add each cell once
      curr_board <- act_board()
      curr_board$clicked[colSums(t(curr_board[, 1:2]) == new_cell) == 2] <- TRUE
      act_board(curr_board)
    }
  })

  # solutions revealing
  observeEvent(input$solutions, {
    sel_sol <- input$solutions
    if (sel_sol != "") {
      sols <- board_solution()
      sol_path <- sample(sols[sols[, 1] == sel_sol, 2], 1)
      sol_path <- strsplit(sol_path, " ~> ")[[1]]
      curr_board <- act_board()
      curr_board$clicked <- FALSE
      curr_board$clicked[
        apply(curr_board, 1, function(cell) paste0("(", cell[[1]], ", ", cell[[2]], ")"))
        %in% sol_path
      ] <- TRUE
      act_board(curr_board)
    }
  })
})
