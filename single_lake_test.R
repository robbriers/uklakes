# run single lake for testing

lakes <- c(28911)
lakes <- c(4)

i <- 1
# create empty df for combined lake information
output_df <- data.frame(X1=character(), X2=character(), lakeid=double())

# introduce scraper to host, using base url
url <- "https://uklakes.ceh.ac.uk/detail.html"
session <- polite::bow(url)

# now do the scraping based on input values in vector 'lakes'
  message("Scraping lake ID ", lakes[i])

  # scrape page source
  lake_page <- polite::scrape(session, query=list(wbid=lakes[i]), verbose=FALSE)
  #lake_page <- polite::scrape(session, query=list(wbid=24447), verbose=FALSE)

  # extract waterbody name
  wb_name <- rvest::html_text2(rvest::html_element(lake_page, "h1"))

  # remove secondary info from name
  wb_name <- substring(wb_name, 0, regexpr('\n', wb_name)-1)

  # extract all tables for reference
  all_tables <- rvest::html_table(lake_page)

  # extract typology table
  typology <- all_tables[3] # typology

  # delete typology table from rest of list
  all_tables[3] <- NULL

  test1 <- dplyr::bind_rows(all_tables[1])
  test2 <- dplyr::bind_rows(all_tables[2])
  test3 <- dplyr::bind_rows(all_tables[3])
  test4 <- dplyr::bind_rows(all_tables[4])

  # check for marl water body information in the chemistry information
  chemistry <- dplyr::bind_rows(all_tables[3])
  all_tables[3] <- NULL

    # if there is chemistry information then check for marl lakes
  if(nrow(chemistry)>0){
    chemistry$X2[grepl("Marl water", chemistry$X1, ignore.case = TRUE)] <- "TRUE"
    # bind chemistry with the rest of tables and remove units
    combined_tables <- dplyr::bind_rows(all_tables, chemistry)
  }

  combined_tables$X2 <- sub(" .*", "", combined_tables$X2)

  # now add classification info back on
  combined_tables <- dplyr::bind_rows(combined_tables, typology)

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
  combined_tables$Lakeid <- lakes[i]

  # now combine with output df before looping to the next one
  output_df <- rbind(output_df, combined_tables)

# wrangle final output

names(output_df) <- c("parameter", "value", "Lakeid")

# reshape data to wide format
wide_table <- tidyr::pivot_wider(output_df, names_from = parameter, values_from = value, id_cols=Lakeid)

