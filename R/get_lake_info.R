#' Get a summary of available information about a lake or lakes from the
#' UK CEH Lakes Portal
#'
#' @description
#' Produces a summary of available information about a lake or
#' lakes from the UK CEH Lakes Portal by responsibly webscraping lake
#' information pages.
#'
#' @param ... A lake wbid number or series of lake wbid numbers to be searched.
#' Individual values should be separated by commas. R-type sequences can also
#' be passed in e.g. 34:48, or alternatively a vector of values or df column.
#' See examples.
#'
#' @return A data frame containing the available information about the specified
#' lake or lakes. The 'Biology' information on the Lakes Portal webpages is not
#' included, but all other information is provided. For details of the
#' information provided, see the UK CEH Lake Portal website
#' (\url{https://uklakes.ceh.ac.uk/}.)
#'
#' @export get_lake_info
#'
#' @examples
#' \dontrun{
#' # get information for Loch Lomond and Loch Katrine
#' get_lake_info(24447, 24531)
#'
#' # get lake information for a set of lakes including a sequence
#' get_lake_info(4, 5, 6, 34:37)
#'
#' # can also pass in the wbid column from the output of search_lakes
#' tarn_list <- search_lakes("Tarn")
#' # just retrieve the first 5 lakes
#' get_lake_info(tarn_list$wbid[1:5])
#' }
#'
get_lake_info <- function(...) {

  # capture arguments as a list
  lakelist <- list(...)

  # initialize an empty numeric vector for lake wbids and any bad input
  lakes <- c()
  bad_input <- c()

  # loop through each element in lakelist and check input
  for (item in lakelist) {
    if (is.numeric(item)) {
      # if the item is numeric, add it directly
      lakes <- c(lakes, item)
    } else {
      bad_input <- c(bad_input, item)
    }

    # if not all input is good then message and stop
    if(length(bad_input)>0){
      bad_input <- paste(bad_input, collapse = " ")
      stop(paste("Non-numeric input to function: ", bad_input), call.= FALSE)
    }
  }

  # if there are some lakes to process
  if(length(lakes)>0){

    # create empty df for combined lake information
    output_df <- data.frame(X1=character(), X2=character(), wbid=double())

    # introduce scraper to host, using base url
    url <- "https://uklakes.ceh.ac.uk/detail.html"
    session <- polite::bow(url)

    # now do the scraping based on input values in vector 'lakes'
    for (i in 1:length(lakes)) {
      message("Scraping lake wbid ", lakes[i])

      # scrape page source
      lake_page <- polite::scrape(session, query=list(wbid=lakes[i]), verbose=FALSE)


      # if scrape returns something then process

      if(!is.null(lake_page)){

        # extract waterbody name
        wb_name <- rvest::html_text2(rvest::html_element(lake_page, "h1"))

        # remove secondary info from name
        wb_name <- substring(wb_name, 0, regexpr('\n', wb_name)-1)

        # extract all tables for reference
        all_tables <- rvest::html_table(lake_page)

        # extract typology table
        typology <- do.call(rbind, all_tables[3])

        # delete typology table from rest of list
        all_tables[3] <- NULL

        # check for marl water body information in the chemistry information
        chemistry <- do.call(rbind, all_tables[3])

        all_tables[3] <- NULL

        # if there is chemistry information then check for marl lakes
        if(nrow(chemistry)>0){
          chemistry$X2[grepl("Marl water", chemistry$X1, ignore.case = TRUE)] <- "TRUE"
          # bind rest of tables and add chemistry if needed
          combined_tables <- do.call(rbind, all_tables)
          combined_tables <- do.call(rbind, list(combined_tables, chemistry))
        } else{
          combined_tables <- do.call(rbind, (all_tables))
        }

        # remove units from columns
        combined_tables$X2 <- sub(" .*", "", combined_tables$X2)

        # now add typology info back on
        combined_tables <- do.call(rbind, list(combined_tables, typology))

        # remove extra columns if biology table is present
        if (ncol(combined_tables)>2){
          combined_tables <- combined_tables[1:2]
        }

        # remove trailing [?] parts from values
        combined_tables$X1 <- sub("\\[.*", "", combined_tables$X1)

        # trim any non letters from the end of the strings
        combined_tables$X1 <- sub("[^a-zA-Z]+$", "", combined_tables$X1)

        # remove spaces from variable names to make it easier
        combined_tables$X1 <- gsub(" ", "_", combined_tables$X1)

        # if not NI lake, then derive Eastings and Northings and add to info
        if (lakes[i] < 50000){
          # derive actual coords
          coords <- rnrfa::osg_parse(combined_tables$X2[combined_tables$X1=="Grid_reference"])

          # create rows with name, x and y in
          new_headers <- c("Name", "Easting", "Northing")
          new_row <- c(wb_name, coords$easting, coords$northing)
          new_row <- cbind.data.frame(new_headers, new_row)
          colnames(new_row) <- c("X1", "X2")
        }
        # if NI lake, just add name row
        else{
          # create rows with just name
          new_headers <- c("Name")
          new_row <- wb_name
          new_row <- cbind.data.frame(new_headers, new_row)
          colnames(new_row) <- c("X1", "X2")
        }

        # bind on additional information
        combined_tables <- rbind(combined_tables, new_row)

        # add on lake id
        combined_tables$wbid <- lakes[i]

        # now combine with output df before looping to the next one
        output_df <- rbind(output_df, combined_tables)

      } # end of the if NULL bit

    } # this is the end of the main for

    # wrangle final output

    names(output_df) <- c("parameter", "value", "wbid")

    # reshape data to wide format
    wide_table <- as.data.frame(tidyr::pivot_wider(output_df, names_from = parameter, values_from = value, id_cols=wbid))

    # if marl lake status is present then add to columns on left of table
    if ("Marl_water_body" %in% colnames(wide_table)){
      left_cols <- c("wbid", "Name", "Grid_reference", "Easting", "Northing", "Elevation_type", "Size_type", "Depth_type", "Geology_type", "Humic_type", "Marl_water_body")
    } else {
      # alternative set if it is not present
      left_cols <- c("wbid", "Name", "Grid_reference", "Easting", "Northing", "Elevation_type", "Size_type", "Depth_type", "Geology_type", "Humic_type")
    }

    # define the remaining numeric columns
    right_cols <- setdiff(names(wide_table), left_cols)

    # reorder the columns
    wide_table <- wide_table[, c(left_cols, right_cols)]

    # convert data types, first numeric
    wide_table[c("wbid", "Easting", "Northing", right_cols)] <- lapply(wide_table[c("wbid", "Easting", "Northing", right_cols)], as.numeric)
    # then marl to a boolean if present
    if ("Marl_water_body" %in% colnames(wide_table)){
      wide_table$Marl_water_body<- as.logical(wide_table$Marl_water_body)
      wide_table$Marl_water_body[is.na(wide_table$Marl_water_body)] <- FALSE
    }

    return(as.data.frame(wide_table))
  } else {
    stop("No valid lake wbids provided to function")
  } # end of if there are any lakes
} # end of function
