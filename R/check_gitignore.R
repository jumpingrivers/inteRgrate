# https://github.com/github/gitignore/blob/master/R.gitignore
git_global_ignore = c(
  ".Rhistory", # History files
  ".Rapp.history",
  ".RData", # Session Data files
  ".Ruserdata", # User-specific files
  "*-Ex.R", # Example code in package build process
  "/*.tar.gz", # Output files from R CMD build
  "/*.Rcheck/", # Output files from R CMD check
  ".Rproj.user/", # RStudio files
  "vignettes/*.html", # produced vignettes
  "vignettes/*.pdf",
  ".httr-oauth", # OAuth2 token, see https://github.com/hadley/httr/releases/tag/v0.3
  "*_cache/", # knitr and R markdown default cache directories
  "/cache/",
  "*.utf8.md", # Temporary files created by R markdown
  "*.knit.md",
  ".Renviron", # R Environment Variables
  ".DS_Store"
)

#' @title Check gitignore file
#' @description Checks the gitignore files for recommended patterns. If any of these
#' patterns are missing, an error is raised.
#' @inheritParams check_pkg
#' @importFrom utils glob2rx
#' @export
check_gitignore = function(path = ".") {
  cli::cli_h3("Checking .gitignore...check_gitignore()")
  gitignore = file.path(path, ".gitignore")
  if (!file.exists(gitignore)) {
    msg_error(".gitignore not found")
    return(invisible(NULL))
  }
  ## Get ignores and remove ignored files
  ignores = readLines(gitignore)
  ignores = ignores[stringr::str_detect(ignores, pattern = "^#", negate = TRUE)]
  ignores = ignores[nchar(ignores) > 0L]

  ## This is a hack to get rid of brackets in some reg ex,
  ## .e.g *.synctex(busy)
  ignores = ignores[!stringr::str_detect(ignores, pattern = "\\(|\\)")]

  list_ignores = sapply(glob2rx(ignores, trim.head = FALSE, trim.tail = FALSE),
                        function(ignore) stringr::str_detect(git_global_ignore, ignore))

  mat_ignores = matrix(list_ignores, ncol = length(git_global_ignore), byrow = TRUE)

  ignore_files = apply(mat_ignores, 2, any)
  missing_ignores = git_global_ignore[!ignore_files]
  if (length(missing_ignores) != 0L) {
    for (ignore in missing_ignores) {
      msg_error(paste("Missing", ignore, " from .gitignore"))
    }
    msg_error("Copying github.com/github/gitignore/blob/master/R.gitignore is a good start.")
    msg_error("Please update your .gitignore")
  } else {
    cli::cli_alert_success(".gitignore looks good")
  }
  return(invisible(NULL))
}
