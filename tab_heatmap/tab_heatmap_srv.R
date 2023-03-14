### Server code for the heatmap tab

# Start out with baseline selector hidden
shinyjs::hide('div_heatmap_baseline')
# React to button presses to show/hide baseline years selector
observeEvent(input$heatmap_var, {
  if (input$heatmap_var == 'Actual') {
    shinyjs::hide('div_heatmap_baseline')
  } else {
    shinyjs::show('div_heatmap_baseline')
  }
})

# Reactive dataset for baseline average
baseline_avg <- reactive({
  d <- hist_data %>%
    dplyr::filter(between(year, input$sel_baseline[1], input$sel_baseline[2])) %>%
    group_by(yday) %>%
    summarize(baseline_avg = mean(sea_surface_temp_avg_c, na.rm = T)) %>%
    ungroup()
})

baseline_change <- reactive({
  d <- hist_data %>%
    left_join(baseline_avg(), by = 'yday') %>%
    mutate(baseline_diff = sea_surface_temp_avg_c - baseline_avg)
})


# Output plot
output$heatmap_plot <- renderPlot({
  if (input$heatmap_var == 'Actual') {
    p <- ggplot(data = hist_data, aes(x = mday, y = year, fill = sea_surface_temp_avg_c)) +
      geom_tile(color= "white") + 
      scale_fill_viridis(name = 'Temp', option = 'C') +
      facet_wrap(~month, nrow = 1) +
      labs(y = 'Year') +
      theme(axis.title.x = element_blank(),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            legend.position = 'bottom')
    print(p)
  } else if (input$heatmap_var == 'Change from Baseline') {
    p <- ggplot(data = baseline_change(), aes(x = mday, y = year, fill = baseline_diff)) +
      geom_tile(color= "white") + 
      geom_hline(yintercept = input$sel_baseline[2]) +
      geom_hline(yintercept = input$sel_baseline[1]) +
      scale_fill_viridis(name = 'Deg Difference\nfrom baseline', option = 'C') +
      facet_wrap(~month, nrow = 1) +
      labs(y = 'Year', title = glue('Difference from {input$sel_baseline[1]}-{input$sel_baseline[2]} Baseline')) +
      theme(axis.title.x = element_blank(),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            legend.position = 'bottom')
    print(p)
  }
}, height = 700)