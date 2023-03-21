library(shiny)
library(shinyjs)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(tidyverse)
library(ggplot2)
library(gganimate)
library(scales)
library(viridis)
library(gifski)
library(markdown)
library(devtools)
#library(ggvis)
library(glue)
#library(DT)
#library(uuid)
#library(RColorBrewer)
#library(scales)

# Base url to the GitHub repo with data and settings
base_url <- "https://github.com/mainedmr/bbh_pier_portal/raw/main/"

# # Download GIF animations from GitHub
# for (f in c('line_plot.gif', 'spiral_plot.gif')) {
#   download.file(paste0(base_url, f), f)
# }

# Source settings from GitHub
devtools::source_url(paste0(base_url, "settings.R"))
source('settings.R')

# Source functions file
source('functions.R')

# Source tab text from GH
devtools::source_url(paste0(base_url, "tab_text.R"))


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


# Source UI subfiles for each tab
source('tab_rt/tab_rt_ui.R')
source('tab_ytd/tab_ytd_ui.R')
source('tab_ts/tab_ts_ui.R')
source('tab_heatmap/tab_heatmap_ui.R')
source('tab_line_anim/tab_line_anim_ui.R')
source('tab_spiral_anim/tab_spiral_anim_ui.R')
source('tab_swimdays/tab_swimdays_ui.R')

