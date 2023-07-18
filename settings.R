### Maine Landings Portal Settings

# Title to display at top of app
app_title <- "BBH Pier Portal"

# local path/URL to a Markdown or HTML file to render on the about page
about_file_path <- "https://raw.githubusercontent.com/mainedmr/bbh_pier_portal/main/about.md"

# URLs to data feeds
url_ytd <- 'https://prod-29.usgovtexas.logic.azure.us/workflows/bbe90999c52443738eafe52e44138563/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=gMokmfMpBnvLcwunBl3XdJdGXhwwtEz42-jH7VZo_YA'
url_hist <- 'https://opendata.arcgis.com/datasets/5fd6f3e57d794a409d72f47d78f15a32_0.csv'

# These objects define the date and temp column names in the incoming data - 
# the objects are used when referencing the columns in the app, such that if
# column names are modified in the incoming data, they only modified ONCE here
date_col = "collection_date"
temp_col = "sea_surface_temp_avg_c"

# Number of seconds to cycle tabs if enabled
tab_cycle_rate <- 15

# Plot height and width for different screens
gbl_plot_height <- 800
gbl_plot_width <- 1024

# Global ggplot2 themes
theme_set(
  theme(
  plot.title = element_text(
    face = "bold", 
    size = 20, 
    hjust = 0.5
  ),
  plot.subtitle = element_text(
    size = 16,
    hjust = 0.5
  ),
  axis.title = element_text(
    face = "bold", 
    size = 14
  ),
  axis.text = element_text(
    size = 12
  ),
  strip.text = element_text(
    size = 16)
  )
)

