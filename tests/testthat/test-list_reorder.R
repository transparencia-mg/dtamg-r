test_that("reorder list elements by the given names", {

  x <- list(a = 1, b = 2, c = 3)

  expect_equal(list_reorder(x, c("c", "b", "a")), list(c = 3, b = 2, a = 1))
  expect_equal(list_reorder(x, c("d")), list(a = 1, b = 2, c = 3))
  expect_equal(list_reorder(x, c("d", "c")), list(c = 3, a = 1, b = 2))
})
