make_spiral_plot_c <- function() {
  
next_jan <- monthly_avg %>%
  filter(month == "Jan") %>%
  mutate(year = year - 1,
         month = "next_Jan")

t_data <- bind_rows(monthly_avg, next_jan) %>%
  mutate(month = factor(month, levels = c(month.abb, "next_Jan")),
         month_number = as.numeric(month),
         # Point number for animate reveal
         pnt = 1:n())

annotation <- t_data %>%
  slice_max(year) %>%
  slice_max(month_number)

# Temp ticks 0-20 deg every 5
temp_ticks <- seq(0, 20, by = 5)

temp_lines <- tibble(
  x = 12,
  y = temp_ticks,
  labels = paste0(temp_ticks, '\u00B0C')
)

month_labels <- tibble(
  x = 1:12,
  labels = month.abb,
  y = 25
)

p <- t_data %>% 
  ggplot(aes(x = month_number, y = avg_temp_c, group = year, color = year)) +
  geom_col(data = month_labels, aes(x = x + 0.5, y = y), fill = "lightgrey",
           width  = 1,
           inherit.aes = FALSE) +
  geom_hline(yintercept = temp_ticks, color = "darkred") +
  geom_label(data = temp_lines, aes(x = x, y = y, label = labels),
             color = "darkred", fill = "lightgrey", label.size = 0,
             inherit.aes = FALSE) +
  geom_line(linewidth = 1) +
  # geom_point(data = annotation, aes(x = month_number, y = avg_temp, color = year),
  #            size = 2,
  #            inherit.aes = FALSE) +
  geom_text(data = month_labels, aes(x = x, y = y, label = labels),
            inherit.aes = FALSE, color = "black",
            angle = seq(360 - 360/12, 0, length.out = 12)) +
  scale_x_continuous(breaks = 1:12,
                     labels = month.abb, expand = c(0,0),
                     sec.axis = dup_axis(name = NULL, labels = NULL)) +
  scale_y_continuous(breaks = temp_ticks,
                     limits = c(-2, 25), expand = c(0, -0.7), 
                     sec.axis = dup_axis(name = NULL, labels = NULL)) +
  scale_color_viridis_c() +
  # coord_cartesian(xlim=c(1,12)) +
  coord_polar(start = 2*pi/12) +
  labs(x = NULL,
       y = NULL,
       title = 'BBH Pier Monthly Average 1905-{current_frame}',
       color = 'Year') +
  theme(
    #panel.background = element_rect(fill="#444444", size=1),
    #plot.background = element_rect(fill = "lightgrey", color="lightgrey"),
    panel.grid = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_text(color = "black", size = 13),
    plot.title = element_text(color = "black", hjust = 0.5, size = 15)
  ) +
  transition_manual(year, cumulative = T)

p <- animate(p, duration = 12, start_pause = 5, end_pause = 30, 
        height = min(c(gbl_plot_height, gbl_plot_width)), 
        width = min(c(gbl_plot_height, gbl_plot_width)))

return(p)
}


make_spiral_plot_f <- function() {
  
  next_jan <- monthly_avg %>%
    filter(month == "Jan") %>%
    mutate(year = year - 1,
           month = "next_Jan")
  
  t_data <- bind_rows(monthly_avg, next_jan) %>%
    mutate(month = factor(month, levels = c(month.abb, "next_Jan")),
           month_number = as.numeric(month),
           # Point number for animate reveal
           pnt = 1:n())
  
  annotation <- t_data %>%
    slice_max(year) %>%
    slice_max(month_number)
  
  # Temp ticks 30 deg every 5
  temp_ticks <- seq(30, 70, by = 10)
  
  temp_lines <- tibble(
    x = 12,
    y = temp_ticks,
    labels = paste0(temp_ticks, '\u00B0F')
  )
  
  month_labels <- tibble(
    x = 1:12,
    labels = month.abb,
    y = 75
  )
  
  p <- t_data %>% 
    ggplot(aes(x = month_number, y = avg_temp_f, group = year, color = year)) +
    geom_col(data = month_labels, aes(x = x + 0.5, y = y), fill = "darkgrey",
             width = 1,
             inherit.aes = FALSE) +
    geom_hline(yintercept = temp_ticks, color = "darkred") +
    geom_label(data = temp_lines, aes(x = x, y = y, label = labels),
               color = "darkred", fill = "lightgrey", label.size = 0,
               inherit.aes = FALSE) +
    geom_line(linewidth = 1) +
    # geom_point(data = annotation, aes(x = month_number, y = avg_temp, color = year),
    #            size = 2,
    #            inherit.aes = FALSE) +
    geom_text(data = month_labels, aes(x = x, y = y, label = labels),
              inherit.aes = FALSE, color = "black",
              angle = seq(360 - 360/12, 0, length.out = 12)) +
    scale_x_continuous(breaks = 1:12,
                       labels = month.abb, expand = c(0,0),
                       sec.axis = dup_axis(name = NULL, labels = NULL)) +
    scale_y_continuous(breaks = temp_ticks,
                       limits = c(30, 75), 
                       expand = c(0, -0.7), 
                       sec.axis = dup_axis(name = NULL, labels = NULL)) +
    scale_color_viridis_c() +
    # coord_cartesian(xlim=c(1,12)) +
    coord_polar(start = 2*pi/12) +
    labs(x = NULL,
         y = NULL,
         title = 'BBH Pier Monthly Average 1905-{current_frame}',
         color = 'Year') +
    theme(
      #panel.background = element_rect(fill="#444444", size=1),
      #plot.background = element_rect(fill = "lightgrey", color="lightgrey"),
      panel.grid = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.title.y = element_blank(),
      axis.ticks = element_blank(),
      axis.title = element_text(color = "black", size = 13),
      plot.title = element_text(color = "black", hjust = 0.5, size = 15)
    ) +
    transition_manual(year, cumulative = T)
  
  p <- animate(p, duration = 12, start_pause = 5, end_pause = 30, 
               height = min(c(gbl_plot_height, gbl_plot_width)), 
               width = min(c(gbl_plot_height, gbl_plot_width)))
  
  return(p)
}