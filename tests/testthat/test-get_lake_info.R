# get_lake_info tests

test_that("get_lake_info for a single lake returns a dataframe with one row", {
  # retrieve data for specific waterbody
  test_single_lake<-get_lake_info(24447)
  # check that it outputs a dataframe with one row
  expect_equal(nrow(test_single_lake), 1)
})

test_that("get_lake_info for a range of lakes returns a dataframe of right size", {
  # retrieve data for a range of lakes
  test_range_lake<-get_lake_info(24444:24446)
  # check that it outputs a dataframe of the expected size (3x16)
  expect_true(all(dim(test_range_lake)== c(3, 16)))
})

test_that("invalid input returns an error", {
  # retrieve data for lake wbid "Aardvark"
  expect_error(get_lake_info("Aardvark"))
})

test_that("blank input returns a message", {
  # try and retrieve info for blank input
  expect_error(get_lake_info())
})
