#' Create Dungeon And Place Start Points
#' @param n_row Numeric. Number of row tiles in the dungeon, i.e. its height.
#' @param n_col Numeric. Number of column tiles in the dungeon, i.e. its width.
#' @param n_rooms Numeric. Number of start points to 'grow' rooms from.
#' @param seed Numeric. Seed to reproduce a dungeon.
#' @noRd
.create_dungeon <- function(n_row, n_col, n_rooms, seed = NULL) {

  if (!is.numeric(n_row) | n_row <= 0 | !is.numeric(n_col) | n_col <= 0) {
    stop("Argument n_points must be numeric (zero or greater).")
  }

  if (!is.numeric(n_rooms) & n_rooms < 1) {
    stop("Argument n_points must be a positive numeric value.")
  }

  if (!is.null(seed) & !is.numeric(seed)) {
    stop("Argument seed must be numeric.")
  }

  if (!is.null(seed)) {
    set.seed(seed)
  } else {
    seed <- as.numeric(Sys.time())
    set.seed(seed)
  }

  m <- matrix("#", n_row, n_col)

  edge_n <- seq(1, length(m), n_row)
  edge_s <- seq(n_row, length(m), n_row)
  edge_w <- seq(n_row)
  edge_e <- seq(length(m) - (n_row - 1), length(m), 1)

  m[unique(c(edge_n, edge_s))] <- "-"
  m[unique(c(edge_e, edge_w))] <- "|"

  edge_tiles <- sort(unique(c(edge_n, edge_s, edge_e, edge_w)))

  m_no_edges <- which(!seq(m) %in% edge_tiles)

  chunks_to_sample <- split(
    m_no_edges,
    cut(seq_along(m_no_edges), n_rooms, labels = FALSE)
  )

  room_start_tiles <- unlist(lapply(chunks_to_sample, function(x) sample(x, 1)))

  m[room_start_tiles] <- "."

  m

}

#' Grow A Dungeon's Rooms
#' @param m Matrix. Dungeon matrix output from \code{\link{.create_dungeon}}.
#' @noRd
.grow_dungeon <- function(m) {

  if (!is.matrix(m)) {
    stop("Argument m must be a matrix.")
  }

  room_tiles <- which(m == ".")

  adjacent_tiles <- sort(
    unique(
      c(
        room_tiles - 1,        # tiles to north of room tiles
        room_tiles + 1,        # south
        room_tiles - nrow(m),  # east
        room_tiles + nrow(m)   # west
      )
    )
  )

  adjacent_tiles <-
    adjacent_tiles[adjacent_tiles > 0 & adjacent_tiles <= length(m)]

  map_edges <- sort(
    unique(
      c(
        seq(1, length(m), nrow(m)),           # tiles on the north edge
        seq(nrow(m), length(m), nrow(m)),     # south
        seq(length(m) - nrow(m), length(m)),  # east
        seq(nrow(m))                          # west
      )
    )
  )

  tiles_to_sample <- adjacent_tiles[!adjacent_tiles %in% map_edges]
  n_to_sample <- sample(1:length(tiles_to_sample), 1)
  new_room_tiles <- sample(tiles_to_sample, n_to_sample)

  m[new_room_tiles] <- "."

  m

}

#' Connect Room Start Points
#' @param m Matrix. Dungeon matrix output from \code{\link{.create_dungeon}}.
#' @param is_snake Logical. Should the start points be connected in matrix index
#'   order (\code{TRUE}), or randomly (\code{FALSE})?
#' @noRd
.connect_dungeon <- function(m, is_snake) {

  start_coords <- which(data.frame(m) == ".", arr.ind = TRUE)
  start_coords_df <- data.frame(start_coords)

  if (!is_snake) {
    start_coords_df <- start_coords_df[sample(1:nrow(start_coords_df)), ]
  }

  corridor_ew <- vector(mode = "list", length = (nrow(start_coords_df) - 1))

  for (i in seq(nrow(start_coords_df) - 1)) {
    col_start <- start_coords_df[i, "col"]
    col_end   <- start_coords_df[i + 1, "col"]
    corridor_ew[[i]] <- c(col_start, col_end)
  }

  for (i in seq(length(corridor_ew))) {
    m[start_coords_df[i, "row"],
      seq(corridor_ew[[i]][1], corridor_ew[[i]][2])] <- "."
  }

  corridor_ns <- vector(mode = "list", length = (nrow(start_coords_df) - 1))

  for (i in seq(nrow(start_coords_df) - 1)) {
    row_start <- start_coords_df[i, "row"]
    row_end   <- start_coords_df[i + 1, "row"]
    corridor_ns[[i]] <- c(row_start, row_end)
  }

  for (i in seq(length(corridor_ns))) {
    m[seq(corridor_ns[[i]][1], corridor_ns[[i]][2]),
      start_coords_df[i + 1, "col"]] <- "."
  }

  m

}

#' Print A Dungeon Matrix To The Console
#' @param m Matrix. Dungeon matrix output from \code{\link{.create_dungeon}}.
#' @param colour Logical. Should the characters be coloured using \pkg{crayon}
#'   (\code{TRUE})?
#' @noRd
.draw_dungeon <- function(m, colour) {

  if (!is.matrix(m)) {
    stop("Argument m must be a matrix.")
  }

  if (colour) {
    m[which(m == ".")] <- crayon::black(".")
    m[which(m == "|")] <- crayon::yellow("|")
    m[which(m == "-")] <- crayon::yellow("-")
    m[which(m == "#")] <- crayon::red("#")
  }

  for (i in seq(nrow(m))) {
    cat(m[i, ], "\n")
  }

}
