#' Move Player Character And Increment Counters
#' @param room Matrix. 2D room layout.
#' @param kp Character. Outcome of keypress input (i.e. 'up', 'down', 'left',
#'   'right' to move, '1' to eat an apple, '0' to exit).
#' @param player_loc Numeric. Matrix index of the tile occupied by the player
#'     character.
#' @param has_sfx Logical. Should sound effects be used? Defaults to
#'     \code{TRUE}.
#' @noRd
.move_player <- function(
    room,
    kp = c("up", "down", "left", "right", "1", "0"),
    player_loc,
    has_sfx
) {

  if (!inherits(room, "matrix")) {
    stop("Argument 'room' must be a matrix.")
  }

  kp <- match.arg(kp)

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
      .sfx_move(has_sfx)
    } else {
      .sfx_edge(has_sfx)
    }

  }

  room[player_loc] <- "@"  # place at new location

  return(room)

}

#' Move The Enemy To The Player
#' @param room Matrix. 2D room layout.
#' @param dist Matrix. Tile distance to player.
#' @param enemy_loc Numeric. Matrix index of the tile occupied by the enemy
#'     character.
.move_enemy <- function(room, dist, enemy_loc) {

  n_rows <- nrow(room)

  ind <- c(
    n = enemy_loc - 1,
    s = enemy_loc + 1,
    e = enemy_loc + n_rows,
    w = enemy_loc - n_rows
  )

  tiles <- c(
    n = room[ind["n"]],
    s = room[ind["s"]],
    e = room[ind["e"]],
    w = room[ind["w"]]
  )

  dist <- c(
    n = if (tiles["n"] %in% c(".", "@")) dist[ind["n"]],
    s = if (tiles["s"] %in% c(".", "@")) dist[ind["s"]],
    e = if (tiles["e"] %in% c(".", "@")) dist[ind["e"]],
    w = if (tiles["w"] %in% c(".", "@")) dist[ind["w"]]
  )

  direction <- sample(names(dist[dist == min(dist)]), 1)
  enemy_loc_new <- ind[names(ind) == direction]

  room[enemy_loc] <- "."
  room[enemy_loc_new] <- "E"

  room

}
