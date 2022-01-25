
#' Start A 'r.oguelike' Game
#'
#' Clears the console and starts a game of 'r.oguelike'.
#'
#' @param max_turns Numeric. How many turns? Default \code{Inf}.
#'
#' @details If your terminal supports the 'keypress' package, then you can use
#'   a single keypresses as input (e.g. the up arrow key), otherwise you will
#'   have to type words at the prompt. Use
#'   \code{\link[keypress]{has_keypress_support}} to see if 'keypress' is
#'   supported.
#'
#'   Symbols are as follows:
#'   \itemize{
#'     \item{\code{.}} {tile}
#'     \item{\code{#}} {wall}
#'     \item{\code{@}} {player}
#'     \item{\code{$}} {gold (+1 to +3 G)}
#'     \item{\code{E}} {enemy (-1 HP)}
#'     \item{\code{a}} {food (+1 HP)}
#'   }
#'
#' @return Nothing. Clears the console and prints to it with \code{cat}.
#' @export
#'
#' @examples \dontrun{start_game()}
start_game <- function(max_turns = Inf) {

  if (!inherits(max_turns, "numeric")) {
    "Argument 'max_turns' must be a single numeric value.\n"
  }

  keypress_support <- keypress::has_keypress_support()
  in_rstudio <- Sys.getenv("RSTUDIO") == "1"

  if (keypress_support) {
    system2("clear")
  }

  if (in_rstudio) {
    cat("\014")
  }

  turns <- 0
  gold  <- 0
  hp    <- 10

  room <- .make_room()
  .cat_room(room)
  .cat_stats(turns, hp, gold)
  cat("Start game")

  while (turns < max_turns) {

    gold_loc  <- which(room == "$")
    enemy_loc <- which(room == "E")
    food_loc  <- which(room == "a")

    kp <- .accept_keypress()
    room <- .move_player(room, kp)

    msg <- paste("Moved", kp)

    player_loc <- which(room == "@")

    if (length(gold_loc) != 0) {

      gold_rand <- sample(1:3, 1)

      if (player_loc == gold_loc) {

        gold <- gold + gold_rand

        msg <- paste0("Found gold (+", gold_rand, " G)")

      }

    }

    if (length(enemy_loc) != 0) {

      if (player_loc == enemy_loc) {

        hp <- hp - 1

        msg <- "Struck by enemy (-1 HP)"

      }

    }

    if (length(food_loc) != 0) {

      if (player_loc == food_loc) {

        hp <- hp + 1

        if (hp > 10) {
          hp <- 10
        }

        msg <- "Ate apple (+1 HP)"

      }

    }

    turns <- turns + 1

    if (keypress_support) {
      system2("clear")
    }

    if (in_rstudio) {
      cat("\014")
    }

    .cat_room(room)
    .cat_stats(turns, hp, gold)
    cat(msg)

  }

}
