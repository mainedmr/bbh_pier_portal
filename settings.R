### Maine Landings Portal Settings

# Title to display at top of app
app_title <- "MaineDMR BBH Pier Portal"

# local path/URL to a Markdown or HTML file to render on the about page
about_file_path <- "https://raw.githubusercontent.com/mainedmr/Landings_Portal/master/about.md"

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

