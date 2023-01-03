#' Sound Effect: Move Player
#' @param has_sfx Logical. Should sound effects be used? Defaults to \code{TRUE}.
#' @noRd
.sfx_move <- function(has_sfx) {
  if (has_sfx) {
    sonify::sonify(x = 1, y = 1, duration = 0.001)
  }
}

#' Sound Effect: Bump Edge
#' @param has_sfx Logical. Should sound effects be used? Defaults to \code{TRUE}.
#' @noRd
.sfx_edge <- function(has_sfx) {
  if (has_sfx) {
    sonify::sonify(x = 1, y = 1, duration = 0.01, flim = c(100, 110))
  }
}

#' Sound Effect: Collect Apple
#' @param has_sfx Logical. Should sound effects be used? Defaults to \code{TRUE}.
#' @noRd
.sfx_apple_collect <- function(has_sfx) {
  if (has_sfx) {
    sonify::sonify(x = 0:1, y = c(0, 1), duration = 0.05)
  }
}

#' Sound Effect: Eat Apple
#' @param has_sfx Logical. Should sound effects be used? Defaults to \code{TRUE}.
#' @noRd
.sfx_apple_eat <- function(has_sfx) {
  if (has_sfx) {
    sonify::sonify(x = 0:1, y = c(1, 0), duration = 0.05)
  }
}

#' Sound Effect: Collect Gold
#' @noRd
.sfx_gold <- function(has_sfx) {
  if (has_sfx) {
    sonify::sonify(x = 1, y = 1, duration = 0.05, flim = c(800, 800))
    sonify::sonify(x = 1, y = 1, duration = 0.05, flim = c(1000, 1000))
  }
}

#' Sound Effect: Defeat Enemy
#' @param has_sfx Logical. Should sound effects be used? Defaults to \code{TRUE}.
#' @noRd
.sfx_enemy_defeat <- function(has_sfx) {
  if (has_sfx) {
    sonify::sonify(x = 0:1, y = rep(1, 2), duration = 0.1, flim = c(600, 600))
    sonify::sonify(x = 0:1, y = rep(1, 2), duration = 0.1, flim = c(600, 600))
    sonify::sonify(x = 0:1, y = rep(1, 2), duration = 0.1, flim = c(800, 800))
  }
}

#' Sound Effect: End Game
#' @param has_sfx Logical. Should sound effects be used? Defaults to \code{TRUE}.
#' @noRd
.sfx_end <- function(has_sfx) {
  if (has_sfx) {
    sonify::sonify(x = 0:1, y = rep(1, 2), duration = 0.1, flim = c(600, 600))
    sonify::sonify(x = 0:1, y = rep(1, 2), duration = 0.1, flim = c(600, 600))
    sonify::sonify(x = 0:1, y = rep(1, 2), duration = 0.1, flim = c(400, 400))
  }
}
