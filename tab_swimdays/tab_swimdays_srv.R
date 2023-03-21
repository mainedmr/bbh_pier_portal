### Server code for the swimdays tab

# Filter data based on swimming threshold
swimdays_dataset <- reactive({
  hist_data %>%
    mutate(is_above = get(temp_column()) > input$sel_swim_thresh) %>%
    group_by(year, is_above) %>%
    summarize(days = n()) %>%
    ungroup() %>%
    dplyr::filter(is_above == T)
})

observeEvent(input$temp_is_c, {
  current_value <- input$sel_swim_thresh
  if (input$temp_is_c) {
    # Celsius
    updateSliderInput(inputId = 'sel_swim_thresh',
                      label = glue("Select minimum swimming temperature ({temp_label()}):"),
                      min = 0, max = 26, value = f2c(current_value))
  } else {
    # Fahrenheit
    updateSliderInput(inputId = 'sel_swim_thresh',
                      label = glue("Select minimum swimming temperature ({temp_label()}):"),
                      min = 32, max = 80, value = c2f(current_value))
  }
})


# Output plot
output$swimdays_plot <- renderPlot({
  p <- ggplot(swimdays_dataset(), aes(y = days, x = year)) +
    geom_col(color = 'darkgrey', fill = 'darkblue') +
    xlim(year_min, year_max) +
    labs(y = 'Swimmable Days', x = 'Year')
  print(p)
}, height = gbl_plot_height)