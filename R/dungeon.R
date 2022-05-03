#' Generate A Dungeon Map
#'
#' Procedurally generate a tile-based ASCII-character dungeon map. Creates a
#' tile-based map of user-specified size; places randomly a user-specified
#' number of rooms; connects them with a continuous corridor; and iteratively
#' expands the interior space by sampling from adjacent tiles.
#'
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
#'
#' @details
#'
#' \itemize{
#'     \item You'll have to experiment to find the 'best' argument values for
#'         your needs. Typically, a larger dungeon should have a higher
#'         \code{n_rooms} value and can be grown through more \code{iterations}.
#'         Use \code{is_snake} and \code{is_organic} to play with dungeon
#'         appearance and connectedness.
#'     \item For argument \code{is_snake}, \code{TRUE} will create a single
#'         continuous, winding cavern from left to right, while \code{FALSE}
#'         will create a more maze-like cavern.
#'     \item For argument \code{is_organic}, \code{TRUE} will generally create
#'         what looks like a natural cavern, since the room start points and
#'         corridors are subject to iterative growth. When \code{FALSE} and
#'         \code{is_snake} is \code{FALSE}, the dungeon's caverns are more
#'         square, or more 'artificial' looking. When \code{FALSE} and
#'         \code{is_snake} is \code{TRUE}, the result is more likely to be a
#'         series of discrete roundish rooms connected by a narrow (one
#'         tile-width) corridor.
#' }
#'
#' @return A matrix, invisibly. Output via \code{\link[base]{cat}} to the
#'     console.
#' @export
#'
#' @examples \dontrun{
#'
#' # A 'natural' cavern with default arguments
#' generate_dungeon(seed = 23456)
#'
#' # Rooms connected sequentially by narrow corridors
#' generate_dungeon(
#'   iterations = 8,      # iterate room growth 8 times
#'   n_rooms = 4,         # randomly place 4 room tiles to start
#'   is_snake = TRUE,     # connect rooms from left- to right-most
#'   is_organic = FALSE,  # add single tile-width corridors after growth
#'   seed = 2
#' )
#' }
generate_dungeon <- function(
  iterations = 5,
  n_row = 30,
  n_col = 50,
  n_rooms = 5,
  is_snake = FALSE,
  is_organic = TRUE,
  seed = NULL,
  colour = TRUE
) {

  if (!is.numeric(iterations) & iterations < 1) {
    stop("Argument iter must be a positive numeric value.")
  }

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

  .draw_dungeon(m, colour)

  invisible(m)

}

