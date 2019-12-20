rm(list = ls())
library(tidyverse)
library(sedgwickspecies)

load('data/plot_cover_2017.rda')
load('data/plot_cover_2019.rda')

plot_cover_2019 <- 
  plot_cover_2019 %>% 
  filter( USDA_symbol != 'gopher')

total_cover <- 
  plot_cover_2017 %>% 
  group_by(year, site, plot) %>% 
  summarise( total_cover = sum(cover)) %>% 
  bind_rows(
    plot_cover_2019 %>% 
      filter( USDA_symbol != 'gopher') %>% 
      group_by(year, site, plot) %>%
      summarise( total_cover = sum(cover))) 

total_cover %>% 
  ggplot( aes( x = plot, y = total_cover, color = factor(year), group = factor( year))) +
  geom_line() + 
  geom_point() + 
  facet_wrap(~site) +
  scale_color_manual(values = c("#132B43","#56B1F7"))

plot_cover_2019 %>% 
  arrange( desc(cover ))

plot_cover_2017 %>% 
  rename('cover_2017' = cover) %>% 
  select( site, plot, USDA_symbol, cover_2017 ) %>% 
  left_join(plot_cover_2019  %>% rename('cover_2019' = cover)) %>% 
  select( site, plot, USDA_symbol, cover_2017, cover_2019) %>% 
  filter( !is.na(cover_2019)) %>% 
  mutate( cov_diff = cover_2019 - cover_2017) %>% 
  arrange( desc(cov_diff))

plot_cover_2017 %>% 
  rename('cover_2017' = cover) %>% 
  select( site, plot, USDA_symbol, cover_2017 ) %>% 
  group_by( site, USDA_symbol) %>%
  mutate( sum_cover = sum(cover_2017)) %>% 
  group_by( site) %>% 
  filter( USDA_symbol==USDA_symbol[ which.max(sum_cover)]) %>% 
  left_join(plot_cover_2019  %>% rename('cover_2019' = cover)) %>% 
  select( site, plot, USDA_symbol, cover_2017, cover_2019) %>% 
  gather( year, cover, starts_with('cover')) %>% 
  ggplot( aes( x = plot, y = sqrt(cover), color = year)) + 
  geom_point() + 
  geom_line() + 
  facet_wrap(~site) + 
  scale_color_manual(values = c("#132B43","#56B1F7"))

dplyr::setdiff(plot_cover_2017$USDA_symbol, plot_cover_2019$USDA_symbol)
dplyr::setdiff(plot_cover_2019$USDA_symbol, plot_cover_2017$USDA_symbol)


# 

bind_rows(plot_cover_2017, plot_cover_2019) %>% 
  left_join(sedgwick_plants, by = 'USDA_symbol') %>% 
  filter(life_history == 'Perennial') %>% 
  group_by( year, site, plot ) %>% 
  summarise( per_cover = sum( cover )) %>% 
  ggplot( aes( x = plot, y = sqrt(per_cover), color = factor(year))) + 
  geom_point() + 
  geom_line() + 
  facet_wrap(~site) + 
  scale_color_manual(values = c("#132B43","#56B1F7"))


