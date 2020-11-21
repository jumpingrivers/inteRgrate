#' Namespace checks
#'
#' Importing too many packages can cause bugs due to namespace clashes. This check
#' enforces a set number of imports. As a rule of thumb, if you only use a few functions from
#' a package, use \code{importFrom} instead of \code{import} in your NAMESPACE file.
#' @inheritParams check_r_filenames
#' @param no_imports Default NULL. Number of package imports via \code{import()} allowed in the
#' NAMESPACE. If \code{NULL}, checks for environment variable NO_IMPORTS, otherwise
#' 0.
#' @importFrom cli cli_alert_warning
#' @export
check_namespace = function(no_imports = NULL, path = ".") {
  if (is.null(no_imports)) {
    no_imports = get_env_variable("NO_IMPORTS", 0)
  }
  cli::cli_h3("Checking namespace for imports()...check_namespace()")
  namespace = readLines(file.path(path, "NAMESPACE"))

  imports_only = namespace[substr(namespace, 1, 7) == "import("]
  if (length(imports_only) == no_imports) {
    msg = glue("Imports look good - {length(imports_only)} found, {no_imports} allowed")
    cli::cli_alert_success(msg)
    return(invisible(NULL))
  } else if (length(imports_only) < no_imports) {
    msg = glue("Imports look good - {length(imports_only)} found, {no_imports} allowed.
               But you could reduce the number of imports allowed")
    cli::cli_alert_warning(msg)
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
  msg_error(msg)
}
