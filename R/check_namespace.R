#' Namespace checks
#'
#' Importing too many packages can cause bugs due to namespace clashes. This check
#' enforces a set number of imports. As a rule of thumb, if you only use a few functions from
#' a package, use \code{importFrom} instead of \code{import} in your NAMESPACE file.
#' @param no_imports Default NULL. Number of package imports via \code{import()} allowed in the
#' NAMESPACE. If \code{NULL}, checks for environment variable NO_IMPORTS, otherwise
#' 0.
#' @export
check_namespace = function(no_imports = NULL) {
  set_crayon()
  if (is.null(no_imports)) {
    no_imports = Sys.getenv("NO_IMPORTS", 0)
  }
  msg = glue("{symbol$circle_filled} Checking namespace for imports()...check_namespace()")
  message(blue(msg))

  namespace = readLines("NAMESPACE")
  imports_only = namespace[substr(namespace, 1, 7) == "import("]
  if (length(imports_only) <= no_imports) {
    msg = glue("{symbol$tick} Imports look good")
    message(green(msg))
    return(invisible(NULL))
  }

  imports_only = substr(imports_only, 8, nchar(imports_only) - 1)
  for (import in imports_only) {
    msg = glue::glue("{symbol$cross} The package {import} is being directly imported - \\
               use importFrom instead.")
    message(red(msg))
  }
  stop(call. = FALSE)
}
