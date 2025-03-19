# get_lake_info tests
test_that("get_lake_info for a single lake returns a dataframe with one row", {
  # retrieve data for specific waterbody
  test_single_lake<-get_lake_info(24447)
  # check that it outputs a dataframe object
  expect_equal(nrow((test_single_lake), 1))
})
