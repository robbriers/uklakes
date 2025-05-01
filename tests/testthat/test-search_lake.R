test_that("dimensions of search_lake dataframe are as expected", {
  # search for sites containing "Tarn" in their name
  test_search_tarn <- search_lake("Tarn")
  # check that the dimensions are 140 rows, 2 cols
  expect_true(all(dim(test_search_tarn) == c(140, 5)))
})

test_that("invalid lake name returns an error", {
  # search for sites containing "Aardvark"
  expect_error(search_lake("Aardvark"))
})
