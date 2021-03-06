#' @importFrom tibble tibble tribble
#' @export
#' @rdname check_rproj
get_default_rproj = function() {
  tibble::tribble(~prop_key, ~prop_value,
                  "Version", "1.0",
                  "UseSpacesForTab", "Yes",
                  "NumSpacesForTab", "2",
                  "Encoding", "UTF-8",
                  "AutoAppendNewline", "Yes",
                  "StripTrailingWhitespace", "Yes")
}

get_rproj = function(path) {
  rproj_fname = list.files(path = path, pattern = "\\.Rproj$")
  if (length(rproj_fname) == 0 || length(rproj_fname) > 1) {
    msg_error("{length(rproj_fname)} {.file .Rproj} file{?s} detected")
    return(tibble::tibble(key = character(0), value = character(0)))
  }

  cli::cli_alert_info("Reading {.file {rproj_fname}}")
  # Read rproj and remove blank lines
  rproj = base::readLines(rproj_fname, warn = FALSE)
  rproj = rproj[nchar(rproj) > 0]
  # key-value tibble
  key_values = stringr::str_split(rproj, ": ")
  key_values = lapply(key_values,
                      function(i) tibble::tibble(key = i[1], value = as.character(i[2])))
  do.call(rbind.data.frame, key_values)
}

print_bad_values = function(rproj) {
  for (i in seq_len(nrow(rproj))) {
    cli::cli_alert_danger("{.key {rproj$key[i]}} \\
    should be {rproj$prop_value[i]} not {rproj$value[i]}")
  }
}

#' @title Check the .Rproj file
#'
#' @description If a .Rproj file exists, then the values should correspond to those given by
#' \code{get_default_rproj}. If more than one .Rproj file exists, an error is raised.
#' @param default_rproj Default Rproj values.
#' @inheritParams check_pkg
#' @export
#' @examples
#' check_readme()
check_rproj = function(default_rproj = get_default_rproj(), path = ".") {
  cli::cli_h3("Checking Rproj...check_rproj()")
  rproj = get_rproj(path = path)
  if (nrow(rproj) == 0L) return(invisible(NULL))

  # Do a join then iterate
  join_rproj = merge(rproj, default_rproj, by.x = "key", by.y = "prop_key")
  join_rproj = join_rproj[!(join_rproj$value == join_rproj$prop_value), ]

  if (nrow(join_rproj) == 0L) {
    cli::cli_alert_success("{.file Rproj} looks good!")
    return(invisible(TRUE))
  }
  print_bad_values(join_rproj)
}
