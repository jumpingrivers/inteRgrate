#' Build R tar gz file
#'
#' Builds and sets the PKG_TARBALL & PKG_TARBALL_PATH variables.
#' @export
build_pkg = function() {
  cli::cli_h3("Build .tar.gz file")
  system2("R", args = c("CMD", "build", "."))

  des = read.dcf("DESCRIPTION")[1, ]
  version = des[names(des) == "Version"]
  package = des[names(des) == "Package"]

  pkg_tar_ball = paste0(package, "_", version, ".tar.gz")
  set_renviron_var("PKG_TARBALL", pkg_tar_ball)
  cli::cli_alert_info("PKG_TARBALL {pkg_tar_ball}")

  full_path = normalizePath(file.path(".", pkg_tar_ball))
  set_renviron_var("PKG_TARBALL_PATH", full_path)
  cli::cli_alert_info("PKG_TARBALL_PATH {full_path}")

  return(pkg_tar_ball)
}

#' @rdname build_pkg
#' @export
get_pkg_tar_ball = function() {
  if (!is.na(Sys.getenv("PKG_TARBALL", NA))) {
    return(Sys.getenv("PKG_TARBALL"))
  }

  des = read.dcf("DESCRIPTION")[1, ]
  version = des[names(des) == "Version"]
  package = des[names(des) == "Package"]

  pkg_tar_ball = paste0(package, "_", version, ".tar.gz")
  set_renviron_var("PKG_TARBALL", pkg_tar_ball)
  pkg_tar_ball
}
