# inteRgrate 1.0.19 _2021-09-06_
  * Bug: support for main

# inteRgrate 1.0.18 _2021-06-28_
  * Add support for main

# inteRgrate 1.0.17 _2021-04-10_
  * Add more exclusions (again)

# inteRgrate 1.0.16 _2021-04-07_
  * Fix exclusions parsing (again!)

# inteRgrate 1.0.15 _2021-04-05_
  * Exclude cache/ from linting

# inteRgrate 1.0.12 _2021-03-17_
  * Bug: detecting version changes

# inteRgrate 1.0.11 _2021-03-14_
  * Bug: Previous bug fix caused issues

# inteRgrate 1.0.10 _2021-03-11_
  * Bug: don't lint renv or packrat folders

# inteRgrate 1.0.9 _2021-01-22_
  * Bug: multiple pkgs in a repo

# inteRgrate 1.0.8 _2021-01-05_
  * Feature: `check_version()` now works with multiple pkgs in a repo
  * Bug: `check_lintr()` ignores `R/*.rda` files (fixes #33)
  
# inteRgrate 1.0.7 _2020-11-25_
  * Feature: `check_all()` to run all checks
  * Feature: Call `stop()` at the of the checks 

# inteRgrate 1.0.6 _2020-10-23_
  * Feature: allow `*` as emphasis indicator

# inteRgrate 1.0.5 _2020-10-23_
  * Feature: parse `.lintr` file for file exclusions
  * Docs: Incorrect description of NEWS format

# inteRgrate 1.0.4 _2020-08-10_
  * Change: Add `path` argument to all `check_*()` functions
  * Bug: Travis started tagging on branches
  * Minor: Tidy up NEWS.md
  * Adding tests
  * Cleaning NEWS entries

# inteRgrate 1.0.3 _2020-07-04_
  * Feature: Add `check_news()`

# inteRgrate 1.0.2
  * Feature: Ensure files end with a line break
  * Feature: Build pkgs and set ENV variables
  * Feature: Add tests for yml parsing
  
# inteRgrate 1.0.1
  * Breaking changes
  * Feature: use __rcmdcheck__ instead of __devtools__. This breaks/changes a few things.
  * Feature: `check_via_env()` now has arguments
  * Change: Remove explicit install and build functions.
  * Change: Use __cli__ exclusively
  * Change: lint all Rmd and R files
  * Change: Remove `check_meta()` - expand to separate functions

# inteRgrate 0.4.*
  * Bug: `.Rbuildignore` files are case insensitive!
  * Bug: Parsing `.gitlab-ci` files
  * Bug: Remove deleted files in pre-commit check
  * Feature: Raise an error on when `readLines()` doesn't end with a new line
  * Feature: Check for Windows line breaks
  * Feature: Check file permission
  * Feature: Add env variable to check_meta
  * Feature: Add `check_tidy_des()` to `check_meta()`.

# inteRgrate 0.3.0
  * Feature: Adding in pre-commit & pre-push hook
  * Feature: Adding a meta check for markdown docs
  * Feature: `create_tag()` on travis
  * Bug: parsing `.gitlab-ci` now removes comments

# inteRgrate 0.2.*
  * Other: Remove dashes from tag
  * Bug: fixes when detecting tagging
  * Other: Standardisation of messages & colours
  * Improvement: Don't tag if package hasn't changed
  * Feature (check): lintr checks to vignettes
  * Feature (check): Adding `check_version()`
  * Feature (check): Check version number is tidyverse compliant
  * Feature (check): Run checks via environment variables
  * Feature: Install dependencies by default
  * Feature: Set PKG_TARBALL in the `.Renviron` on build step
  * Feature: Auto tagging via Gitlab CI
  * Other: __pkgdown__ site

# inteRgrate 0.1.0
  * Initial version of inteRgrate
