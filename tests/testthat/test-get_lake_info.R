# get_lake_info tests

test_that("get_lake_info for a single lake returns a dataframe with one row", {
  skip_if_offline()
  # retrieve data for specific waterbody (with Marl status)
  test_single_lake <- get_lake_info(28911)
  # check that it outputs a dataframe with one row
  expect_equal(nrow(test_single_lake), 1)
})

test_that("get_lake_info for a range of lakes returns right size dataframe", {
  skip_if_offline()
    # retrieve data for a range of lakes
  test_range_lake <- get_lake_info(24445:24447)
  # check that it outputs a dataframe of the expected size (3x35)
  expect_true(all(dim(test_range_lake) == c(3, 35)))
})

test_that("string input returns an error", {
  # retrieve data for lake wbid "Aardvark"
  expect_error(get_lake_info("Aardvark"))
})

test_that("blank input returns an error", {
  # retrieve data for blank lake wbid
  expect_error(get_lake_info())
})

test_that("non-integer numeric input returns an error", {
  # retrieve data for real numeric lake wbid
  expect_error(get_lake_info(5.53))
})

test_that("lake from NI does not have a grid reference column", {
  skip_if_offline()
    # retrieve data for a NI lake wbid
  test_NI_lake <- get_lake_info(50018)
  # check to see if 'Grid_reference' column is in output
  column_exists <- "Grid_reference" %in% colnames(test_NI_lake)
  expect_false(column_exists)
})
