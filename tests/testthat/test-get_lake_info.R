# get_lake_info tests

test_that("get_lake_info for a single lake returns a dataframe with one row", {
  # retrieve data for specific waterbody (with Marl status)
  test_single_lake<-get_lake_info(28911)
  # check that it outputs a dataframe object
  expect_equal(nrow(test_single_lake), 1)
})

test_that("get_lake_info for a range of lakes returns a dataframe of right size", {
  # retrieve data for specific waterbody
  test_range_lake<-get_lake_info(24445:24447)
  # check that it outputs a dataframe object
  expect_true(all(dim(test_range_lake)== c(3, 16)))
})

test_that("invalid input returns an error", {
  # retrieve data for lake wbid "Aardvark"
  expect_error(get_lake_info("Aardvark"))
})

test_that("blank input returns a message", {
  # retrieve data for blank lake wbid
  expect_error(get_lake_info())
})

test_that("lake from NI does not have a grid reference column", {
  # retrieve data for a NI lake wbid "Aardvark"
  test_NI_lake <- get_lake_info(50018)
  column_exists <- "Grid_reference" %in% colnames(test_NI_lake)
  expect_false(column_exists)
})
# add NI lake for completeness
