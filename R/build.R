# nolint start
#' @rdname check_pkg
#' @export
get_pkg_tar_ball = function() {
  des_file = file.path(get_build_dir(), "DESCRIPTION")
  des = read.dcf(des_file)
  pkg_name = des[colnames(des) == "Package"]
  pkg_version = des[colnames(des) == "Version"]
  pkg_tar_ball = glue::glue("{pkg_name}_{pkg_version}.tar.gz")
  pkg_tar_ball = file.path(get_build_dir(), "..", pkg_tar_ball)
  if (!file.exists(pkg_tar_ball)) {
    message("Package tar ball doesn't yet exist.")
  }
  pkg_tar_ball
}
# nolint end

#' Build R package
#' @rdname check_pkg
#' @export
build_pkg = function(path = NULL) {
  set_crayon()
  msg = glue::glue("{symbol$circle_filled} Building the package")
  message(blue(msg))

  path = get_build_dir(path)
  pkg_tar_ball = devtools::build(path)

  msg = glue::glue("{symbol$tick} Package built: {pkg_tar_ball}")
  message(green(msg))
  invisible(pkg_tar_ball)
}
