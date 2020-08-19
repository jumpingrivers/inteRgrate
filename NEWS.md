# inteRgrate (development version)
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

# inteRgrate 0.4.1
  * Bug: .Rbuildignore files are case insensitive!
  * Bug: Parsing `.gitlab-ci` files
  * Bug: Remove deleted files in pre-commit check
  * Feature: Raise an error on when `readLines()` doesn't end with a new line
  * Feature: Check for Windows line breaks
  * Feature: Check file permission

# inteRgrate 0.4.0
  * Feature: Add env variable to check_meta
  * Feature: Add `check_tidy_des()` to `check_meta()`.

# inteRgrate 0.3.0
  * Feature: Adding in pre-commit & pre-push hook
  * Feature: Adding a meta check for markdown docs
  * Feature: `create_tag()` on travis
  * Bug: parsing `.gitlab-ci` now removes comments

# inteRgrate 0.2.3
  * Other: Remove dashes from tag

# inteRgrate 0.2.2
  * Bug: fixes when detecting tagging

# inteRgrate 0.2.1
  * Other: Standardisation of messages & colours
  * Improvement: Don't tag if package hasn't changed

# inteRgrate 0.2.0
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
