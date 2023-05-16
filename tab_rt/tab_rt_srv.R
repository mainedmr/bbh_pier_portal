### Server code for the time series tab

# Latest sensor values
current_conditions <- reactive({
  ytd() %>%
    slice_max(datetime)
})

# Baseline for averages over plot of last weeks conditions
# TODO

# Get last week's hourly data from ytd()
last_week <- reactive({
  one_week_ago <- with_tz(Sys.time(), 'EST') - days(7)
  ytd() %>%
    dplyr::filter(datetime > one_week_ago)
})

# Columns from YTD data for dropdown
ytd_cols <- reactive({
  col_names <- ytd() %>%
    dplyr::select(-starts_with('datetime')) %>%
    colnames()
  names(col_names) <- snakecase::to_title_case(col_names) %>%
    replace(., list = c(which(. == 'Temp f'), which(. == 'Temp c')), 
            values = c('Sea Surface Temp F', 'Sea Surface Temp C'))
  print(col_names)
  return(col_names)
})

# Render field dropdown from colnames
output$ui_rt_field <- renderUI({
  selectizeInput('sel_rt_field', 'Select plot field',
                 choices = ytd_cols(), selected = 'temp_f')
})


# Output plot
output$rt_weekly <- plotly::renderPlotly({
  p <- ggplot(data = last_week(), aes(x = datetime, y = !!sym(input$sel_rt_field))) +
    geom_line() +
    geom_point() +
    scale_x_datetime(date_labels = '%b-%d-%Y', date_breaks = '24 hours') +
    labs(x = 'Date/Time', y = get_var_name(ytd_cols(), input$sel_rt_field))
  plotly::ggplotly(p)
})

# Render value boxes for current conditions
output$val_time <- renderValueBox({
  valueBox(
    subtitle = 'Update Time',
    value = current_conditions()$datetime_char,
    icon = icon('clock')
  )
})
output$val_sst <- renderValueBox({
  valueBox(
    subtitle = glue('Sea Surface Temp ({temp_label()})'),
    value = current_conditions()[[temp_column()]],
    icon = icon('water')
  )
})
output$val_air_temp <- renderValueBox({
  valueBox(
    subtitle = glue('Air Temp ({temp_label()})'),
    value = ifelse(input$temp_is_c, current_conditions()$air_temp_c, current_conditions()$air_temp_f),
    icon = icon('temperature-full')
  )
})
output$val_pressure <- renderValueBox({
  valueBox(
    subtitle = 'Pressure (mbar)',
    value = current_conditions()$bp_avg_mb,
    icon = icon('wind')
  )
})
output$val_rh <- renderValueBox({
  valueBox(
    subtitle = 'Relative Humidity (%)',
    value = current_conditions()$rh,
    icon = icon('percent')
  )
})

# Render current conditions in the header
output$header_text <- renderText({
  update_time <- current_conditions()$datetime_char
  sst_f <- round(current_conditions()$temp_f, 2)
  sst_c <- round(current_conditions()$temp_c, 2)
  air_temp_f <- round(current_conditions()$air_temp_f, 2)
  air_temp_c <- round(current_conditions()$air_temp_c, 2)
  air_press <- round(current_conditions()$bp_avg_mb, 2)
  rh <- round(current_conditions()$rh, 2)
  
  glue('<h4 align="center"><b>Last Update: {update_time} - Sea Surface Temp: {sst_f}F/{sst_c}C \
        - Air Temp: {air_temp_f}F/{air_temp_c}C<br>Air Pressure: {air_press}mb \
       - Relative Humidity: {rh}%</b></h4>')
  
})
