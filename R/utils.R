
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

#' Concatenate And Print A Room Matrix
#' @param room Matrix. 2D room layout.
#' @noRd
.cat_room <- function(room) {

  if (!inherits(room, "matrix")) {
    stop("Argument 'room' must be a matrix.")
  }

  for (i in 1:nrow(room)) {
    cat(room[i, ], "\n")
  }

}

#' Concatenate And Print A Stats Bar
#' @param turns Numeric. Count of turns taken.
#' @param hp Numeric. Count of HP remaining
#' @param gold Numeric. Count of gold accumulated.
#' @noRd
.cat_stats <- function(turns, hp, gold) {

  stats <- paste("HP:", hp, "| G:", gold, "\n")
  cat(stats)

}

#' Record Keypress Input From User
#' @noRd
.accept_keypress <- function() {

  keypress_support <- keypress::has_keypress_support()

  legal_key <- FALSE

  while(!legal_key) {

    if (keypress_support) {

      kp <- keypress::keypress()

      kp <- switch(
        kp,
        "w" = "up",
        "s" = "down",
        "a" = "left",
        "d" = "right"
      )

      legal_key <- TRUE

    }

    if (!keypress_support) {

      kp <- readline("Move (W, A, S, D): ")

      kp <- switch(
        kp,
        "w" = "up",
        "s" = "down",
        "a" = "left",
        "d" = "right"
      )

      legal_key <- TRUE

    }

  }

  return(kp)

}

#' Move Player Character And Increment Counters
#' @param room Matrix. 2D room layout.
#' @param keypress Character.
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
