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
  names(col_names) <- snakecase::to_title_case(col_names)
  return(col_names)
})

# Render field dropdown from colnames
output$ui_rt_field <- renderUI({
  selectizeInput('sel_rt_field', 'Select plot field',
                 choices = ytd_cols(), selected = 'sea_surface_temp_avg_c')
})


# Output plot
output$rt_weekly <- renderPlot({
  ggplot(data = last_week(), aes(x = datetime, y = !!sym(input$sel_rt_field))) +
    geom_line() +
    geom_point() +
    scale_x_datetime(date_labels = '%b-%d-%Y', date_breaks = '24 hours') +
    labs(x = 'Date/Time', y = get_var_name(ytd_cols(), input$sel_rt_field))
}, height = gbl_plot_height)

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
    subtitle = 'Sea Surface Temp (C)',
    value = current_conditions()$sea_surface_temp_avg_c,
    icon = icon('water')
  )
})
output$val_air_temp <- renderValueBox({
  valueBox(
    subtitle = 'Air Temp (C)',
    value = current_conditions()$air_temp_avg_c,
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