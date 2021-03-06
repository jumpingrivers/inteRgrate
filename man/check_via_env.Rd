% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_via_env.R
\name{check_via_env}
\alias{check_via_env}
\title{Run all checks}
\usage{
check_via_env(
  pkg = NULL,
  lintr = NULL,
  namespace = NULL,
  r_filenames = NULL,
  version = NULL,
  gitignore = NULL,
  tidy_description = NULL,
  readme = NULL,
  file_permissions = NULL,
  line_breaks = NULL,
  tag = NULL,
  news = NULL,
  rproj = NULL,
  default = FALSE
)
}
\arguments{
\item{pkg}{Build and check package. See details for further information.}

\item{lintr, namespace, r_filenames, version, gitignore, readme, tidy_description}{Default \code{NULL}.}

\item{file_permissions, line_breaks}{Windows related checks.}

\item{tag}{Default \code{NULL}. Create a tagged release.}

\item{news}{Check the top line of NEWS.md}

\item{rproj}{Check Rproject file}

\item{default}{Default \code{FALSE}. The default value the environment variable
should take if missing.}
}
\description{
This function will run all checks within the package.
See the corresponding check functions for details. When \code{default = "true"}, all
checks will run unless the associated environment variable is \code{"false"}.
}
\details{
The arguments for the function correspond to a particular check, e.g. check_ARGNAME().
By default, all arguments are \code{NULL} and hence run. However, a value of
\code{FALSE} or changing the corresponding environment variable
\code{INTERGRATE_ARGNAME} can turn off the check, e.g.\code{INTERGRATE_NAMESPACE}.

On GitLab you can set environment variables at an organisation level.

Note: As this package matures, this function will include the newer checks.
}
