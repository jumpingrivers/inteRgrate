
<!-- README.md is generated from README.Rmd. Please edit that file -->

# inteRgrate: Very opinated package development

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Build
Status](https://travis-ci.org/jumpingrivers/inteRgrate.png?branch=master,dev)](https://travis-ci.org/jumpingrivers/inteRgrate)
[![CRAN](http://www.r-pkg.org/badges/version/inteRgrate)](https://cran.r-project.org/package=inteRgrate)
<!-- [![codecov.io](https://codecov.io/github/csgillespie/poweRlaw/coverage.svg?branch=master)](https://codecov.io/github/csgillespie/poweRlaw?branch=master) -->
<!-- [![Downloads](http://cranlogs.r-pkg.org/badges/poweRlaw?color=brightgreen)](https://cran.r-project.org/package=poweRlaw) -->

<!-- badges: end -->

The goal of inteRgrate is to provide an very opinionated set of rules
for R package development. The idea is that when many people contribute
to a package, it’s easy for standards to diverge. We think that CI can
help here. This package has the same functions for both travis and
Gitlab-CI environments. Currently, the package is used by [Jumping
Rivers](https://www.jumpingrivers.com) on GitHub and GitLab.

The rationale behind this package is

  - While checking R packages on travis is easy, support for GitLab (and
    others) is lacking.
  - When developing a package, sometimes we want to specify the exact
    number of NOTES and WARNINGS we expect/allow.
  - Having a consistent system for different CI is desirable.
  - For our CI steps, we have a few other checks that we tend to
    implement, e.g. lints, not using imports within namespaces.

This package is still being developed, but we are now actively using it,
so hopefully we can avoid breaking changes.

## Installation

As the package is currently being developed, it isn’t yet on CRAN. The
development version can be installed from [GitHub](https://github.com/)
with:

``` r
install.packages("remotes")
remotes::install_github("jumpingrivers/inteRgrate")
```

## Functions

The package is meant to be used within a continuous integration
framework, e.g. travis, GitLab runner. This package contains a number
functions that are useful for CI:

  - `check_pkg()` - installs package dependencies, builds & installs the
    package, before running package check. By default, **any** notes or
    warnings will raise an error message. This can be changed by setting
    the environment variables `ALLOWED_NOTES` and `ALLOWED_WARNINGS`.
  - `check_namespace()` - check for instances of `import()` in the
    NAMESPACE file. By default, no imports are allowed. This can be
    changed via the environment variable `NO_IMPORTS`
  - `check_lintr()` - runs lintr on the package, README.Rmd and
    vignettes.
  - `check_r_filenames()` - ensures file extensions are `.R` and all
    names are lower case.
  - `check_meta()` - ensure that the DESCRIPTION file is tidy, via
    `usethis::use_tidy_description()`, checks README.Rmd timestamps,
    checks .gitignore contains standard files.
  - `check_version()` - ensures that the package description has been
    updated.
  - `check_windows_isses()` - ensures that linux line breaks are used
    and file permissions are sensible.
  - `create_tag()` - autotag via the CI.

See the help pages for customisation.

There’s also a pre-commit hook to help. Run
`inteRgrate::add_pre_commit()` in root git directory of your repo and
checks will be run before committing.

### Example .travis.yml file

    language: r
    cache: packages
    env:
      global:
        - ALLOWED_WARNINGS=0
        - ALLOWED_NOTES=0
        - NO_IMPORTS=0
    
    script:
      - Rscript -e "inteRgrate::check_pkg()"
      - Rscript -e "inteRgrate::check_r_filenames()"
      - Rscript -e "inteRgrate::check_tidy_description()"
      - Rscript -e "inteRgrate::check_lintr()"
      - Rscript -e "inteRgrate::check_namespace()"
      - Rscript -e "inteRgrate::check_version()"

### Example .gitlab.yml file

    image: rocker/r-ubuntu:18.04
    variables:
      ALLOWED_WARNINGS: 0
      ALLOWED_NOTES: 0
      NO_IMPORTS: 0
    
    before_script:
      - Rscript -e "install.packages('remotes')"
      - Rscript -e "remotes::install_github('jumpingrivers/inteRgrate')"
    
    check:
      script:
        - Rscript -e "inteRgrate::check_pkg()"
        - Rscript -e "inteRgrate::check_r_filenames()"
        - Rscript -e "inteRgrate::check_tidy_description()"
        - Rscript -e "inteRgrate::check_lintr()"
        - Rscript -e "inteRgrate::check_namespace()"

### Command line

You can also use it at the command line

``` r
library("inteRgrate")
check_pkg()
check_r_filenames()
```

## Other information

  - ROpensci are developing a related package -
    [tic](https://github.com/ropenscilabs/tic). The
    [tic](https://github.com/ropenscilabs/tic) package aims to specify
    the CI environment purely by an R script.

  - If you have any suggestions or find bugs, please use the github
    [issue tracker](https://github.com/jumpingrivers/inteRgrate/issues)

  - Feel free to submit pull requests

-----

Development of this package was supported by [Jumping
Rivers](https://www.jumpingrivers.com)
