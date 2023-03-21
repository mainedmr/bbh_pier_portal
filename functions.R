# Returns name of a named vector item vs its value
get_var_name <- function(vector, value) {
  names(vector)[match(value, vector)]
}

# Functions to retrieve current and historic data
# This returns one record per day, daily average
get_hist_data <- function() {
  # Read in data - use UTF-8-BOM encoding to avoid odd chars in col names
  temp_data <- read.csv(url_hist, fileEncoding = "UTF-8-BOM") %>%
    janitor::clean_names()
  # Convert date column
  temp_data$collection_date <- as.Date(temp_data$collection_date)
  temp_data <- temp_data %>%
    arrange(collection_date)
  return(temp_data)
}

get_ytd_data <- function() {
  read.csv(url_ytd) %>%
    mutate(datetime_char = datetime,
           datetime = mdy_hm(datetime_char, tz = 'EST'))
}

# Function for different ocean seasons
ocean_season <- function(month) {
  seasons <- c('Winter Storm (Dec-Feb)', 'Upwelling (Mar-Aug)', 
               'Oceanic (Sep-Nov)')
  x <- dplyr::case_when(
    month %in% c(12, 1, 2) ~ seasons[1],
    month %in% 3:8 ~ seasons[2],
    month %in% 9:11 ~ seasons[3]
  )
  x <- factor(x, levels = seasons)
  return(x)
}
ocean_year <- function(month, year) {
  dplyr::case_when(
    month == 12 ~ year + 1,
    month %in% 1:11 ~ year
  )
}
# https://www.ncei.noaa.gov/news/meteorological-versus-astronomical-seasons
met_season <- function(month) {
  seasons <- c('Winter (Dec-Feb)', 'Spring (Mar-May)', 
               'Summer (Jun-Aug)', 'Fall (Sep-Nov)')
  x <- dplyr::case_when(
    month %in% c(12, 1, 2) ~ seasons[1],
    month %in% 3:5 ~ seasons[2],
    month %in% 6:8 ~ seasons[3],
    month %in% 9:11 ~ seasons[4]
  )
  x <- factor(x, levels = seasons)
  return(x)
}
met_year <- function(month, year) {
  dplyr::case_when(
    month == 12 ~ year + 1,
    month %in% 1:11 ~ year
  )
}
astro_season <- function(month) {
  seasons <- c('Winter (Jan-Mar)', 'Spring (Apr-Jun)', 
               'Summer (Jul-Sep)', 'Fall (Oct-Dec)')
  x <- dplyr::case_when(
    month %in% 1:3 ~ seasons[1],
    month %in% 4:6 ~ seasons[2],
    month %in% 7:9 ~ seasons[3],
    month %in% 10:12 ~ seasons[4]
  )
  x <- factor(x, levels = seasons)
}
astro_year <- function(month, year) {
  return(year)
}

# Functions to convert between F and C
c2f <- function(x) {
  (x * 9/5) + 32
}

f2c <- function(x) {
  (x - 32) * 5/9
}
