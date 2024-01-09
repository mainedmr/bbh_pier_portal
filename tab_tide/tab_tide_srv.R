### Server code for the tide tab

# Every hour refresh the YTD data
tide_data_live <- reactivePoll(1000, NULL,
  # This returns a new value every 6 minutes, at which point there should be
  # new tide data to pull
  checkFunc = function() {
    return(floor(lubridate::minute(lubridate::now())/6))
  },
  # Update data from hohonu
  valueFunc = function() {
    message('Updating tidal data from Hohonu.')
    max_tide_dt <- max(tide_data$datetime)
    new_tide_data <- hohonu_data(hohonu_api_key, hohonu_station, hohonu_date(max_tide_dt), hohonu_date(lubridate::now()))
    monotonic <- data.frame(datetime = seq(min(new_tide_data$datetime), max(new_tide_data$datetime), by = '6 min'))
    all_tide_data <- monotonic %>%
      # Left join data and then fill in gaps
      left_join(new_tide_data, by = 'datetime') %>%
      mutate(datetime_est = with_tz(datetime, tzone = Sys.timezone()),
             datetime_str = strftime(datetime, format = '%m/%d/%Y %H:%M'),
             height_filled = zoo::na.approx(height, na.rm = F),
             navd_m = height_filled * 0.3048) %>%
      # Now add existing tide data
      rbind(tide_data) %>%
      arrange(datetime)
    # Calculate tidal prediction model for the loaded data
    # Build sealevel model
    datsl <- as.sealevel(elevation = all_tide_data$navd_m, time = all_tide_data$datetime)
    tidal_model <- tidem(t = datsl)
    # Add tide predictions to observed data
    all_tide_data$navd_m_predicted <- predict(tidal_model)
    return(all_tide_data)
  }
)

# Get the tidal offset for the chosen datum
tide_datum_offset <- reactive({
  tidal_datums %>%
    dplyr::filter(datum == input$tide_datum) %>%
    pull(offset)
})


# Filter tide data based on datetime range and datum selected
tide_sel_data <- reactive({
  tide_data_live() %>%
    dplyr::filter(between(as.Date(datetime_est), input$tide_dates[1], input$tide_dates[2])) %>%
    mutate(tide_height = navd_m + tide_datum_offset(), 
           tide_prediction = navd_m_predicted + tide_datum_offset()) 
})

# Reactive to calculate the ebb/flood times for the selected tidal date range
tide_stage_times <- reactive({
  tide2 <- tide_sel_data() %>%
    mutate(ebb_flood = ifelse(navd_m_predicted < lead(navd_m_predicted), 'Flood', 'Ebb'))
  
  start_stage <- tide2$ebb_flood[1]
  
  tide2$stage <- ifelse(tide2$ebb_flood != lag(tide2$ebb_flood), tide2$ebb_flood, NA)
  tide2$stage[1] <- start_stage
  
  last_time <- max(tide2$datetime_est)
  
  tide2 %>%
    dplyr::filter(!is.na(stage)) %>%
    mutate(stage_start = datetime_est, stage_end = lead(datetime_est, default = last_time)) %>%
    dplyr::select(stage, stage_start, stage_end)
})


# Output plot
output$tide_plot <- plotly::renderPlotly({
  p <- ggplot() +
    #geom_rect(data = tide_stage_times(),
    #          aes(xmin = stage_start, xmax = stage_end,
    #              ymin = -Inf, ymax = Inf, fill = stage), alpha = 0.5) +
    geom_line(data = tide_sel_data(), aes(x = datetime_est, y = tide_height), color = 'blue') +
    geom_line(data = tide_sel_data(), aes(x = datetime_est, y = tide_prediction), color = 'purple') +
    #geom_vline(xintercept = lubridate::now(), color = 'black') +
    labs(y = 'Tide Height', x = 'Datetime (EST)')
  plotly::ggplotly(p)
})