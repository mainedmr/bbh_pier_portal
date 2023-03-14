library(shiny)
library(shinyjs)
library(glue)

shinyServer(function(input, output, session) {
  ## -------------------------------------------------------------------------
  ## About panel
  ## -------------------------------------------------------------------------
  # Render about panel from file
  output$about_page <- renderUI({
    # For Markdown files
    if (endsWith(about_file_path, ".md")) {
      return(includeMarkdown(about_file_path))
    }
    # For HTML files
    if (endsWith(about_file_path, ".html")) {
      return(includeHTML(about_file_path))
    }
    else {
      h5("Could not load about file...")
    }
  })
  ## -------------------------------------------------------------------------
  ## Time Series panel
  ## -------------------------------------------------------------------------
  source('tab_ts/tab_ts_srv.R', local = T)
  ## -------------------------------------------------------------------------
  ## Heatmap panel
  ## -------------------------------------------------------------------------
  source('tab_heatmap/tab_heatmap_srv.R', local = T)
}) # End shinyServer