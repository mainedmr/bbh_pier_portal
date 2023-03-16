### Server code for the swimdays tab

# Filter data based on swimming threshold
swimdays_dataset <- reactive({
  hist_data %>%
    mutate(temp_f = get(temp_col)*9/5 + 32,
           is_above = temp_f > input$sel_swim_thresh) %>%
    group_by(year, is_above) %>%
    summarize(days = n()) %>%
    ungroup() %>%
    dplyr::filter(is_above == T)
})

# Output plot
output$swimdays_plot <- renderPlot({
  p <- ggplot(swimdays_dataset(), aes(y = days, x = year)) +
    geom_col(color = 'darkgrey', fill = 'darkblue') +
    xlim(year_min, year_max) +
    labs(y = 'Swimmable Days', x = 'Year')
  print(p)
}, height = gbl_plot_height)