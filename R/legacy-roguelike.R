
#' Play A 'r.oguelike' Game
#'
#' Clears the console and starts a game of 'r.oguelike'. The user inputs a
#' keypress to move the character and interact with the game.
#'
#' @param max_turns Numeric. How many turns? Default is 25.
#'
#' @details
#'   Use the WASD keys to move up, left, down and right. Use the '1' key to eat
#'   an apple from your inventory. If your terminal supports the 'keypress'
#'   package, then you can use a single keypress as input (e.g. the up arrow
#'   key), otherwise you will have to type at the prompt and then press 'Enter'.
#'   Use \code{\link[keypress]{has_keypress_support}} to see if 'keypress' is
#'   supported.
#'
#'   Symbols used in the game are as follows:
#'   \itemize{
#'     \item{\code{.}} {floor tile}
#'     \item{\code{#}} {wall}
#'     \item{\code{@}} {player (10 HP max, -1 HP attack damage)}
#'     \item{\code{$}} {gold (+1 to +3 G)}
#'     \item{\code{E}} {enemy (3 HP max, -1 HP attack damage)}
#'     \item{\code{a}} {apple (+1 HP)}
#'   }
#'
#' @return Nothing. Clears the console and prints to it with \code{cat}.
#' @export
#'
#' @examples \dontrun{start_game()}
start_game <- function(max_turns = 25) {

  if (!inherits(max_turns, "numeric")) {
    "Argument 'max_turns' must be a single numeric value.\n"
  }

  keypress_support <- keypress::has_keypress_support()
  in_rstudio <- Sys.getenv("RSTUDIO") == "1"

  room <- .make_room()

  turns  <- max_turns
  hp     <- 10
  max_hp <- 10
  gold   <- 0
  food   <- 0

  enemy_hp  <- sample(3:5, 1)
  enemy_atk <- 1

  msg <- "Press key to start"

  is_alive <- TRUE

  while (is_alive) {

    if (keypress_support) {
      system2("clear")
    }

    if (in_rstudio) {
      cat("\014")
    }

    .cat_room(room)
    .cat_stats(turns, hp, gold, food)
    message(msg)

    gold_loc  <- which(room == "$")
    enemy_loc <- which(room == "E")
    food_loc  <- which(room == "a")

    kp <- .accept_keypress()

    if (kp == "1") {

      if (food == 0) {
        msg <- "You have no apples."
      }

      if (food > 0) {

        if (hp < max_hp) {
          food <- food - 1
          hp <- hp + 1
          msg <- "Ate apple (+1 HP)"
        }

        if (hp == max_hp) {
          msg <- "Already max HP. Save it!"
        }

      }

    }

    room <- .move_player(room, kp)

    if (kp != "1") {
      msg <- paste("Moved", kp)
    }

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

        is_battle <- TRUE
        start_hp <- hp

        while (is_battle) {

          enemy_hp <- enemy_hp - 1

          if (enemy_hp == 0) {
            msg <- paste0("You win! (-", start_hp - hp," HP)")
            is_battle <- FALSE
          }

          hp <- hp - enemy_atk
          turns <- turns - 1

          if (hp == 0) {
            msg <- paste0("You died (0 HP)! Try again.")
            is_battle <- FALSE
            is_alive <- FALSE
          }

        }

      }

    }

    if (length(food_loc) != 0) {

      if (player_loc == food_loc) {

        food <- food + 1

        msg <- "Collected apple (+1 A)"

      }

    }

    turns <- turns - 1

    if (turns == 0) {
      message("You died (max turns)! Try again!")
      is_alive <- FALSE
    }

  }

}
