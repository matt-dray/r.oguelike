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

  room <- .create_dungeon(n_row, n_col, n_rooms)

  if (is_organic) {
    room <- .connect_dungeon(room, is_snake)
  }

  i <- 0

  while (i < iterations) {
    room <- .grow_dungeon(room)
    i <- i + 1
  }

  if (!is_organic) {
    room <- .connect_dungeon(room, is_snake)
  }

  room <- .add_object(room, "$")
  room <- .add_object(room, "E")
  room <- .add_object(room, "a")
  room <- .add_object(room, "@")

  room

}

#' Initiate A Distance Map Version Of A Dungeon Room
#' @param room Matrix. 2D game_map layout.
#' @noRd
.initiate_distance_map <- function(room) {

  dist <- room
  dist[which(dist != "#")] <- 0
  dist[which(dist == "#")] <- Inf
  matrix(as.numeric(dist), nrow(dist), ncol(dist))

}

#' Create A Breadth-First Distance Map To The Player
#' @param room Matrix. 2D game_map layout.
#' @noRd
.get_distance_map <- function(room) {

  dist <- .initiate_distance_map(room)

  start <- which(room == "@")
  frontier <- start
  visited <- c()

  while (length(frontier) > 0) {

    current  <- frontier[1]  # set first tile of frontier as current
    frontier <- frontier[!frontier == current]  # remove current tile from frontier
    visited  <- append(visited, current)  # mark current as visited

    neighbours <- .get_neighbours(room, current)  # get vector of neighbour indices
    neighbours <- neighbours[!neighbours %in% visited]

    for (neighbour in neighbours) {
      if (!neighbour %in% visited) {  # only assign distance to unvisited neighbours
        dist[neighbour] <- dist[current] + 1  # assign distance, one more than parent
      }
    }

    frontier <- append(frontier, neighbours)  # add neighbour to the frontier

  }

  dist

}

#' Identify Neighbour Tiles
#' @param room Matrix. 2D room layout.
#' @param current Numeric. Matrix index of tile to inspect.
#' @noRd
.get_neighbours <- function(room, current) {

  n_rows <- nrow(room)

  c(
    if (room[current - n_rows] != "#") current - n_rows,
    if (room[current - 1] != "#") current - 1,
    if (room[current + 1] != "#") current + 1,
    if (room[current + n_rows] != "#") current + n_rows
  )

}

# Unused ------------------------------------------------------------------


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
