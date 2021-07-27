test_that("flatten - left join all fk resources", {

  expected <- structure(list(id_c = c("8", "9", "10"),
                             `dim-c.lowercase` = c("h", "i", "j"),
                             id_b = c("4", "5", "6"),
                             `dim-b.lowercase` = c("d", "e", "f"),
                             id_a = c("1", "2", "3"),
                             `dim-a.lowercase` = c("a", "b", "c"),
                             uppercase = c("A", "B", "C"),
                             value = c("100", "50", "200")),
                        class = c("data.table", "data.frame"),
                        row.names = c(NA, -3L))

  object <- flatten_resource(test_file("flatten_resource/datapackage.json"), "fact")

  expect_equal(object, expected)
})



test_that("flatten - left join only specific resources", {

  expected <- structure(list(id_a = c("1", "2", "3"),
                             lowercase = c("a", "b", "c"),
                             uppercase = c("A", "B", "C"),
                             id_b = c('4', '5', '6'),
                             id_c = c('8', '9', '10'),
                             value = c("100", "50", "200")),
                        class = c("data.table", "data.frame"),
                        row.names = c(NA, -3L))

  object <- flatten_resource(test_file("flatten_resource/datapackage.json"), "fact", "dim-a")

  expect_equal(object, expected)
})
