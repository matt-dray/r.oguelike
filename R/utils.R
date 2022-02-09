#' Print GUI
#' @param room Matrix. 2D room layout.
#' @noRd
.printout <- function(room) {
  cat("\014")
  print(room)
  message("HP:", room$player$hp)
}

#' Print GUI
#' @param room Matrix. 2D room layout.
#' @param kp Character. Outcome of keypress input
#' @noRd
.move <- function(room, kp) {

  room_y_max <- nrow(room$matrix)

  if (kp == "w") {
    move_to <- room$player_loc - 1
  }

  if (kp == "s") {
    move_to <- room$player_loc + 1
  }

  if (kp == "a") {
    move_to <- room$player_loc - room_y_max
  }

  if (kp == "d") {
    move_to <- room$player_loc + room_y_max
  }

  if (room$matrix[move_to] != room$wall) {
    room$matrix[room$player_loc] <- room$tile
    room$player_loc <- move_to
    room$matrix[move_to] <- room$player$sprite
  }

}
