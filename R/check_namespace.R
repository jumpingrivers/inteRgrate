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
    no_imports = get_env_variable("NO_IMPORTS", 0)
  }
  msg_start("Checking namespace for imports()...check_namespace()")
  namespace = readLines("NAMESPACE")
  imports_only = namespace[substr(namespace, 1, 7) == "import("]
  if (length(imports_only) <= no_imports) {
    msg = glue("Imports look good - {length(imports_only)} found, {no_imports} allowed")
    msg_ok(msg)
    return(invisible(NULL))
  }

  imports_only = substr(imports_only, 8, nchar(imports_only) - 1)
  for (import in imports_only) {
    msg = glue::glue("The package {import} is being directly imported - \\
               use importFrom instead.")
    msg_error(msg)
  }
  msg = glue::glue("A total of {length(imports_only)} imports detected. \\
                   But only {no_imports} are allowed.")
  msg_error(msg, stop = TRUE)
}
