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
    p <- ggplot(yearly_dataset(), aes(x = year, y = avg_temp)) + 
      geom_line() +
      geom_point() +
      geom_smooth(method = 'lm', color = "blue") +
      ylab(ylab_title) +
      xlab("Year")
    print(p)
  } else if (input$ts_groupby == 'Month') {
    p <- ggplot(monthly_dataset(), aes(x = year, y = avg_temp)) + 
      geom_line() +
      geom_point() +
      facet_wrap(~month, nrow = 4) +
      geom_smooth(method = 'lm', color = "blue") +
      ylab(ylab_title) +
      xlab("Year")
    print(p)
  } else if (input$ts_groupby == 'Oceanic Season') {
    p <- ggplot(ocean_season_dataset(), aes(x = ocean_year, y = avg_temp)) + 
      geom_line() +
      geom_point() +
      facet_wrap(~ocean_season, nrow = 2) +
      geom_smooth(method = 'lm', color = "blue") +
      ylab(ylab_title) +
      xlab("Ocean Year")
    print(p)
  } else if (input$ts_groupby == 'Meteorological Season') {
    p <- ggplot(met_season_dataset(), aes(x = met_year, y = avg_temp)) + 
      geom_line() +
      geom_point() +
      facet_wrap(~met_season, nrow = 2) +
      geom_smooth(method = 'lm', color = "blue") +
      ylab(ylab_title) +
      xlab("Meteorological Year")
    print(p)
  } else if (input$ts_groupby == 'Astronomical Season') {
    p <- ggplot(astro_season_dataset(), aes(x = astro_year, y = avg_temp)) + 
      geom_line() +
      geom_point() +
      facet_wrap(~astro_season, nrow = 2) +
      geom_smooth(method = 'lm', color = "blue") +
      ylab(ylab_title) +
      xlab("Astronomical Year")
    print(p)
  }
}, height = 700)