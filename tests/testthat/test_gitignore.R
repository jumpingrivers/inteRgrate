test_that("Testing gitignore", {

  good_pkg = system.file("good_pkg", package = "inteRgrate")
  gitignore = file.path(good_pkg, "gitignore")
  file.copy(gitignore, ".gitignore", overwrite = TRUE)
  on.exit(file.remove(".gitignore"))
  expect_null(check_gitignore(path = "."))
})
