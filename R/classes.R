#' Generate An R6-Class Room
#' @noRd
Room <- R6::R6Class(
  classname = "Room",
  public = list(

    #' @field tile Character.
    tile = ".",
    #' @field wall Character.
    wall = "#",
    #' @field x_range Numeric vector.
    x_range = 6:10,
    #' @field y_range Numeric vector.
    y_range = 6:10,
    #' @field x Numeric.
    x = NULL,
    #' @field y Numeric.
    y = NULL,
    #' @field matrix Matrix
    matrix = NULL,
    #' @field player R6-class object.
    player = NULL,
    #' @field player_loc Numeric
    player_loc = NULL,

    #' @description Initialize an R6-class room.
    #' @param x_range Numeric vector.
    #' @param y_range Numeric vector.
    #' @return An R6-class object.
    initialize = function(x_range = self$x_range, y_range = self$y_range) {
      self$player <- r.oguelike:::Player$new()
      self$x <- sample(x_range, 1)
      self$y <- sample(y_range, 1)
      self$matrix <- self$build(self$x, self$y)
      self$player_loc <- self$find_empty_tile()
      self$matrix[self$player_loc] <- self$player$sprite
    },

    #' @description Create a room matrix.
    #' @param x Numeric.
    #' @param y Numeric.
    #' @return Matrix.
    build = function(x, y) {
      room_1d <- rep(self$tile, x * y)
      room_2d <- matrix(room_1d, nrow = x, ncol = y)
      room_2d[c(1, nrow(room_2d)), ] <- self$wall
      room_2d[, c(1, ncol(room_2d))] <- self$wall
      self$matrix <- room_2d
    },

    #' @description Find an empty tile.
    #' @param room Matrix.
    #' @return Numeric.
    find_empty_tile = function(room = self$matrix) {
      empty_tiles <- which(room == ".")
      sample(empty_tiles, 1)
    },

    #' @description Default print method for room.
    #' @param matrix Matrix.
    #' @return Printed output.
    print = function(room = self$matrix) {
      for (i in 1:nrow(room)) {
        cat(room[i, ], "\n")
      }
    }

  )
)

#' Generate An R6-Class Player
#' @noRd
Player <- R6::R6Class(
  classname = "Player",
  public = list(

    #' @field sprite Character.
    sprite = "@",
    #' @field max_hp Numeric.
    max_hp = NULL,
    #' @field hp Numeric.
    hp     = NULL,
    #' @field atk Numeric.
    atk    = NULL,
    #' @field move Numeric.
    move   = NULL,

    #' @description Initialize an R6-class player.
    #' @param max_hp Numeric.
    #' @param hp Numeric.
    #' @param atk Numeric.
    #' @param move Numeric.
    #' @return An R6-class object.
    initialize = function(max_hp = 10, hp = 10, atk = 1, move = 1) {
      self$max_hp <- max_hp
      self$hp     <- hp
      self$atk    <- atk
      self$move   <- move
    }

  )
)

#' Generate An R6-Class Enemy
#' @noRd
Enemy <- R6::R6Class(
  classname = "Enemy",
  public = list(

    #' @field sprite Character.
    sprite = "e",
    #' @field hp Numeric.
    hp = NULL,
    #' @field atk Numeric.
    atk = NULL,
    #' @field move Numeric.
    move = NULL,

    #' @description Initialize an R6-class enemy.
    #' @param hp Numeric.
    #' @param atk Numeric.
    #' @param move Numeric.
    #' @return An R6-class object.
    initialize = function(hp = 4, atk = 1, move = 1) {
      self$hp     <- hp
      self$atk    <- atk
      self$move   <- move
    }

  )
)

#' Generate An R6-Class Boss Enemy
#' @noRd
Boss <- R6::R6Class(
  classname = "Boss",
  inherit = Enemy,
  public = list(

    #' @field sprite Character.
    sprite = "E",

    #' @description Initialize an R6-class boss enemy
    #' @param hp Numeric.
    #' @param atk Numeric.
    #' @param move Numeric.
    #' @return An R6-class object.
    initialize = function(hp = 8, atk = 2, move = 1) {
      self$hp     <- hp
      self$atk    <- atk
      self$move   <- move
    }

  )
)
