#' Concatenate And Print A Matrix Of The Game Map
#' @param room Matrix. 2D map layout.
#' @param has_colour Logical. Should the characters in the output be coloured
#'     using \code{\link[crayon]{crayon}} (\code{TRUE}, the default)?
#' @noRd
.cat_map <- function(game_map, has_colour) {

  if (!inherits(game_map, "matrix")) {
    stop("Argument 'game_map' must be a matrix.")
  }

  if (has_colour) {

    game_map[which(game_map == ".")] <- crayon::black(".")
    game_map[which(game_map == "#")] <- crayon::red("#")
    game_map[which(game_map == "$")] <- crayon::bgYellow("$")
    game_map[which(game_map == "E")] <- crayon::bgMagenta("E")
    game_map[which(game_map == "a")] <- crayon::bgGreen("a")
    game_map[which(game_map == "@")] <- crayon::bgCyan("@")

  }

  for (i in seq(nrow(game_map))) {
    cat(game_map[i, ], "\n")
  }

}

#' Concatenate And Print A Stats Bar
#' @param turns Numeric. Count of turns taken.
#' @param hp Numeric. Count of HP remaining
#' @param gold Numeric. Count of gold accumulated.
#' @param food Numeric. Count of food accumulated.
#' @noRd
.cat_stats <- function(turns, hp, gold, food) {

  if (
    !is.numeric(turns) | !is.numeric(hp) | !is.numeric(gold) | !is.numeric(food)
  ) {
    stop("Arguments 'turns', 'hp', 'gold' and 'food' must be numeric.")
  }

  stats <- paste("T:", turns, "| HP:", hp, "| $:", gold, "| a:", food)
  message(stats)

}
