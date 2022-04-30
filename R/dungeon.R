#' Generate A Dungeon Map
#'
#' Generate a tile-based ASCII character dungeon map. Lays down 'start points'
#' and connecting corridors from which rooms can be grown.
#'
#' @param iterations Numeric.
#' @param n_row Numeric. Number of row tiles in the dungeon, i.e. its height.
#' @param n_col Numeric. Number of column tiles in the dungeon, i.e. its width.
#' @param n_points Numeric. Number of start points to 'grow' rooms from.
#' @param snake Logical. Should the start points be connected in matrix index
#'   order (\code{TRUE}), or randomly (\code{FALSE})?
#' @param corridor_first Logical. Join start points with corridors before
#'     growing rooms (\code{TRUE}), or the other way round (\code{FALSE})?
#' @param seed Numeric. Seed to reproduce a dungeon.
#' @param colour Logical. Should the characters be coloured using \pkg{crayon}
#'   (\code{TRUE})?
#'
#' @details You will have to experiment to find the 'best' argument values for
#'     your needs. Typically, a larger dungeon should have more
#'     \code{n_points} and can be grown through more \code{iterations}, and vice
#'     versa. Using \code{snake} will generally create a single winding cavern
#'     with a more obvious 'start' and 'end'.
#'
#' @return A matrix, invisibly. Output via \code{\link[base]{cat}} to the
#'     console.
#' @export
#'
#' @examples \dontrun{generate_dungeon(10, 20, 30, 3)}
generate_dungeon <- function(
  iterations = 5,
  n_row = 30,
  n_col = 50,
  n_points = 4,
  snake = FALSE,
  corridor_first = TRUE,
  seed = NULL,
  colour = TRUE
) {

  if (!is.numeric(iterations) & iterations < 1) {
    stop("Argument iter must be a positive numeric value.")
  }

  m <- .create_dungeon(n_row, n_col, n_points, seed)

  if (corridor_first) {
    m <- .connect_dungeon(m, snake)
  }

  i <- 0

  while (i < iterations) {
    m <- .grow_dungeon(m)
    i <- i + 1
  }

  if (!corridor_first) {
    m <- .connect_dungeon(m, snake)
  }

  .draw_dungeon(m, colour)

  invisible(m)

}

