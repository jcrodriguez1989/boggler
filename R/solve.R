# The BogglePath class is going to contain a possible Boggle board path.
#
# Slots:
#   act_cell      will contain the pair indicating the cell containing the last
#                 included letter.
#   visited_cells will be a two-column matrix, where each row is one visited
#                 cell in the path. The first row will be the first visited
#                 cell.
#   current_word  will be the word formed following the current path.
#
# Note: The validity field is not being set as it would slow down calculations,
#       and BogglePath is not an exported class.
#
BogglePath <- setClass("BogglePath",
  slots = c(
    act_cell = "numeric",
    visited_cells = "matrix",
    current_word = "character"
  )
)

#' Solve a Boggle board.
#'
#' Given a Boggle board, this function will return all words contained in
#' `dict`, which can be formed from the `boggle_board`.
#'
#' @param boggle_board The Boggle board represented as a matrix of letters.
#' @param dict A character vector containing all the valid words.
#' @param word_min_len A numeric indicating the minimum length, in characters,
#'          of a word to count as a valid word.
#'
#' @importFrom methods is new
#'
#' @export
#'
solve <- function(boggle_board, dict = spark_intro_dict, word_min_len = 3) {
  m <- nrow(boggle_board)
  n <- ncol(boggle_board)

  if (m < 1 || n < 1 ||
      !is(as.vector(boggle_board), "character") ||
      !all(nchar(boggle_board) == 1)) {
    stop("Boggle board must be a matrix of letters.")
  }
  boggle_board <- tolower(boggle_board)

  if (length(dict) < 1) {
    stop("The dictionary must have at least one valid word.")
  }
  dict <- tolower(dict)

  # each row is a valid board cell
  cells <- cbind(rep(seq_len(m), each = n), seq_len(n))

  # we will start with one-character paths, and enlarging them one char at a
  # time according to its surrounding (not visited) cells.
  all_paths <- new_paths <- apply(cells, 1, function(act_cell) {
    BogglePath(
      act_cell = act_cell,
      current_word = boggle_board[act_cell[[1]], act_cell[[2]]],
      visited_cells = rbind(act_cell)
    )
  })

  while (length(new_paths) > 0) {
    act_paths <- new_paths # actual paths to enlarge
    new_paths <- c() # new generated paths

    # for each path get all possible enlargements
    new_paths <- unlist(lapply(act_paths, function(act_path) {
      next_paths(act_path, boggle_board)
    }))

    # add these new paths to all possible paths list
    all_paths <- c(all_paths, new_paths)
  }

  # keep only those words that are larger than the minimum length, and that is
  # valid according to the dictionary.
  all_paths <- all_paths[
    sapply(all_paths, function(act_path) {
      nchar(act_path@current_word) >= word_min_len &&
        act_path@current_word %in% dict
    })
  ]

  # pretty-print the results
  res <- do.call(rbind, lapply(all_paths, function(act_path) {
    c(
      act_path@current_word,
      paste(
        apply(act_path@visited_cells, 1, function(act_cell)
          paste0("(", act_cell[[1]], ", ", act_cell[[2]], ")")),
        collapse = " ~> "
      )
    )
  }))

  # return them alphabetically ordered
  if (!is.null(res)) {
    res[order(res[, 1]), ]
  }
}

# Return longer words according to a path.
#
# Given a path and a Boggle board, it returns all possible new paths enlarged by
# one surrounding cell.
#
# Params:
#   path The current BogglePath to enlarge.
#   boggle_board The Boggle board represented as a matrix of letters.
#
next_paths <- function(path, boggle_board) {
  act_pos <- path@act_cell
  vis_cells <- path@visited_cells
  curr_word <- path@current_word
  new_paths <- c()

  # new positions will be the ones surrounding the actual position
  new_poss <- act_pos + rbind(rep(-1:1, each = 3), -1:1)
  unlist(apply(new_poss, 2, function(new_pos) {
    # a new path will be possible if the new position falls into the board, and
    # a previously used die is not used again
    if (
      all(new_pos > c(0, 0)) &&
      new_pos[[1]] <= nrow(boggle_board) &&
      new_pos[[2]] <= ncol(boggle_board) &&
      !any(apply(vis_cells, 1, function(vis_cell) all(new_pos == vis_cell)))) {
      BogglePath(
        act_cell = new_pos,
        # use the previous word, plus the new letter
        current_word = paste0(
          curr_word, boggle_board[new_pos[[1]], new_pos[[2]]]
        ),
        visited_cells = rbind(vis_cells, new_pos)
      )
    }
  }))
}
