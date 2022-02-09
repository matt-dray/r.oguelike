
#' Start A 'r.oguelike' Game
#'
#' Clears the console and starts a game of 'r.oguelike'. The user inputs a
#' keypress to move the character and interact with the game.
#'
#' @details Press W, A, S or D at the prompt and hit enter to move.
#'
#' @return Nothing. Clears the console and prints to it.
#' @export
#'
#' @examples \dontrun{begin_game()}
begin_game <- function() {

  room <- Room$new()

  .printout(room)

  is_alive <- TRUE

  while (is_alive) {

    kp <- readline("Input (wasd): ")

    .move(room, kp)

    .printout(room)

  }

}
