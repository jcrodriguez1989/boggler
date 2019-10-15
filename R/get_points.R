#' Calculate Boggle words points.
#'
#' Given the `words`, calculate the total points obtained.
#'
#' @param words A character vector containing all the found words.
#'
#' @export
#'
get_points <- function(words) {
  uniq_words <- unique(words)
  words_len <- nchar(uniq_words)

  points <- rep(1, length(words_len))
  points[words_len == 5] <- 2
  points[words_len == 6] <- 3
  points[words_len == 7] <- 5
  points[words_len >= 8] <- 11

  print(paste0("You got a total score of ", sum(points)))
  data.frame(Word = uniq_words, Points = points)
}
