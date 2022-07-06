#' Sound Effect: Move Player
#' @noRd
.sfx_move <- function() {
  sonify::sonify(x = 1, y = 1, duration = 0.001)
}

#' Sound Effect: Bump Edge
#' @noRd
.sfx_edge <- function() {
  sonify::sonify(x = 1, y = 1, duration = 0.01, flim = c(100, 110))
}

#' Sound Effect: Collect Apple
#' @noRd
.sfx_apple_collect <- function(variables) {
  sonify::sonify(x = 0:1, y = c(0, 1), duration = 0.05)
}

#' Sound Effect: Eat Apple
#' @noRd
.sfx_apple_eat <- function(variables) {
  sonify::sonify(x = 0:1, y = c(1, 0), duration = 0.05)
}

#' Sound Effect: Collect Gold
#' @noRd
.sfx_gold <- function() {
  sonify::sonify(x = 1, y = 1, duration = 0.05, flim = c(800, 800))
  sonify::sonify(x = 1, y = 1, duration = 0.05, flim = c(1000, 1000))
}

#' Sound Effect: End game
#' @noRd
.sfx_end <- function() {
  sonify::sonify(x = 0:1, y = rep(1, 2), duration = 0.1)
  sonify::sonify(x = 0:1, y = rep(1, 2), duration = 0.1)
  sonify::sonify(x = 0:1, y = rep(1, 2), duration = 0.1)
}
