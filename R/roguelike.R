
#' Add Objects To A Room
#' @param object Character. Object to place.
#' @param room Matrix. 2D room layout.
#' @noRd
.add_object <- function(room, object = c("@", "$", "E")) {

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

  room_x <- sample(room_size_limit, 1)
  room_y <- sample(room_size_limit, 1)
  room_size <- room_x * room_y

  room_1d <- rep(".", room_size)

  room_2d <- matrix(room_1d, nrow = room_x, ncol = room_y)

  room_2d[c(1, nrow(room_2d)), ] <- "#"
  room_2d[, c(1, ncol(room_2d))] <- "#"

  room_2d <- .add_object(room_2d, "$")
  room_2d <- .add_object(room_2d, "E")
  room_2d <- .add_object(room_2d, "@")

  return(room_2d)

}

#' Concatenate And Print A Room Matrix
#' @param room Matrix. 2D room layout.
#' @noRd
.cat_room <- function(room) {

  for (i in 1:nrow(room)) {
    cat(room[i, ], "\n")
  }

}

#' Concatenate And Print A Room Matrix
#' @param room Matrix. 2D room layout.
#' @param turns NUmeric. Starting amount of turns.
#' @param gold Numeric. Starting amount of turns
#' @noRd
.move_player <- function(room, turns, gold) {

  stats <- paste("Turns:", turns, "| Gold:", gold, "\n")
  cat(stats)

  player_loc <- which(room == "@")
  room[player_loc] <- "."
  room_y_max <- nrow(room)

  keypress_support <- keypress::has_keypress_support()

  if (keypress_support) {
    cat("Use arrow keys")
    kp <- keypress::keypress()
  }

  if (!keypress_support) {
    kp <- readline("Direction (up, down, left, right): ")
  }

  if (kp == "up") {

    move_to <- player_loc - 1

    if (room[move_to] != "#") {
      player_loc <- move_to
    }

  }

  if (kp == "down") {

    move_to <- player_loc + 1

    if (room[move_to] != "#") {
      player_loc <- move_to
    }

  }

  if (kp == "right") {

    move_to <- player_loc + room_y_max

    if (room[move_to] != "#") {
      player_loc <- move_to
    }

  }

  if (kp == "left") {

    move_to <- player_loc - room_y_max

    if (room[move_to] != "#") {
      player_loc <- move_to
    }

  }

  room[player_loc] <- "@"

  return(room)

}

#' Start A 'r.oguelike' Game
#'
#' Clears the console and starts a game of 'r.oguelike'.
#'
#' @param max_turns Numeric. How many turns? Default \code{Inf}.
#'
#' @details If your terminal supports the 'keypress' package, then you can use
#'   single keypresses as input, otherwise you will have to type words at the
#'   prompt. Use \code{\link[keypress]{has_keypress_support}} to see if
#'   'keypress' is supported.
#'
#' @return Nothing. Clears the console and prints to the console with
#'   \code{cat}.
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

  room <- .make_room()
  .cat_room(room)

  gold <- 0
  turns <- 0

  while (turns < max_turns) {

    gold_loc <- which(room == "$")

    room <- .move_player(room, turns, gold)

    player_loc <- which(room == "@")

    if (length(gold_loc) != 0) {

      if (player_loc == gold_loc) {
        gold <- gold + sample(1:10, 1)
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

  }

}
