library(shiny)
#library(shinyjs)
library(shinyWidgets)
library(shinydashboardPlus)
library(tidyverse)
library(ggplot2)
library(scales)
#library(ggvis)
library(glue)
#library(DT)
#library(uuid)
#library(RColorBrewer)
#library(scales)

# Base url to the GitHub repo with data and settings
base_url <- "https://github.com/mainedmr/bbh_pier_portal/raw/master/"

# Functions to retrieve current and historic data
# This returns one record per day, daily average
get_hist_data <- function() {
  # URL to Open Data item
  url <- "https://opendata.arcgis.com/datasets/5fd6f3e57d794a409d72f47d78f15a32_0.csv"
  # Read in data - use UTF-8-BOM encoding to avoid odd chars in col names
  temp_data <- read.csv(url, fileEncoding = "UTF-8-BOM") %>%
    janitor::clean_names()
  # Convert date column
  temp_data$collection_date <- as.Date(temp_data$collection_date)
  return(temp_data)
}

hist_data <- get_hist_data() %>%
  mutate(year = year(get(date_col)),
         month = month(get(date_col), label = T),
         yday = yday(get(date_col)),
         mday = mday(get(date_col)))

# These objects define the date and temp column names in the incoming data - 
# the objects are used when referencing the columns in the app, such that if
# column names are modified in the incoming data, they only modified ONCE here
date_col = "collection_date"
temp_col = "sea_surface_temp_avg_c"

# Get yearly averages
yearly_avg <- hist_data %>%
  # Remove NAs
  filter(!is.na(get(temp_col))) %>%
  # Group by year
  group_by(year) %>%
  # Summarise by avg of temperature and record count
  summarise(avg_temp = mean(get(temp_col)), samples = n()) %>%
  # Remove years with less than 350 days sampled
  filter(samples > 350)

# Get monthly averages
monthly_avg <- hist_data %>%
  # Remove NAs
  filter(!is.na(get(temp_col))) %>%
  # Group by year and month
  group_by(year, month) %>%
  # Summarise by avg of temperature and record count
  summarise(avg_temp = mean(get(temp_col)), samples = n()) %>%
  # Remove months with less than 28 days sampled
  filter(samples > 27)


year_col <- 'year'

# Get min and max date for the entire data range
year_min <- min(yearly_avg$year)
year_max <- max(yearly_avg$year)



# Source settings
#devtools::source_url(paste0(base_url, "settings.R"))
source('settings.R')

# Source functions file
source("functions.R")

# Source queries
#devtools::source_url(paste0(base_url, "queries.R"))

# Set global table options
#options(DT.options = gbl_dt_options)


# Groups to show when historic landings are selected
vars_hist_groups = c('None' = 'none',
                     'Species' = 'species')

# Source UI subfiles for each tab
source('tab_ts/tab_ts_ui.R')

# Source UI subfiles for controls
#for (ui in list.files('controls_ui', full.names = T)) {source(ui)}

