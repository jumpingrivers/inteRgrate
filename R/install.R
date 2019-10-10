get_entries = function(path = ".", entry) {
  pkgs = read.dcf(file.path(path, "DESCRIPTION"))
  entries = colnames(as.data.frame(pkgs))
  if (!(entry %in% entries)) return(NULL)

  pkgs = pkgs[1, entry]
  pkgs = str_split(pkgs, ",")[[1]]
  pkgs = str_trim(pkgs)
  pkgs
}

# Fast pre-install of Depends
# Uses the Ubuntu MPA to optimise installation.
#' @importFrom utils download.file
#' @importFrom stringr str_match
fast_pre_install = function(path = ".", suggests = FALSE) {
  if (!is_gitlab()) return(invisible(NULL))

  pkgs = get_entries(path, "Imports")
  if (isTRUE(suggests)) pkgs = c(pkgs, get_entries(path, "Suggests"))
  # This step is useful to get deps for packages where r-cran- isn't available

  pkgs = tools::package_dependencies(pkgs,
                                     which = c("Depends", "Imports", "LinkingTo"),
                                     recursive = TRUE)
  pkgs = unique(as.vector(unlist(pkgs)))
  pkgs = tolower(pkgs) # r-cran-lower-case-pkg-name

  cran_pkgs = system2("apt-cache", args = c("search", "r-cran-*"), stdout = TRUE)
  cran_pkgs = str_match(cran_pkgs, "^r-cran-(.*) - ")[, 2]
  cran_pkgs = cran_pkgs[!is.na(cran_pkgs)]

  avail = pkgs[pkgs %in% cran_pkgs]
  avail = paste0("r-cran-", avail)
  if (length(avail) == 0) return(invisible(NULL))

  cat(avail, sep = "\n")
  system2("apt-get", args = c("update"))
  system2("apt-get", args = c("install", "-y", avail))

  return(invisible(NULL))
}

install_remotes = function(path) {
  remotes = get_entries(path = path, entry = "Remotes")
  for (remote in remotes) {
    url = glue::glue("https://raw.githubusercontent.com/{remote}/master/DESCRIPTION")
    tmp_dir = tempdir()
    temp_file = file.path(tmp_dir, "DESCRIPTION")
    download.file(url, temp_file)
    fast_pre_install(path = tmp_dir)
    devtools::install_github(remote, upgrade = "never")
  }
  return(invisible(NULL))
}

#' @title Install package dependencies
#'
#' Install packages dependencies
#' @inheritParams check_pkg
#' @importFrom devtools install_deps
#' @export
install_deps = function(path = NULL) {
  if (is.null(path)) path = get_build_dir()
  fast_pre_install(path = path, suggests = TRUE)
  install_remotes(path)
  devtools::install_deps(path, dependencies = TRUE)
}

#' @rdname install_deps
#' @importFrom devtools install
#' @export
install_pkg = function(path = NULL) {
  set_crayon()
  path = get_build_dir(path)
  msg = glue::glue("{symbol$circle_filled} Installing the package")
  message(blue(msg))

  devtools::install(path, upgrade = "never", build_vignettes = TRUE)
  msg = glue::glue("{symbol$tick} Package installed")
  message(green(msg))
}
