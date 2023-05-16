### Server code for the time series tab
# Filter yearly data based on slider
yearly_dataset <- reactive({
  d <- yearly_avg %>%
    dplyr::filter(between(year, input$sel_years[1], input$sel_years[2])) %>%
    # Convert to F
    {if (!input$temp_is_c) {
      mutate(., avg_temp = c2f(avg_temp))
    } else {.}}
})

monthly_dataset <- reactive({
  d <- monthly_avg %>%
    dplyr::filter(between(year, input$sel_years[1], input$sel_years[2])) %>%
    # Convert to F
    {if (!input$temp_is_c) {
      mutate(., avg_temp = c2f(avg_temp))
    } else {.}}
})

ocean_season_dataset <- reactive({
  d <- ocean_season_avg %>%
    dplyr::filter(between(ocean_year, input$sel_years[1], input$sel_years[2]))%>%
    # Convert to F
    {if (!input$temp_is_c) {
      mutate(., avg_temp = c2f(avg_temp))
    } else {.}}
})

met_season_dataset <- reactive({
  d <- met_season_avg %>%
    dplyr::filter(between(met_year, input$sel_years[1], input$sel_years[2])) %>%
    # Convert to F
    {if (!input$temp_is_c) {
      mutate(., avg_temp = c2f(avg_temp))
    } else {.}}
})

astro_season_dataset <- reactive({
  d <- astro_season_avg %>%
    dplyr::filter(between(astro_year, input$sel_years[1], input$sel_years[2])) %>%
    # Convert to F
    {if (!input$temp_is_c) {
      mutate(., avg_temp = c2f(avg_temp))
    } else {.}}
})

# Output plot
output$ts_plot <- renderPlot({
  ylab_title <- glue('Average Sea Surface Temperature ({temp_label()})')
  
  if (input$ts_groupby == 'None') {
    slope_data <- yearly_dataset() %>%
      summarize(slope = summary(lm(avg_temp ~ year))$coefficients[2],
                x = mean(year, na.rm = T)) %>%
      mutate(label_text = paste0("Trend = ", round(slope, 2), temp_label(), ' per Year'))
    p <- ggplot(yearly_dataset(), aes(x = year, y = avg_temp)) + 
      geom_line() +
      geom_point() +
      geom_smooth(method = 'lm', color = "blue") +
      ylab(ylab_title) +
      xlab("Year") +
      geom_text(data = slope_data, aes(x = x, y = Inf, label = label_text),
                hjust = 1, vjust = 1, color = "black")
    print(p)
  } else if (input$ts_groupby == 'Month') {
    slope_data <- monthly_dataset() %>%
      group_by(month) %>%
      summarize(slope = summary(lm(avg_temp ~ year))$coefficients[2],
                x = mean(year, na.rm = T)) %>%
      mutate(label_text = paste0("Trend = ", round(slope, 2), temp_label(), ' per Year'))
    
    p <- ggplot(monthly_dataset(), aes(x = year, y = avg_temp)) + 
      geom_line() +
      geom_point() +
      facet_wrap(~month, nrow = 4) +
      geom_smooth(method = 'lm', color = "blue") +
      ylab(ylab_title) +
      xlab("Year") +
      geom_text(data = slope_data, aes(x = x, y = Inf, label = label_text),
                hjust = 1, vjust = 1, color = "black")
    print(p)
  } else if (input$ts_groupby == 'Oceanic Season') {
    slope_data <- ocean_season_dataset() %>%
      group_by(ocean_season) %>%
      summarize(slope = summary(lm(avg_temp ~ ocean_year))$coefficients[2],
                x = mean(ocean_year, na.rm = T)) %>%
      mutate(label_text = paste0("Trend = ", round(slope, 2), temp_label(), ' per Year'))
    
    p <- ggplot(ocean_season_dataset(), aes(x = ocean_year, y = avg_temp)) + 
      geom_line() +
      geom_point() +
      facet_wrap(~ocean_season, nrow = 2) +
      geom_smooth(method = 'lm', color = "blue") +
      ylab(ylab_title) +
      xlab("Ocean Year") +
      geom_text(data = slope_data, aes(x = x, y = Inf, label = label_text),
                hjust = 1, vjust = 1, color = "black")
    print(p)
  } else if (input$ts_groupby == 'Meteorological Season') {
    slope_data <- met_season_dataset() %>%
      group_by(met_season) %>%
      summarize(slope = summary(lm(avg_temp ~ met_year))$coefficients[2],
                x = mean(met_year, na.rm = T)) %>%
      mutate(label_text = paste0("Trend = ", round(slope, 2), temp_label(), ' per Year'))
    
    p <- ggplot(met_season_dataset(), aes(x = met_year, y = avg_temp)) + 
      geom_line() +
      geom_point() +
      facet_wrap(~met_season, nrow = 2) +
      geom_smooth(method = 'lm', color = "blue") +
      ylab(ylab_title) +
      xlab("Meteorological Year") +
      geom_text(data = slope_data, aes(x = x, y = Inf, label = label_text),
                hjust = 1, vjust = 1, color = "black")
    print(p)
  } else if (input$ts_groupby == 'Astronomical Season') {
    slope_data <- astro_season_dataset() %>%
      group_by(astro_season) %>%
      summarize(slope = summary(lm(avg_temp ~ astro_year))$coefficients[2],
                x = mean(astro_year, na.rm = T)) %>%
      mutate(label_text = paste0("Trend = ", round(slope, 2), temp_label(), ' per Year'))
    
    p <- ggplot(astro_season_dataset(), aes(x = astro_year, y = avg_temp)) + 
      geom_line() +
      geom_point() +
      facet_wrap(~astro_season, nrow = 2) +
      geom_smooth(method = 'lm', color = "blue") +
      ylab(ylab_title) +
      xlab("Astronomical Year") +
      geom_text(data = slope_data, aes(x = x, y = Inf, label = label_text),
                hjust = 1, vjust = 1, color = "black")
    print(p)
  }
}, height = 700)