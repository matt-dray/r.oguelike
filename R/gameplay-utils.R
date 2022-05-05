
#' Add Objects To A Room
#' @param room Matrix. 2D room layout.
#' @param object Character. Object to place.
#' @noRd
.add_object <- function(room, object = c("@", "$", "E", "a")) {

  if (!inherits(room, "matrix")) {
    stop("Argument 'room' must be a matrix.")
  }

  object <- match.arg(object)

  empty_tiles <- which(room == ".")
  sample_tile <- sample(empty_tiles, 1)
  room[sample_tile] <- object

  return(room)

}

#' Generate A Room From Sampled Dimensions
#' @param what Numeric vector. Values that room height and width can take.
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
#' @param seed Numeric. Seed to reproduce a dungeon.
#' @param colour Logical. Should the characters be coloured using
#'     \code{\link[crayon]{crayon}} (\code{TRUE}, the default)?
#' @noRd
.make_dungeon <- function(
  iterations = 5,
  n_row = 20,
  n_col = 40,
  n_rooms = 4,
  is_snake = FALSE,
  is_organic = TRUE,
  seed = NULL,
  colour = TRUE
) {

  m <- .create_dungeon(n_row, n_col, n_rooms, seed)

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

#' Concatenate And Print A Room Matrix
#' @param room Matrix. 2D room layout.
#' @noRd
.cat_room <- function(room) {

  if (!inherits(room, "matrix")) {
    stop("Argument 'room' must be a matrix.")
  }

  room[which(room == ".")] <- crayon::black(".")
  room[which(room == "#")] <- crayon::red("#")

  room[which(room == "$")] <- crayon::yellow("$")
  room[which(room == "E")] <- crayon::bgMagenta("E")
  room[which(room == "a")] <- crayon::green("a")
  room[which(room == "@")] <- crayon::bgBlue ("@")

  for (i in seq(nrow(room))) {
    cat(room[i, ], "\n")
  }

}

#' Concatenate And Print A Stats Bar
#' @param turns Numeric. Count of turns taken.
#' @param hp Numeric. Count of HP remaining
#' @param gold Numeric. Count of gold accumulated.
#' @param food Numeric. Count of food accumulated.
#' @noRd
.cat_stats <- function(turns, hp, gold, food) {

  stats <- paste("T:", turns, "| HP:", hp, "| G:", gold, "| A:", food)
  message(stats)

}

#' Record Keypress Input From User
#' @noRd
.accept_keypress <- function() {

  keypress_support <- keypress::has_keypress_support()

  wasd_kps <- c("w", "a", "s", "d")
  udlr_kps <- c("up", "down", "left", "right")
  inv_kps  <- "1"

  legal_key <- FALSE

  while (!legal_key) {

    if (keypress_support) {

      kp <- keypress::keypress()

      if (kp %in% wasd_kps) {
        kp <- switch(
          kp,
          "w" = "up",
          "s" = "down",
          "a" = "left",
          "d" = "right"
        )
      }

      if (kp %in% c(udlr_kps, inv_kps)) {
        legal_key <- TRUE
      }

    }

    if (!keypress_support) {

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

      if (kp %in% c(udlr_kps, inv_kps)) {
        legal_key <- TRUE
      }

    }

  }

  return(kp)

}

#' Move Player Character And Increment Counters
#' @param room Matrix. 2D room layout.
#' @param kp Character. Outcome of keypress input (i.e. 'up', 'down', 'left',
#'   'right').
#' @noRd
.move_player <- function(room, kp = c("up", "down", "left", "right")) {

  if (!inherits(room, "matrix")) {
    stop("Argument 'room' must be a matrix.")
  }

  player_loc <- which(room == "@")
  room[player_loc] <- "."

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

  room[player_loc] <- "@"

  return(room)

}
