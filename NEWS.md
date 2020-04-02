# DEV
  * Bug: Remove binary files from Windows checks
  
# Version 0.4.1
  * Bug: .Rbuildignore files are case insensitive!
  * Bug: Parsing .gitlab-ci files
  * Bug: Remove deleted files in pre-commit check
  * Feature: Raise an error on when `readLines()` doesn't end with a new line
  * Feature: Check for Windows line breaks
  * Feature: Check file permission

# Version 0.4.0
  * Feature: Add env variable to check_meta
  * Feature: Add `check_tidy_des()` to `check_meta()`.

# Version 0.3.0
  * Feature: Adding in pre-commit & pre-push hook
  * Feature: Adding a meta check for markdown docs
  * Feature: `create_tag()` on travis
  * Bug: parsing `.gitlab-ci` now removes comments

# Version 0.2.3
  * Other: Remove dashes from tag

# Version 0.2.2
  * Bug: fixes when detecting tagging

# Version 0.2.1
  * Other: Standardisation of messages & colours
  * Improvement: Don't tag if package hasn't changed

# Version 0.2.0
  * Feature (check): lintr checks to vignettes
  * Feature (check): Adding check_version
  * Feature (check): Check version number is tidyverse compliant
  * Feature (check): Run checks via environment variables
  * Feature: Install dependencies by default
  * Feature: Set PKG_TARBALL in the .Renviron on build step
  * Feature: Auto tagging via Gitlab CI
  * Other: pkgdown site

# Version 0.1.0
  * Initial version
