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
         astro_year = astro_year(month_num, year)) %>%
  mutate(temp_c = get(temp_col),
         temp_f = c2f(temp_c))

# Get monthly averages
monthly_avg <- hist_data %>%
  # Remove NAs
  filter(!is.na(get(temp_col))) %>%
  # Group by year and month
  group_by(year, month) %>%
  # Summarise by avg of temperature and record count
  summarise(avg_temp_c = mean(get(temp_col)), samples = n()) %>%
  ungroup() %>%
  # Remove months with less than 28 days sampled
  filter(samples > 27) %>%
  mutate(avg_temp_f = c2f(avg_temp_c))


line_anim_plot_c <- monthly_avg %>%
  ggplot(aes(x = month, y = avg_temp_c, group = year, color = year)) +
  geom_line(linewidth = 1) +
  scale_color_viridis() +
  #geom_hline(data = max_yet, aes(yintercept = max_yet, group = year)) +
  #geom_line(data = monthly_avg[monthly_avg$year > 2010,], color = 'red') +
  labs(x = 'Month', y = 'Mean Temperature (C)', color = 'Year') +
  # gganimate
  transition_manual(year, cumulative = T) +
  enter_fade() +
  labs(title = 'BBH Pier Mean Monthly Temperature Temperature: 1905-{current_frame}')

line_anim_plot_c_anim <- animate(line_anim_plot_c, duration = 12,
                           start_pause = 5, end_pause = 30,
                           height = gbl_plot_height, width = gbl_plot_width)

anim_save('line_plot_c.gif', line_anim_plot_c_anim)

line_anim_plot_f <- monthly_avg %>%
  ggplot(aes(x = month, y = avg_temp_f, group = year, color = year)) +
  geom_line(linewidth = 1) +
  scale_color_viridis() +
  #geom_hline(data = max_yet, aes(yintercept = max_yet, group = year)) +
  #geom_line(data = monthly_avg[monthly_avg$year > 2010,], color = 'red') +
  labs(x = 'Month', y = 'Mean Temperature (F)', color = 'Year') +
  # gganimate
  transition_manual(year, cumulative = T) +
  enter_fade() +
  labs(title = 'BBH Pier Mean Monthly Temperature Temperature: 1905-{current_frame}')

line_anim_plot_f_anim <- animate(line_anim_plot_f, duration = 12,
                                 start_pause = 5, end_pause = 30,
                                 height = gbl_plot_height, width = gbl_plot_width)

anim_save('line_plot_f.gif', line_anim_plot_f_anim)


### Make spiral animation as global object
source('./tab_spiral_anim/make_spiral_anim.R')
spiral_anim_plot_c <- make_spiral_plot_c()
anim_save('spiral_plot_c.gif', spiral_anim_plot_c)

spiral_anim_plot_f <- make_spiral_plot_f()
anim_save('spiral_plot_f.gif', spiral_anim_plot_f)
