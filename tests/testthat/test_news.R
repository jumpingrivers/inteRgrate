test_that("Testing NEWS.md", {
  on.exit(file.remove(c("DESCRIPTION","NEWS.md")))

  ## No DESCRIPTION file
  expect_error(check_news())

  description = file.path(system.file("test_news", package = "inteRgrate"), "DESCRIPTION-major")
  file.copy(description, to = "DESCRIPTION", overwrite = TRUE)

  news = file.path(system.file("test_news", package = "inteRgrate"), "NEWS-major.md")
  file.copy(news, to = "NEWS.md", overwrite = TRUE)
  expect_null(check_news())

  news = file.path(system.file("test_news", package = "inteRgrate"), "NEWS-error.md")
  file.copy(news, to = "NEWS.md", overwrite = TRUE)
  expect_error(test_news())

  description = file.path(system.file("test_news", package = "inteRgrate"), "DESCRIPTION-dev")
  file.copy(description, to = "DESCRIPTION", overwrite = TRUE)
  news = file.path(system.file("test_news", package = "inteRgrate"), "NEWS-dev.md")
  file.copy(news, to = "NEWS.md", overwrite = TRUE)
  expect_null(check_news())

  good_pkg = system.file("good_pkg", package = "inteRgrate")
  expect_null(check_news(path = good_pkg))

})
