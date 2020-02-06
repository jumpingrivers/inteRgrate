#' @rdname check_pkg
#' @importFrom devtools as.package
#' @export
get_pkg_tar_ball = function() {
  if (!is.na(Sys.getenv("PKG_TARBALL", NA))) {
    return(Sys.getenv("PKG_TARBALL"))
  }

  pkg = devtools::as.package(".")
  pkg_tar_ball = paste0(pkg$package, "_", pkg$version, ".tar.gz")
  set_renviron_var("PKG_TARBALL", pkg_tar_ball)
  pkg_tar_ball
}

#' Build R package
#' @rdname check_pkg
#' @export
build_pkg = function(path = NULL) {
  set_crayon()
  msg_start("Building the package")

  if (is.null(path)) path = get_build_dir(path)
  devtools::build(pkg = path, path = path)
  set_renviron_var("PKG_TARBALL", get_pkg_tar_ball())

  msg_ok(paste("Package built:", get_pkg_tar_ball()))
  invisible(get_pkg_tar_ball())
}
