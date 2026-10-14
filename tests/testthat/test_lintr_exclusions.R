test_that("get_exclusions() uses the defaults without a .lintr", {
  withr::local_dir(withr::local_tempdir())
  expect_identical(get_exclusions(), "^R/|^cache/|^packrat/|^renv/")
})

test_that("get_exclusions() keeps files with named exclusions", {
  withr::local_dir(withr::local_tempdir())
  writeLines(
    c(
      "linters: lintr::linters_with_defaults()",
      "exclusions: list(",
      "    \"tests/fixture.R\",",
      "    \"tests\" = list(undesirable_function_linter = Inf),",
      "    \"inst/x.R\" = 1:3",
      "  )"
    ),
    ".lintr"
  )
  expect_identical(get_exclusions(), "tests/fixture.R|^R/|^cache/|^packrat/|^renv/")
})
