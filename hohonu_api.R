## Hohonu API calls
library(httr)
library(glue)
library(lubridate)

base_url <- "https://dashboard.hohonu.io/api/v1"

# Take a POSIXct datetime and format it for API in UTC
hohonu_date <- function(datetime) {
  utc <- with_tz(datetime, 'UTC')
  return(strftime(utc, '%Y-%m-%d %H:%M', tz = 'UTC'))
}

# Get data for a station. Dates in string API format.
hohonu_data <- function(key, station, from_date, to_date, datum = 'NAVD') {
  request_url <- glue('{base_url}/stations/{station}/statistic/?from={from_date}&to={to_date}&datum={datum}&cleaned=false&tz=0&format=json')
  
  req <- httr::GET(
    url = URLencode(request_url),
    add_headers(Authorization = key)
  )
  httr::stop_for_status(req)
  content <- httr::content(req)
  # Swap NA for NULLS in height so list can be collapsed to vector
  content$data[[2]][sapply(content$data[[2]], is.null)] <- NA
  
  data <- data.frame(datetime = unlist(content$data[[1]]), height = unlist(content$data[[2]]))
  data$datetime <- lubridate::ymd_hms(data$datetime)
  return(data)
}

# Get station info, includes installation date
hohonu_station_info <- function(key, station) {
  request_url <- glue('{base_url}/stations/{station}')
  
  req <- httr::GET(
    url = URLencode(request_url),
    add_headers(Authorization = key)
  )
  httr::stop_for_status(req)
  content <- httr::content(req)
}

# Get last update time for station in POSIXct format
hohonu_station_last_update <- function(key, station) {
  query_date <- strftime(lubridate::now(), '%Y-%m-%d %H:%M')
  request_url <- glue('{base_url}/stations/{station}/statistic/?from={query_date}&to={query_date}&datum=NAVD&cleaned=false&tz=0&format=json')
  
  req <- httr::GET(
    url = URLencode(request_url),
    add_headers(Authorization = key)
  )
  httr::stop_for_status(req)
  content <- httr::content(req)
  lubridate::ymd_hms(content$last_update)
}
