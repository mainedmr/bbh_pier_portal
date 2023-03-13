### Server code for the time series tab
# Filter yearly data based on slider
yearly_dataset <- reactive({
  d <- yearly_avg %>%
    dplyr::filter(between(year, input$sel_years[1], input$sel_years[2]))
})

monthly_dataset <- reactive({
  d <- monthly_avg %>%
    dplyr::filter(between(year, input$sel_years[1], input$sel_years[2]))
})

# Output plot
output$ts_plot <- renderPlot({
  if (input$ts_groupby == 'None') {
    p <- ggplot(yearly_dataset(), aes(x = year, y = avg_temp)) + 
      geom_line() +
      geom_point() +
      geom_smooth(method='lm', color = "blue") +
      ylab("Average Sea Surface Temperature (C)") +
      xlab("Year")
    print(p)
  } else if (input$ts_groupby == 'Month') {
    p <- ggplot(monthly_dataset(), aes(x = year, y = avg_temp)) + 
      geom_line() +
      geom_point() +
      facet_wrap(~month, nrow = 4) +
      geom_smooth(method='lm', color = "blue") +
      ylab("Average Sea Surface Temperature (C)") +
      xlab("Year")
    print(p)
  } else if (input$ts_groupby == 'Season') {
    
  }
}, height = 700)