
#' Add Objects To A Room
#' @param game_map Matrix. 2D game_map layout.
#' @param object Character. Object to place.
#' @noRd
.add_object <- function(game_map, object = c("@", "$", "E", "a")) {

  if (!inherits(game_map, "matrix")) {
    stop("Argument 'game_map' must be a matrix.")
  }

  object <- match.arg(object)

  empty_tiles <- which(game_map == ".")
  sample_tile <- sample(empty_tiles, 1)  # random placement of objects
  game_map[sample_tile] <- object

  return(game_map)

}

#' #' Generate A Dungeon Map
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
#' @noRd
.make_dungeon <- function(
  iterations = 5,
  n_row = 30,
  n_col = 40,
  n_rooms = 5,
  is_snake = FALSE,
  is_organic = TRUE
) {

  m <- .create_dungeon(n_row, n_col, n_rooms)

  if (is_organic) {
    m <- .connect_dungeon(m, is_snake)
  }

  i <- 0

  while (i < iterations) {
    m <- .grow_dungeon(m)
    i <- i + 1
  }

  if (!is_organic) {
    m <- .connect_dungeon(m, is_snake)
  }

  m <- .add_object(m, "$")
  m <- .add_object(m, "E")
  m <- .add_object(m, "a")
  m <- .add_object(m, "@")

  m

}

#' Generate A Simple Room From Sampled Dimensions
#' @param what Numeric vector. Values that room height and width can be sampled
#'     from.
#' @noRd
.make_room <- function(room_size_limit = 6:10) {

  if (!is.numeric(room_size_limit)) {
    stop("Argument 'room_size_limit' must be a numeric vector.")

  }

  room_x <- sample(room_size_limit, 1)
  room_y <- sample(room_size_limit, 1)
  room_size <- room_x * room_y

  room_1d <- rep(".", room_size)
  room_2d <- matrix(room_1d, nrow = room_x, ncol = room_y)

  room_2d[c(1, nrow(room_2d)), ] <- "#"
  room_2d[, c(1, ncol(room_2d))] <- "#"

  room_2d <- .add_object(room_2d, "$")
  room_2d <- .add_object(room_2d, "E")
  room_2d <- .add_object(room_2d, "a")
  room_2d <- .add_object(room_2d, "@")

  return(room_2d)

}

#' Concatenate And Print A Matrix Of The Game Map
#' @param room Matrix. 2D map layout.
#' @param is_colour Logical. Should the characters in the output be coloured
#'     using \code{\link[crayon]{crayon}} (\code{TRUE}, the default)?
#' @noRd
.cat_map <- function(game_map, is_colour = TRUE) {

  if (!inherits(game_map, "matrix")) {
    stop("Argument 'game_map' must be a matrix.")
  }

  if (is_colour) {

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

#' Record Keypress Input From User
#' @noRd
.accept_keypress <- function() {

  supports_keypress <- keypress::has_keypress_support()

  # Accepted keypresses
  wasd_kps <- c("w", "a", "s", "d")
  udlr_kps <- c("up", "down", "left", "right")
  inv_kps  <- "1"
  exit_kps <- "0"
  is_legal_key <- FALSE

  while (!is_legal_key) {

    if (supports_keypress) {

      kp <- keypress::keypress()

      if (kp %in% wasd_kps) {  # allow wasd even if {keypress} is viable
        kp <- switch(
          kp,
          "w" = "up",
          "s" = "down",
          "a" = "left",
          "d" = "right"
        )
      }

      if (kp %in% c(udlr_kps, inv_kps, exit_kps)) {
        is_legal_key <- TRUE
      }

    }

    if (!supports_keypress) {

      kp <- readline("Input: ")

      if (kp %in% wasd_kps) {
        kp <- switch(
          kp,
          "w" = "up",
          "s" = "down",
          "a" = "left",
          "d" = "right"
        )
      }

      if (kp %in% c(udlr_kps, inv_kps, exit_kps)) {
        is_legal_key <- TRUE
      }

    }

  }

  return(kp)

}

#' Move Player Character And Increment Counters
#' @param room Matrix. 2D room layout.
#' @param kp Character. Outcome of keypress input (i.e. 'up', 'down', 'left',
#'   'right' to move, '1' to eat an apple, '0' to exit).
#' @noRd
.move_player <- function(
  room,
  kp = c("up", "down", "left", "right", "1", "0")
) {

  if (!inherits(room, "matrix")) {
    stop("Argument 'room' must be a matrix.")
  }

  kp <- match.arg(kp)

  player_loc <- which(room == "@")
  room[player_loc] <- "."  # replace old location with floor tile

  room_y_max <- nrow(room)

  if (kp %in% c("up", "down", "left", "right")) {

    if (kp == "up") {
      move_to <- player_loc - 1
    }

    if (kp == "down") {
      move_to <- player_loc + 1
    }

    if (kp == "right") {
      move_to <- player_loc + room_y_max
    }

    if (kp == "left") {
      move_to <- player_loc - room_y_max
    }

    if (room[move_to] != "#") {
      player_loc <- move_to
    }

  }

  room[player_loc] <- "@"  # place at new location

  return(room)

}


.move_enemy <- function(game_map) {

  if (!inherits(game_map, "matrix")) {
    stop("Argument 'game_map' must be a matrix.")
  }

  enemy_loc <- which(game_map == "E")
  game_map[enemy_loc] <- "."

  map_width <- ncol(game_map)

  possible_tiles <- c(
    current_tile = enemy_loc,
    n_tile = enemy_loc - 1,
    s_tile = enemy_loc + 1,
    e_tile = enemy_loc + map_width,
    w_tile = enemy_loc - map_width
  )

  is_floor_tile <- (game_map[possible_tiles] == ".")

  tiles_to_sample <- possible_tiles[is_floor_tile]

  enemy_loc <- sample(tiles_to_sample, 1)

  game_map[enemy_loc] <- "E"

  return(game_map)

}
