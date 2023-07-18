library(shiny)
library(shinyjs)
library(glue)

shinyServer(function(input, output, session) {
  # Cycle through active tab
  active <- reactiveValues(tab = 1)
  
  observe({
    # Change every X secs
    invalidateLater(tab_cycle_rate * 1000, session)
    # Update tab if toggle on
    isolate(active$tab <- active$tab%%length(tabnames) + 1)
    if (input$cycle) {
      updateTabItems(session,'tab_panel',tabnames[active$tab])
    }
  })
  
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
      get_ytd_data() %>%
        mutate(temp_c = get(temp_col), temp_f = c2f(get(temp_col)),
               air_temp_c = air_temp_avg_c, air_temp_f = c2f(air_temp_avg_c)) %>%
        dplyr::select(-sea_surface_temp_avg_c, -air_temp_avg_c) %>%
        dplyr::select(temp_f, temp_c, air_temp_f, air_temp_c, everything())
    }
  )
  
  ytd_daily <- reactive({
    ytd() %>%
      mutate(date = as.Date(datetime)) %>%
      group_by(date) %>%
      summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE))) %>%
      ungroup()
  })
  
  temp_label <- reactive({
    ifelse(input$temp_is_c, 'C', 'F')
  })
  
  temp_column <- reactive({
    ifelse(input$temp_is_c, 'temp_c', 'temp_f')
  })
  
  
  # Session-wide boolean for swim slider bumped
  swim_bumped <- F
  # React when tab is changed
  observeEvent(input$tab_panel, { 
    if (input$tab_panel == "swimdays" & !swim_bumped) {
      # Update to default value at app start
      if (input$temp_is_c) {
        updateSliderInput(inputId = 'sel_swim_thresh',
                          label = glue("Select minimum swimming temperature ({temp_label()}):"),
                          min = 0, max = 26, value = f2c(60))
      } else {
        updateSliderInput(inputId = 'sel_swim_thresh',
                          label = glue("Select minimum swimming temperature ({temp_label()}):"),
                          min = 32, max = 80, value = 60)
      }
      swim_bumped <<- T
    }
  })
  
  ## -------------------------------------------------------------------------
  ## Realtime data panel
  ## -------------------------------------------------------------------------
  source('tab_rt/tab_rt_srv.R', local = T)
  ## -------------------------------------------------------------------------
  ## Year to date data panel
  ## -------------------------------------------------------------------------
  source('tab_ytd/tab_ytd_srv.R', local = T)
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