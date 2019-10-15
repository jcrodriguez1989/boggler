dices <- c(
  "ETUKNO",
  "EVGTIN",
  "DECAMP",
  "IELRUW",
  "EHIFSE",
  "RECALS",
  "ENTDOS",
  "OFXRIA",
  "NAVEDZ",
  "EIOATA",
  "GLENYU",
  "BMAQJO",
  "TLIBRA",
  "SPULTE",
  "AIMSOR",
  "ENHRIS"
)

#' @export
new_board <- function(m = 4, n = 4, alphabet = letters) {
  matrix(sample(letters, m * n, replace = TRUE), nrow = m)
}
