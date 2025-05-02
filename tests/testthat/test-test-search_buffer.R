test_that("dimensions of search_buffer dataframe are as expected", {
  # search for sites containing "Tarn" in their name
  test_search_buffer <- search_buffer(335792, 501379, 2000)
  # check that the dimensions are 4 rows, 3 cols
  expect_true(all(dim(test_search_buffer) == c(4, 4)))
})

test_that("non-numeric coordinates returns an error", {
  # search for sites containing "Aardvark"
  expect_error(search_buffer("Aardvark", 501379, 2000))
})


test_that("coordinates outside BNG range returns an error", {
  # search for sites containing "Aardvark"1300000
  expect_error(search_buffer(335792, 1300001, 2000))
})

test_that("non-numeric buffer distance returns an error", {
  # search for sites containing "Aardvark"
  expect_error(search_buffer(335792, 501379, "Aardvark"))
})
