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

test_info2 <- get_lake_info(7)

test_info <- get_lake_info(5, 7, 9)

test_info <- get_lake_info(search_test$lakeid)



#' Get a summary of available information about a lake or lakes from the
#' UK CEH Lakes Portal
#' @description Produces a summary of available information about a lake or
#' lakes from the UK CEH Lakes Portal by responsibly webscraping lake
#' information pages.
#'#
#' @param ... A series of lake id numbers to searched. Can use ranges etc.
#'#'
#' @return A data frame containing the available information about the specified
#' lake or lakes. The 'Biology' information on the Lakes Portal webpages is not
#' included, but all other information is provided.
#'
#' @export get_lake_info
#'
#' @examples
#' # get information for Loch Katrine and Loch Lomond
#' get_lake_info (24447, 24531)
#'
#' # can also
