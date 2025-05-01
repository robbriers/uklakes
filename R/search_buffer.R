#' Search database of for lakes within a set buffer distance of a point
#' @description Searches the listing of UK CEH Lakes Portal lake sites to find
#' lakes that are within a specified buffer distance from the point given.
#'
#' Coordinates are specified as British National Grid X and Y and are checked
#' to ensure that they are within the required ranges.
#
#' @param xcoord The x coordinate, in British National Grid, of the point to
#' base the buffer on.
#'
#' @param ycoord The y coordinate, in British National Grid, of the point to
#' base the buffer on.
#'
#' @param buffer_distance The buffer distance (radius) to be searched around
#' the point in metres.
#'
#' @return A data frame containing the details (Name, wbid, Country) of all
#' the lakes that are within the specified buffer distance of the point as well
#' as the distance (in metres) from each lake to the point.
#'
#' @export search_buffer
#'
#' @examples
#' # search for sites within 1km of the point 315231, 642134
#' search_buffer(335792, 501379, 2000)
#'

search_buffer <- function(xcoord, ycoord, buffer_distance){

  # need to set up lake_ids x and y coordinates as well as Country

  # initial checking of input - should all be numeric
  if(!is.numeric(buffer_distance)){
    stop("Non-numeric buffer distance specified")
  }
  if(!is.numeric(xcoord) | !is.numeric(ycoord)){
    stop("Non-numeric point coordinates specified")
  }

  # min and max coordinate checking
  if(xcoord<0 | ycoord<0 | xcoord>700000 | ycoord >1300000){
    stop("Point coordinates are outside British National Grid bounds")
  }

  # Compute the Euclidean distance of all sites from point specified
  distances <- sqrt((lake_ids$Easting - xcoord)^2 + (lake_ids$Northing - ycoord)^2)

  # Filter rows within the buffer distance
  result <- lake_ids[distances <= buffer_distance, ]

  # remove NI lakes (no Easting or Northings)
  result <- result[!is.na(result$Easting), ]

  # Drop the coordinates columns before returning
   result$Easting <- NULL
   result$Northing <-NULL

  return(result)
}
