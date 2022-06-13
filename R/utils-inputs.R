#' Record Keypress Input From User
#' @noRd
.accept_keypress <- function() {

  supports_keypress <- keypress::has_keypress_support()

  # Accepted keypresses
  wasd_kps <- c("w", "a", "s", "d")
  udlr_kps <- c("up", "down", "left", "right")
  inv_kps  <- "1"
  exit_kps <- "0"
  is_legal_key <- FALSE

  while (!is_legal_key) {

    if (supports_keypress) {

      kp <- keypress::keypress()

      if (kp %in% wasd_kps) {  # allow wasd even if {keypress} is viable
        kp <- switch(
          kp,
          "w" = "up",
          "s" = "down",
          "a" = "left",
          "d" = "right"
        )
      }

      if (kp %in% c(udlr_kps, inv_kps, exit_kps)) {
        is_legal_key <- TRUE
      }

    }

    if (!supports_keypress) {

      kp <- readline("Input: ")

      if (kp %in% wasd_kps) {
        kp <- switch(
          kp,
          "w" = "up",
          "s" = "down",
          "a" = "left",
          "d" = "right"
        )
      }

      if (kp %in% c(udlr_kps, inv_kps, exit_kps)) {
        is_legal_key <- TRUE
      }

    }

  }

  return(kp)

}
