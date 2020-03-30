# See https://community.rstudio.com/t/incomplete-final-line-found-whats-the-big-deal/56536
# Also cleans up noise from readLines
# nolint start
readLines = function(con = stdin(), n = -1L, ok = TRUE, warn = TRUE,
                     encoding = "unknown", skipNul = FALSE) {
  out = tryCatch(base::readLines(con = con, n = n, ok = ok, warn = warn,
                           encoding = encoding, skipNul = skipNul),
               error = function(e) e,
               warning = function(w) w)
  if ("warning" %in% class(out)) {
    msg = paste0("Files should end with an empty line. Check \n\n", normalizePath(con))
    msg_error(msg)
    stop(call. = FALSE)
  }
  out
}
#nolint end
