msg_error = function(msg) {
  cli::cli_alert_danger(msg)
  if (isTRUE(stop)) {
    stop(call. = FALSE)
  }
}
