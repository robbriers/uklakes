#' Search database of site names
#' @description Searches the listing of UK CEH Lakes Portal sites to find names
#' that contain the string provided.
#'
#' The search is done on an internal copy of the UK lakes listing rather than
#' connecting to the UKCEH Lakes Portal site.
#
#' @param string The search string to be matched (case-sensitive). Will match
#' whole or partial strings in the column values.
#'#'
#' @return A data frame containing the details (Name & wbid) of all the sites
#' that match the search string (full or partial matches).
#'
#' @export search_lakes
#'
#' @examples
#' # search for sites containing "Tarn" in the name
#' search_lakes("Tarn")
#'
search_lakes <- function(string = NULL) {
  # extract list of rows that match search string
  matching_rows <- lake_ids[grep(string, lake_ids$Name), ]
  if (nrow(matching_rows) == 0) {
    stop(paste0("No matches found for ", string))
  }
  else {
    rownames(matching_rows) <- NULL
    return(matching_rows)
  }
} # end of function
