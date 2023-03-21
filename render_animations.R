### Update animation GIFs for Portal
library(tidyverse)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

source('settings.R')
source('functions.R')

hist_data <- get_hist_data() %>%
  mutate(year = year(get(date_col)),
         month = month(get(date_col), label = T),
         month_num = month(get(date_col)),
         yday = yday(get(date_col)),
         mday = mday(get(date_col)),
         ocean_season = ocean_season(month_num),
         ocean_year = ocean_year(month_num, year),
         met_season = met_season(month_num),
         met_year = met_year(month_num, year),
         astro_season = astro_season(month_num),
         astro_year = astro_year(month_num, year))

# Get monthly averages
monthly_avg <- hist_data %>%
  # Remove NAs
  filter(!is.na(get(temp_col))) %>%
  # Group by year and month
  group_by(year, month) %>%
  # Summarise by avg of temperature and record count
  summarise(avg_temp = mean(get(temp_col)), samples = n()) %>%
  ungroup() %>%
  # Remove months with less than 28 days sampled
  filter(samples > 27)


line_anim_plot <- monthly_avg %>%
  ggplot(aes(x = month, y = avg_temp, group = year, color = year)) +
  geom_line(linewidth = 1) +
  scale_color_viridis() +
  #geom_hline(data = max_yet, aes(yintercept = max_yet, group = year)) +
  #geom_line(data = monthly_avg[monthly_avg$year > 2010,], color = 'red') +
  labs(x = 'Month', y = 'Mean Temperature (C)', color = 'Year') +
  # gganimate
  transition_manual(year, cumulative = T) +
  enter_fade() +
  labs(title = 'BBH Pier Mean Monthly Temperature Temperature: 1905-{current_frame}')

line_anim_plot2 <- animate(line_anim_plot, duration = 12,
                           start_pause = 5, end_pause = 30,
                           height = gbl_plot_height, width = gbl_plot_width)

anim_save('line_plot.gif', line_anim_plot2)

### Make spiral animation as global object
source('./tab_spiral_anim/make_spiral_anim.R')
spiral_anim_plot <- make_spiral_plot()
anim_save('spiral_plot.gif', spiral_anim_plot)
