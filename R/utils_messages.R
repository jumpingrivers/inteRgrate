msg_error = function(msg) {
  cli::cli_alert_danger(msg, .envir = parent.frame())

  if (isFALSE(.check$all)) {
    stop(call. = FALSE)
  }
  .check$error = TRUE
}
