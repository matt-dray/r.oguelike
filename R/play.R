
#' Play A Roguelike Game
#'
#' Clears the console and starts a game of 'r.oguelike' by printing a map with
#' an inventory and status message. The user inputs a keypress to move the
#' character and explore the map, fighting enemies and collecting objects.
#'
#' @param max_turns Numeric. How many turns? Default is \code{Inf}(inite).
#' @param iterations Numeric. How many times to 'grow' iteratively the dungeon
#'     rooms, where tiles adjacent to current floor tiles (\code{.}) have a
#'     random chance of becoming floor tiles themselves with each iteration.
#' @param n_row Numeric. Number of row tiles in the dungeon, i.e. its height.
#' @param n_col Numeric. Number of column tiles in the dungeon, i.e. its width.
#' @param n_rooms Numeric. Number of rooms to place randomly on the map as
#'     starting points for iterative growth.
#' @param is_snake Logical. Should the room start points be connected randomly
#'     (\code{FALSE}, the default) or from left to right across the room matrix
#'     (\code{TRUE})? See details.
#' @param is_organic Logical. Join the room start points with corridors before
#'     iterative growth steps (\code{TRUE}, the default), or after
#'     (\code{FALSE})? See details.
#' @param is_colour Logical. Should the characters in the output be coloured
#'     using \code{\link[crayon]{crayon}} (\code{TRUE}, the default)?
#'
#' @details
#'   Use the WASD keys to move up, left, down and right. Use the '1' key to eat
#'   an apple from your inventory. Use the '0' to quit the game. If your
#'   terminal supports the 'keypress' package, then you can use a single
#'   keypress as input (e.g. the up arrow key), otherwise you will have to type
#'   at the prompt and then press 'Enter'.Use
#'   \code{\link[keypress]{has_keypress_support}} to see if 'keypress' is
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
#' @return Nothing. Clears the console and prints to it with
#'     \code{\link[base]{cat}}.
#' @export
#'
#' @examples \dontrun{start_game()}
start_game <- function(
    max_turns = Inf,
    iterations = 5,
    n_row = 30,
    n_col = 40,
    n_rooms = 5,
    is_snake = FALSE,
    is_organic = TRUE,
    is_colour = TRUE
) {

  # Trap input errorw ----

  if (!inherits(max_turns, "numeric")) {
    "Argument 'max_turns' must be a single numeric value.\n"
  }

  # Check for {keypress} support ----

  supports_keypress <- keypress::has_keypress_support()
  is_rstudio <- Sys.getenv("RSTUDIO") == "1"

  game_map <- .make_dungeon(
    iterations, n_row, n_col, n_rooms, is_snake, is_organic
  )

  if (supports_keypress) {
    status_msg <- "Press arrow keys to move, 1 to eat apple, 0 to exit"
  }

  if (is_rstudio) {
    status_msg <-
      "Press W, A, S or D then Enter to move, 1 to eat apple, 0 to exit"
  }

  # Initiate stats ----

  turns  <- max_turns
  hp     <- 10
  max_hp <- 10
  atk    <- 1
  gold   <- 0
  food   <- 0
  enemy_hp  <- sample(3:5, 1)
  enemy_atk <- 1

  # Begin loop ----

  is_alive <- TRUE

  while (is_alive) {

    # Wipe the screen ----

    if (supports_keypress) {
      system2("clear")
    }

    if (is_rstudio) {
      cat("\014")
    }

    # Print user interface ----

    .cat_map(game_map, is_colour)
    .cat_stats(turns, hp, gold, food)
    message(status_msg)

    # Identify location of objects ----

    gold_loc  <- which(game_map == "$")
    food_loc  <- which(game_map == "a")
    enemy_loc <- which(game_map == "E")

    # Fetch user input ----

    kp <- .accept_keypress()

    # Respond to menu options ----

    ## Quit ----

    if (kp == "0") {

      answer <- readline("Quit? Type 'y' or 'n': ")

      if (substr(tolower(answer), 1, 1) == "y") {
        message("Game over! Thank you for playing.")
        break
      }

      if (substr(tolower(answer), 1, 1) == "n") {
        next
      }

    }

    ## Eat apple ----

    if (kp == "1") {

      if (food == 0) {
        status_msg <- "You have no apples."
      }

      if (food > 0) {

        if (hp < max_hp) {
          food <- food - 1
          hp <- hp + 1
          status_msg <- "Ate apple (+1 HP)"
          .sfx_apple_eat()
        }

        if (hp == max_hp) {
          status_msg <- "Already max HP. Save it!"
        }

      }

    }

    # Move enemy ----

    enemy_loc <- which(game_map == "E")  # check if enemy is alive

    if (length(enemy_loc) > 0) {  # check for enemy
      dist <- .get_distance_map(game_map)  # calculate distance to player
      game_map <- .move_enemy(game_map, dist)  # move enemy closer to player
      enemy_loc <- which(game_map == "E")
    }

    # Move player ----

    game_map <- .move_player(game_map, kp)

    if (kp != "1") {
      status_msg <- paste("Moved", kp)
    }

    player_loc <- which(game_map == "@")  # matrix index of player

    # Execute player-object interactions ----

    ## Engage enemy ----

    if (length(enemy_loc) != 0) {

      if (player_loc == enemy_loc) {

        is_battle <- TRUE
        start_hp <- hp

        while (is_battle) {

          enemy_hp <- enemy_hp - atk  # player strikes first

          if (enemy_hp == 0) {
            status_msg <- paste0(
              "Enemy defeated! (-", start_hp - hp," HP)"
            )
            is_battle <- FALSE
          }

          if (is_battle) {
            hp <- hp - enemy_atk
            turns <- turns - 1
          }

          if (hp == 0) {
            status_msg <- paste0("You died (0 HP)! Try again.")
            is_battle <- FALSE
            is_alive <- FALSE
            .sfx_end()
          }

        }

      }

    }

    ## Collect gold ----

    if (length(gold_loc) > 0) {

      gold_rand <- sample(1:3, 1)

      if (player_loc == gold_loc) {

        gold <- gold + gold_rand

        status_msg <- paste0("Found gold (+", gold_rand, " $)")

        .sfx_gold()

      }

    }

    ## Collect apple ----

    if (length(food_loc) > 0) {

      if (player_loc == food_loc) {

        food <- food + 1

        status_msg <- "Collected apple (+1 a)"

        .sfx_apple_collect()

      }

    }

    # Handle turn count ----

    turns <- turns - 1

    if (turns == 0) {
      message("You died (max turns)! Try again.")
      .sfx_end()
      is_alive <- FALSE
    }

  }

}
