data <- test %>%
  mutate(yday = yday(collection_date), year = year(collection_date),
         month = month(collection_date, label = T), mday = mday(collection_date))

ggplot(data = data, aes(x = mday, y = year, fill = sea_surface_temp_avg_c)) +
  geom_tile(color= "white") + 
  scale_fill_viridis(name = 'Temp', option = 'C') +
  facet_wrap(~month, nrow = 1) +
  labs(y = 'Year') +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

baseline <- data %>%
  dplyr::filter(between(year, 1991, 2020)) %>%
  group_by(yday) %>%
  summarize(baseline_avg = mean(sea_surface_temp_avg_c, na.rm = T)) %>%
  ungroup()

data_w_baseline <- data %>%
  left_join(baseline, by = 'yday') %>%
  mutate(baseline_diff = sea_surface_temp_avg_c - baseline_avg)

ggplot(data = data_w_baseline, aes(x = mday, y = year, fill = baseline_diff)) +
  geom_tile(color= "white") + 
  geom_hline(yintercept = 2020) +
  geom_hline(yintercept = 1991) +
  scale_fill_viridis(name = 'Deg Difference\nfrom baseline', option = 'C') +
  facet_wrap(~month, nrow = 1) +
  labs(y = 'Year', title = 'Difference from 1991-2020 Baseline') +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank())
