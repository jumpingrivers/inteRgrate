info = clisymbols::symbol$info
cross = clisymbols::symbol$cross
tick = clisymbols::symbol$tick
circle_filled = clisymbols::symbol$circle_filled

red = crayon::red
blue = crayon::blue
yellow = crayon::yellow
green = crayon::green

msg_error = function(msg, stop = FALSE) {
  if (isFALSE(stop)) {
    message(glue::glue_col("{red}{cross} {msg}"))
  } else {
    stop(glue::glue_col("{red}{cross} {msg}"), call. = FALSE)
  }
}

msg_start = function(msg) {
  message(glue::glue_col("{blue}{circle_filled} {msg}"))
}

msg_ok = function(msg) {
  message(glue::glue_col("{green}{tick} {msg}"))
}

msg_info = function(msg) {
  message(glue::glue_col("{yellow}{info} {msg}"))
}
