### Server code for the year to date tab
lower_ci <- function(mean, se, n, conf_level = 0.95) {
  lower_ci <- mean - qt(1 - ((1 - conf_level) / 2), n - 1) * se
}
upper_ci <- function(mean, se, n, conf_level = 0.95) {
  upper_ci <- mean + qt(1 - ((1 - conf_level) / 2), n - 1) * se
}


# Reactive dataset for baseline average
ytd_baseline <- reactive({
  d <- hist_data %>%
    dplyr::filter(between(year, input$sel_ytd_baseline[1], input$sel_ytd_baseline[2])) %>%
    group_by(yday) %>%
    summarize(baseline_avg = mean(get(temp_col), na.rm = T),
              baseline_sd = sd(get(temp_col), na.rm = T), n = n()) %>%
    ungroup() %>%
    mutate(baseline_se = baseline_sd/sqrt(n),
           baseline_lower_ci = lower_ci(baseline_avg, baseline_se, n),
           baseline_upper_ci = upper_ci(baseline_avg, baseline_se, n),
           # Shift yday relative to the current YTD year
           date = (yday-1) + min(ytd_daily()$date)) %>%
    dplyr::filter(date <= max(ytd_daily()$date))
})


# Output plot
output$ytd_plot <- renderPlot({
  p <- ggplot(ytd_baseline(), aes(x = date)) + 
    geom_ribbon(aes(ymin = baseline_lower_ci, ymax = baseline_upper_ci), fill = 'lightgrey') +
    geom_line(aes(y = baseline_avg), color = 'black', linetype = 2) +
    geom_line(data = ytd_daily(), aes(x = date, y = sea_surface_temp_avg_c)) +
    geom_point(data = ytd_daily(), aes(x = date, y = sea_surface_temp_avg_c)) +
    ylab("Sea Surface Temperature (C)") +
    xlab("Date")
  print(p)
}, height = 700)