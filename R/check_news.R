check_news_major = function(news, pkg_name, version) {
  pattern = glue::glue("^# <pkg_name> <version> [_\\*]20\\d{2}-\\d{2}-\\d{2}[_\\*]$",
                       .open = "<", .close = ">")
  if (stringr::str_detect(news[1], pattern = pattern, negate = TRUE)) {
    msg = glue::glue("Top line of NEWS.md not have correct format. It should be
                       # {pkg_name} {version} _{Sys.Date()}_")
    msg_error(msg)
  } else {
    cli::cli_alert_success("Your NEWS.md has the correct format")
  }
}

check_news_minor = function(news, pkg_name, version) {
  pattern = glue::glue("^# {pkg_name} \\(development version\\)$")
  if (stringr::str_detect(news[1], pattern = pattern, negate = TRUE)) {
    msg = glue::glue("Top line of NEWS.md not have correct format. It should be
                       # {pkg_name} (development version)")
    msg_error(msg)
  } else {
    cli::cli_alert_success("Your NEWS.md has the correct format")
  }
}

#' @title Check NEWS format
#'
#' @description Checks that NEWS.md exists and title lines follow the correct format.
#' If the \code{pattern} is \code{NULL}, then the expected format is either:
#' \code{# pkg_name Version _YYYY-MM-DD_} or \code{# pkg_name (development version)}
#' @param pattern Regular expression NEWS title.
#' @inheritParams check_pkg
#' @export
check_news = function(pattern = NULL, path = ".") {
  cli::cli_h3("Checking NEWS.md...check_news()")
  if (!file.exists(file.path(path, "NEWS.md"))) {
    msg_error("NEWS.md is missing")
    return(invisible(NULL))
  }
  description = read.dcf(file.path(path, "DESCRIPTION"))[1, ]
  pkg_name = as.vector(description["Package"]) #nolint
  version = as.vector(description["Version"])
  news = readLines(file.path(path, "NEWS.md"))

  if (is_major_version(version)) {
    check_news_major(news, pkg_name, version)
  } else {
    check_news_minor(news, pkg_name, version)
  }
  return(invisible(NULL))
}


#' @rdname check_news
#' @details The \code{check_all_news()} function isn't used in the CI. It's a
#' convient command line function to quickly assess your NEWS.md file
check_all_news = function(pattern = NULL) {
  cli::cli_h3("Checking NEWS.md...check_news()")

  if (is.null(pattern)) {
    pattern = glue::glue("^# {pkg_name} \\d*\\.\\d*\\.\\d*")
  }

  news = news[stringr::str_detect(news, "^# ")]
  bad_news = news[!stringr::str_detect(news, pattern)]
  if (length(bad_news) > 0L) {
    msg_error("NEWS titles don't have the correct format. See lines")
    vapply(bad_news, cli::cli_alert_danger, FUN.VALUE = character(1))
  } else {
    cli::cli_alert_success("Your NEWS.md has the correct format")
  }
  return(invisible(NULL))
}
