library(devtools)

create_package("c:/Work/Git/uklakes")

use_r("get_lake_info")


usethis::use_package("rvest")
usethis::use_package("tidyr")
usethis::use_package("polite")
usethis::use_package("rnrfa")
usethis::use_package("xml2")
usethis::use_package("dplyr")


# Read into lake_ids and store internally
lake_ids <- read.csv(file.choose())
usethis::use_data(lake_ids, internal = TRUE)

# testing functions
search_test <- search_names("Lomond")
search_test

search_test <- search_names("Tarn")
search_test

test_info3 <- get_lake_info(7)

#str(test_info3)

details <- colnames(test_info3)

details

tester <- details[22]
tester

test_info <- get_lake_info(5, 7, 9)

test_info <- get_lake_info(search_test$lakeid)



#' Get a summary of available information about a lake or lakes from the
#' UK CEH Lakes Portal
#' @description Produces a summary of available information about a lake or
#' lakes from the UK CEH Lakes Portal by responsibly webscraping lake
#' information pages.
#'#
#' @param ... A lake id number or series of lake id numbers to be searched.
#' Individual values should be separated by commas. R-type sequences can also
#' be passed in e.g. 34:48, or alternatively a vector of values or df column.
#' See examples.
#'#'
#' @return A data frame containing the available information about the specified
#' lake or lakes. The 'Biology' information on the Lakes Portal webpages is not
#' included, but all other information is provided. For details of the
#' information provided, see the UK CEH Lake Portal website
#' (\url{https://uklakes.ceh.ac.uk/}.)
#'
#' @export get_lake_info
#'
#' @examples
#' # get information for Loch Katrine and Loch Lomond
#' get_lake_info (24447, 24531)
#'
#' # get lake information for a set of lakes including a sequence
#' get_lake_info(4, 5, 6, 34:37)
#'
#' # can also pass in the lakeid column from the output of search_names
#' tarn_list <- search_names("Tarn)
#' get_lake_info(tarn_list$lakeid)
#'
