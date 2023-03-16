library(shiny)
library(shinyjs)
library(shinyWidgets)
library(shinydashboardPlus)
library(tidyverse)
library(ggplot2)
library(gganimate)
library(scales)
library(viridis)
library(gifski)
library(markdown)
#library(ggvis)
library(glue)
#library(DT)
#library(uuid)
#library(RColorBrewer)
#library(scales)

# Source functions file
source("functions.R")

# Base url to the GitHub repo with data and settings
base_url <- "https://github.com/mainedmr/bbh_pier_portal/raw/master/"

# These objects define the date and temp column names in the incoming data - 
# the objects are used when referencing the columns in the app, such that if
# column names are modified in the incoming data, they only modified ONCE here
date_col = "collection_date"
temp_col = "sea_surface_temp_avg_c"

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


hist_data <- get_hist_data() %>%
  mutate(year = year(get(date_col)),
         month = month(get(date_col), label = T),
         month_num = month(get(date_col)),
         yday = yday(get(date_col)),
         mday = mday(get(date_col)),
         ocean_season = ocean_season(month_num),
         ocean_year = ocean_year(month_num, year),
         met_season = met_season(month_num),
         met_year = met_year(month_num, year),
         astro_season = astro_season(month_num),
         astro_year = astro_year(month_num, year))

# Get yearly averages
yearly_avg <- hist_data %>%
  # Remove NAs
  filter(!is.na(get(temp_col))) %>%
  # Group by year
  group_by(year) %>%
  # Summarise by avg of temperature and record count
  summarise(avg_temp = mean(get(temp_col)), samples = n()) %>%
  ungroup() %>%
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
  ungroup() %>%
  # Remove months with less than 28 days sampled
  filter(samples > 27)

# Avg per oceanic season
ocean_season_avg <- hist_data %>% 
  # Remove NAs
  filter(!is.na(get(temp_col))) %>%
  # Group by year and month
  group_by(ocean_year, ocean_season) %>%
  # Summarise by avg of temperature and record count
  summarise(avg_temp = mean(get(temp_col)), samples = n()) %>%
  ungroup() %>%
  # Remove seasons with < 3 months sampled
  filter(samples > 85)

met_season_avg <- hist_data %>%
  # Remove NAs
  filter(!is.na(get(temp_col))) %>%
  # Group by year and month
  group_by(met_year, met_season) %>%
  # Summarise by avg of temperature and record count
  summarise(avg_temp = mean(get(temp_col)), samples = n()) %>%
  ungroup() %>%
  # Remove seasons with < 3 months sampled
  filter(samples > 85)

astro_season_avg <- hist_data %>%
  # Remove NAs
  filter(!is.na(get(temp_col))) %>%
  # Group by year and month
  group_by(astro_year, astro_season) %>%
  # Summarise by avg of temperature and record count
  summarise(avg_temp = mean(get(temp_col)), samples = n()) %>%
  ungroup() %>%
  # Remove seasons with < 3 months sampled
  filter(samples > 85)


year_col <- 'year'

# Get min and max date for the entire data range
year_min <- min(yearly_avg$year)
year_max <- max(yearly_avg$year)



# Source settings
#devtools::source_url(paste0(base_url, "settings.R"))
source('settings.R')

# Source text for tabs
source('tab_text.R')

# Source queries
#devtools::source_url(paste0(base_url, "queries.R"))

# Set global table options
#options(DT.options = gbl_dt_options)


# Groups to show when historic landings are selected
vars_hist_groups = c('None' = 'none',
                     'Species' = 'species')

# Source UI subfiles for each tab
source('tab_ts/tab_ts_ui.R')
source('tab_heatmap/tab_heatmap_ui.R')
source('tab_line_anim/tab_line_anim_ui.R')
source('tab_spiral_anim/tab_spiral_anim_ui.R')
source('tab_swimdays/tab_swimdays_ui.R')

# Source UI subfiles for controls
#for (ui in list.files('controls_ui', full.names = T)) {source(ui)}

# Only render this once!
# Animated line plot of yearly temperature stacked
line_anim_plot <- monthly_avg %>%
  ggplot(aes(x = month, y = avg_temp, group = year, color = year)) +
  geom_line(linewidth = 1) +
  scale_color_viridis() +
  #geom_hline(data = max_yet, aes(yintercept = max_yet, group = year)) +
  #geom_line(data = monthly_avg[monthly_avg$year > 2010,], color = 'red') +
  labs(x = 'Month', y = 'Mean Temperature (C)', color = 'Year') +
  # gganimate
  transition_manual(year, cumulative = T) +
  enter_fade() +
  labs(title = 'BBH Pier Mean Monthly Temperature Temperature: 1905-{current_frame}')

line_anim_plot2 <- animate(line_anim_plot, duration = 12,
                           start_pause = 5, end_pause = 30, 
                           height = gbl_plot_height, width = gbl_plot_width)
anim_save('line_plot.gif', line_anim_plot2)

### Make spiral animation as global object
source('./tab_spiral_anim/make_spiral_anim.R')
spiral_anim_plot <- make_spiral_plot()
anim_save('spiral_plot.gif', spiral_anim_plot)
