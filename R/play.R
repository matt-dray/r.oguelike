
#' Play A Roguelike Game
#'
#' Clears the console and starts a game of 'r.oguelike' by printing a map with
#' an inventory and status message. The user inputs a keypress to move the
#' character and explore the map, fighting enemies and collecting objects. This
#' is a toy; a proof-of-concept.
#'
#' @param max_turns Integer. How many turns? Default is \code{Inf}(inite).
#' @param n_row Integer Number of row tiles in the dungeon, i.e. its height.
#' @param n_col Integer. Number of column tiles in the dungeon, i.e. its width.
#' @param n_rooms Integer Number of rooms to place randomly on the map as
#'     starting points for iterative growth.
#' @param iterations Integer. How many times to 'grow' iteratively the dungeon
#'     rooms, where tiles adjacent to current floor tiles (\code{.}) have a
#'     random chance of becoming floor tiles themselves with each iteration.
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
#'  When \code{TRUE}, \code{is_snake} will tend to create one continuous cavern;
#'  \code{is_organic} will tend to create more 'natural' looking caves.
#'
#'  Arguments that take integer values are coerced to integer if provided as
#'  numeric values.
#'
#' @return Nothing. Clears the console and prints to it with
#'     \code{\link[base]{cat}}.
#' @export
#'
#' @examples
#' \dontrun{start_game()}
start_game <- function(
    max_turns  = Inf,
    n_row      = 20L,
    n_col      = 30L,
    n_rooms    = 5L,
    iterations = 4L,
    is_snake   = FALSE,
    is_organic = TRUE,
    is_colour  = TRUE
) {

  # Checks ----

  if (
    !is.numeric(max_turns) |
    !is.numeric(n_row) |
    !is.numeric(n_col) |
    !is.numeric(n_rooms) |
    !is.numeric(iterations)
  ) {
    stop(
      "Arguments 'max_turns', 'iterations', 'n_row', 'n_col' and 'n_rooms' must be numeric.",
      call. = FALSE
    )
  }

  if (n_row < 10 | n_col < 10) {
    stop("Arguments 'n_row' and 'n_col' must be 10 or greater.", call. = FALSE)
  }

  if (!is.logical(is_snake) | !is.logical(is_organic) | !is.logical(is_colour)) {
    stop(
      "Arguments 'is_snake', 'is_organic' and 'is_colour' must be logical.",
      call. = FALSE
    )
  }

  if (max_turns != Inf) max_turns <- as.integer(max_turns)
  n_row      <- as.integer(n_row)
  n_col      <- as.integer(n_col)
  n_rooms    <- as.integer(n_rooms)
  iterations <- as.integer(iterations)

  # Game setup ----

  game_map <- .make_dungeon(
    iterations, n_row, n_col, n_rooms, is_snake, is_organic
  )

  supports_keypress <- keypress::has_keypress_support()
  is_rstudio <- Sys.getenv("RSTUDIO") == "1"

  if (supports_keypress) {
    status_msg <- "Press arrow keys to move, 1 to eat apple, 0 to exit"
  }

  if (is_rstudio) {
    status_msg <-
      "Press W, A, S or D then Enter to move, 1 to eat apple, 0 to exit"
  }

  # Initiate constants ----

  turns     <- max_turns
  hp        <- 10
  max_hp    <- 10
  atk       <- 1
  gold      <- 0
  gold_rand <- sample(1:3, 1)
  food      <- 0
  enemy_hp  <- sample(3:5, 1)
  enemy_atk <- 1

  # Enter game loop ----

  is_alive <- TRUE

  while (is_alive) {

    # Refresh interface ----

    if (supports_keypress) system2("clear")
    if (is_rstudio) cat("\014")
    .cat_map(game_map, is_colour)
    .cat_stats(turns, hp, gold, food)
    message(status_msg)

    # Locate objects ----

    gold_loc   <- which(game_map == "$")
    food_loc   <- which(game_map == "a")
    enemy_loc  <- which(game_map == "E")
    player_loc <- which(game_map == "@")

    # Get user input ----

    kp <- .accept_keypress()


    # Menu items ----

    if (kp == "0") {  # quit

      answer <- readline("Quit? Type 'y' or 'n': ")

      if (substr(tolower(answer), 1, 1) == "y") {
        message("Game over! Thank you for playing.")
        break
      }

      if (substr(tolower(answer), 1, 1) == "n") {
        next
      }

    }

    if (kp == "1") {  # eat apple

      if (food == 0) {
        status_msg <- "You have no apples."
      }

      if (food > 0) {

        if (hp < max_hp) {
          food <- food - 1
          hp <- hp + 1
          status_msg <- "Ate apple (+1 HP)"
        }

        if (hp == max_hp) {
          status_msg <- "Already max HP. Save it!"
        }

      }

    }

    # Player actions ----

    game_map <- .move_player(game_map, kp, player_loc)
    player_loc <- which(game_map == "@")

    if (kp %in% c("up", "down", "left", "right")) {
      status_msg <- paste("Moved", kp)
    }

    if (length(gold_loc) > 0 && player_loc == gold_loc) {
      gold <- gold + gold_rand
      status_msg <- paste0("Found gold (+", gold_rand, " $)")
    }

    if (length(food_loc) > 0 && player_loc == food_loc) {
      food <- food + 1
      status_msg <- "Collected apple (+1 a)"
    }

    if (length(enemy_loc) != 0 && player_loc == enemy_loc) {

      is_battle <- TRUE
      start_hp <- hp

      while (is_battle) {

        enemy_hp <- enemy_hp - atk

        if (enemy_hp == 0) {
          status_msg <- paste0("Enemy defeated! (-", start_hp - hp," HP)")
          enemy_loc <- NULL
          is_battle <- FALSE
        }

        if (is_battle) {
          hp <- hp - enemy_atk
          turns <- turns - 1
        }

        if (hp == 0) {
          status_msg <- paste0("You died (0 HP)! Try again.")
          game_map[enemy_loc] <- "@"  # overwrite position with enemy symbol
          is_battle <- FALSE
          is_alive <- FALSE
        }

      }

    }

    # Enemy actions ----

    if (length(enemy_loc) > 0) {  # check for enemy, may have been defeated

      dist <- .get_distance_map(game_map)  # calculate distance to player
      game_map <- .move_enemy(game_map, dist, enemy_loc)  # move enemy closer to player
      enemy_loc <- which(game_map == "E")

      if (player_loc == enemy_loc) {

        is_battle <- TRUE
        start_hp <- hp

        while (is_battle) {

          enemy_hp <- enemy_hp - atk

          if (enemy_hp == 0) {
            status_msg <- paste0("Enemy defeated! (-", start_hp - hp," HP)")
            game_map[enemy_loc] <- "@"  # overwrite position with player symbol
            is_battle <- FALSE
          }

          if (is_battle) {
            hp    <- hp - enemy_atk
            turns <- turns - 1
          }

          if (hp == 0) {
            status_msg <- paste0("You died (0 HP)! Try again.")
            is_battle <- FALSE
            is_alive <- FALSE
          }

        }

      }

    }

    # Reduce turn count ----

    turns <- turns - 1

    if (turns == 0) {
      message("You died (max turns)! Try again.")
      is_alive <- FALSE
    }

  }

}
