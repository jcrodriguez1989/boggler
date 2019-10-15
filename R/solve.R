BogglePath <- setClass("BogglePath",
         slots = c(
           act_cell = "numeric",      # current cell position
           visited_cells = "matrix",  # visited cells, fst row is fst visited cell
           current_word = "character"
         ),
         prototype = list(
           act_cell = c(0, 0),
           visited_cells = c(),
           current_word = ""
         )
)

solve <- function(boggle_board, dict = spark_intro_dict, word_min_len = 3) {
  m <- nrow(boggle_board)
  n <- ncol(boggle_board)
  cells <- cbind(rep(seq_len(m), each = n), seq_len(n))
  new_paths <- apply(cells, 1, function(act_cell) {
    BogglePath(
      act_cell = act_cell,
      current_word = boggle_board[act_cell[[1]], act_cell[[2]]],
      visited_cells = rbind(act_cell)
    )
  })
  all_paths <- new_paths

  while (length(new_paths) > 0) {
    act_paths <- new_paths
    new_paths <- c()
    for (act_path in act_paths) {
      gen_paths <- next_paths(act_path, boggle_board)
      new_paths <- c(new_paths, gen_paths)
    }
    all_paths <- c(all_paths, new_paths)
  }

  # summary(sapply(all_paths, function(act_path) nchar(act_path@current_word)))

  browser()
  all_paths <- all_paths[
    sapply(all_paths, function(act_path) {
      nchar(act_path@current_word) >= word_min_len &&
        act_path@current_word %in% dict
    })
  ]
  all_paths
}

next_paths <- function(act_path, boggle_board) {
  act_pos <- act_path@act_cell
  vis_cells <- act_path@visited_cells
  curr_word <- act_path@current_word
  new_paths <- c()

  for (i in -1:1) {
    for (j in -1:1) {
      new_pos <- act_pos + c(i, j)
      if (
        all(new_pos > 0) &&
        new_pos[[1]] <= nrow(boggle_board) &&
        new_pos[[2]] <= ncol(boggle_board) &&
        !any(apply(vis_cells, 1, function(vis_cell) all(new_pos == vis_cell)))) {
        new_path <- BogglePath(
          act_cell = new_pos,
          current_word = paste0(
            curr_word, boggle_board[new_pos[[1]], new_pos[[2]]]),
          visited_cells = rbind(vis_cells, new_pos)
        )
        new_paths <- c(new_paths, new_path)
      }
    }
  }
  new_paths
}
