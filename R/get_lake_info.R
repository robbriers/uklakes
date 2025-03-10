
get_lake_info <- function(...) {

  # capture arguments as a list
  lakelist <- list(...)

  # initialize an empty numeric vector for lake ids
  lakes <- c()

  # loop through each element in lakelist
  for (item in lakelist) {
    if (is.numeric(item)) {
      # if the item is numeric, add it directly
      lakes <- c(lakes, item)
    }
  }

  # create empty df for combined lake information
  output_df <- data.frame(X1=character(), X2=character(), lakeid=double())

  # introduce scraper to host, using base url
  url <- "https://uklakes.ceh.ac.uk/detail.html"
  session <- polite::bow(url)

  # now do the scraping based on input values in vector 'lakes'
  for (i in 1:length(lakes)) {
    message("Scraping lake ID ", lakes[i])

    # scrape page source
    lake_page <- polite::scrape(session, query=list(wbid=lakes[i]), verbose=FALSE)
    lake_page <- polite::scrape(session, query=list(wbid=24447), verbose=FALSE)

    # extract waterbody name
    wb_name <- rvest::html_text2(rvest::html_element(lake_page, "h1"))

    # remove secondary info from name
    wb_name <- substring(wb_name, 0, regexpr('\n', wb_name)-1)

    # extract all tables for reference
    all_tables <- rvest::html_table(lake_page)

    # extract classif table
    classif <- all_tables[3]

    # delete classif table from rest of list
    all_tables[3] <- NULL

    # bind rest of tables and remove units
    combined_tables <- dplyr::bind_rows(all_tables)
    combined_tables$X2 <- sub(" .*", "", combined_tables$X2)

    # now add classification info back on
    combined_tables <- dplyr::bind_rows(combined_tables, classif)

    # remove extra columns if biology table is present
    if (ncol(combined_tables)>2){
      combined_tables <- combined_tables[1:2]
    }
#

    # might have to add _ to some before doing this
    #combined_tables$X1 <- sub("^(.*)\\s+[^\\s]+$", "\\1", combined_tables$X1)  # Remove everything after the last space
    #combined_tables$X1 <- gsub("\\s+", "_", combined_tables$X1)
    # remove trailing [?] parts from values
    #combined_tables$X1 <- sub("\\[.*", "", combined_tables$X1)

    # these were original and other way around - then just remove trailing _

    # remove trailing [?] parts from values
    combined_tables$X1 <- sub("\\[.*", "", combined_tables$X1)


    # remove spaces from variable names to make it easier
    combined_tables$X1 <- gsub(" ", "_", combined_tables$X1)


    #combined_tables

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
    combined_tables$Lakeid <- lakes[i]

    # now combine with output df before looping to the next one
    output_df <- rbind(output_df, combined_tables)

  } # this is the end of the main for

  # wrangle final output

  names(output_df) <- c("parameter", "value", "Lakeid")

  # reshape data to wide format
  wide_table <- tidyr::pivot_wider(output_df, names_from = parameter, values_from = value, id_cols=Lakeid)

  # reorder variables to something more sensible
#  wide_table <- wide_table[, c("Lakeid", "Name", setdiff(names(wide_table), c("Lakeid", "Name")))]

  #str(test_info)

  # Reorder column by name manually
  #new_order = c("emp_id","name","superior_emp_id","dept_id","dept_branch_id")
  #df2 <- df[, new_order]


#  wide_table <- wide_table[, c("Lakeid", "Name", "Grid_reference",
#                               "Elevation_type", "Size_type", "Depth_type",
#                               "Geology_type", "Humic_type",
#                               setdiff(names(wide_table), c("Lakeid", "Name",
#                                                            "Grid_reference",
#                                                            "Elevation_type",
#                                                            "Size_type",
#                                                            "Depth_type",
#                                                            "Geology_type",
 #                                                           "Humic_type")))]


  # change variable types in table
#  wide_table$lakeid <- as.integer(wide_table$lakeid)
#  wide_table[]
#  wide_table <- across(wide_table)
#  mutate_at(2:3, ~ as.numeric(.))

  # columns to shift to the left
 # cols_to_left <- c("Lakeid", "Name", "Grid_reference", "Elevation_type", "Size_type", "Depth_type", "Geology_type", "Humic_type")

#  wide_table <- wide_table[, c(cols_to_left, setdiff(names(wide_table), cols_to_left))]


  # STILL TO DO ------------------------------------------------
  # convert appropriate columns to numeric and reorder columns
  # move name, GR and typology columns to left and then convert the rest
  # ------------------------------------------------------------

  return(wide_table)
} # end of function
