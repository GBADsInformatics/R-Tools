# Creation info -----------------------------------------------
#########################################################
# Creator: Kassy Raymond
# Email: kraymond@uoguelph.ca
# GBADs theme: Informatics
# Date of creation: 2021-11-02
# Date last edited: 2021-11-02

# Description: 
# Functions to access GBADs Public API 
# More information about the API can be found at http://gbadske.org:9000/dataportal/
#########################################################

# 0 - Install and load packages -----------------------------------------------
library(RCurl)
library(httr)


# 1 - Functions -----------------------------------------------
get_all_tables <- function() {
  # Base URL
  all_tables_url = "http://gbadske.org:9000/GBADsTables/public?format=text"
  
  # Get data to download 
  download <- getURL(all_tables_url)
  
  # Read table
  data <- read.csv(text = download)
  
  return(data)
}

livestock_population <- function(year, country, species, source, destfile = 'output.csv') {
# Get livestock population numbers from gbads api
  
  if(source != 'oie' | source != 'faostat') stop("Specify either oie or faostat as source")
  
  base_url = "http://gbadske.org:9000/GBADsLivestockPopulation/"
  
  # Add the year, country and species 
  url_full = paste(base_url, source, "?year=", year, "&country=", country, "&species=", species, "&format=file", sep='')

  # Download file
  download.file(url_full, destfile=destfile, method="libcurl")
  
  # Read file
  data <- read.csv(destfile)
  
  # Return data
  return(data)
}

# 2 - Get data  -----------------------------------------------
tables <- get_all_tables()

data <- livestock_population('2017', 'Canada', '*', 'oie')
