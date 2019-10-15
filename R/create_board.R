#' Creates a random Boggle board.
#'
#' Given the `dices`, it creates a new game of Boggle of size `m` * `n`.
#'
#' @param m     Number of rows of the Boggle board.
#' @param n     Number of columns of the Boggle board.
#' @param dices Character vector, where each item must be a 6-letters string.
#'          Each item represents a dice.
#'
#' @include data.R
#'
#' @export
#'
new_board <- function(m = 4, n = 4, dices = boggler::en_boggle_dices) {
  if (any(sapply(dices, nchar) != 6) || length(dices) < 1) {
    stop("Dices must be a vector of 6-letters strings.")
  }

  if (m < 1 || n < 1) {
    stop("Boggle board must be at least 1 * 1.")
  }

  # if we have more slots than dices, then sample with replacement
  w_replace <- m * n > length(dices)
  dices_pos <- sample(dices, m * n, replace = w_replace)
  matrix(sapply(strsplit(dices_pos, split = ""), sample, size = 1), nrow = m)
}
