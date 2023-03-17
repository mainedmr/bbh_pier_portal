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
  # Every hour refresh the YTD data
  ytd <- reactivePoll(1000, NULL,
    # This returns a value based on the current hour, 5 minutes past hour
    # So at 5 minutes past the hour, the returned value changes and invalidates
    # the valueFunc, causing the data to be refreshed
    checkFunc = function() {
      hour <- lubridate::hour(Sys.time())
      min <- lubridate::minute(Sys.time())
      if (min > 3)
        return(hour)
      else
        return(hour-1)
    },
    # Update data from PowerAutomate CSV URL
    valueFunc = function() {
      message('Updating YTD hourly data from PowerAutomate.')
      get_ytd_data()
    }
  )
  
  ## -------------------------------------------------------------------------
  ## Realtime data panel
  ## -------------------------------------------------------------------------
  source('tab_rt/tab_rt_srv.R', local = T)
  ## -------------------------------------------------------------------------
  ## Time Series panel
  ## -------------------------------------------------------------------------
  source('tab_ts/tab_ts_srv.R', local = T)
  ## -------------------------------------------------------------------------
  ## Heatmap panel
  ## -------------------------------------------------------------------------
  source('tab_heatmap/tab_heatmap_srv.R', local = T)
  ## -------------------------------------------------------------------------
  ## Line animation panel
  ## -------------------------------------------------------------------------
  source('tab_line_anim/tab_line_anim_srv.R', local = T)
  ## -------------------------------------------------------------------------
  ## Spiral animation panel
  ## -------------------------------------------------------------------------
  source('tab_spiral_anim/tab_spiral_anim_srv.R', local = T)
  ## -------------------------------------------------------------------------
  ## Swimdays tab panel
  ## -------------------------------------------------------------------------
  source('tab_swimdays/tab_swimdays_srv.R', local = T)
}) # End shinyServer