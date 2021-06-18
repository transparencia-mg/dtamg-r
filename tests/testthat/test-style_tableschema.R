test_that("style table schema ordering", {

  output_file <- fs::file_temp(ext = "yaml")

  style_tableschema(test_file("tableschema-unordered.yaml"),
                    output = output_file)

  styled_tableschema <- readLines(output_file)

  ordered_tableschema <- readLines(test_file("tableschema-ordered.yaml"))

  expect_equal(styled_tableschema, ordered_tableschema)
})
