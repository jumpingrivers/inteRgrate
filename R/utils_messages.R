msg_error = function(msg, stop = FALSE) {
  cli::cli_alert_danger(msg)
  if (isTRUE(stop)) {
    stop(call. = FALSE)
  }
}
