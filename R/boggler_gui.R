#' boggler GUI.
#'
#' Starts a `shiny` app to play Boggle.
#'
#' @import shiny
#' @import ggplot2
#' @importFrom magrittr '%>%'
#' @importFrom reshape2 melt
#'
#' @export
#'
boggler_gui <- function() {
  app_dir <- system.file("shiny", "boggle", package = "boggler")
  if (app_dir == "") {
    stop(
      "Could not find GUI directory. Try re-installing `boggler`.",
      call. = FALSE
    )
  }
  runApp(app_dir)
}
