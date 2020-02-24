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
