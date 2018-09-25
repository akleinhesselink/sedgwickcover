rm(list = ls())
library(tidyverse)

cover1 <- read.csv( 'data-raw/2017_first_round_cover_data.csv')
cover2 <- read.csv('data-raw/2017_second_round_cover_data.csv')
cover1$round <- 1
cover2$round <- 2 

cover <- rbind(cover1, cover2)
cover[ is.na(cover)] <- 0

cover <- 
  cover %>% 
  rename( subplot = plot , plot = site )

cover <- 
  cover %>% 
  group_by(species, plot , subplot ) %>% 
  filter( row_number(total) == which.max(total)) # take the max of the two rounds of cover per subplot 

plot_cover <- 
  cover %>% 
  group_by(plot, species) %>% 
  summarise( avg_cover = mean(total)) %>% 
  spread( species, avg_cover, fill = 0 )

subplot_cover <- 
  cover %>% 
  unite(subplot, plot, subplot, sep = '.') %>% 
  group_by( subplot, species ) %>% 
  select(subplot, species, total ) %>% 
  rename( 'cover' = total )  %>% 
  spread( species, cover, fill = 0 )

microplot_cover <- 
  cover %>% 
  select( plot, subplot, LL, UR, species ) %>%
  gather( microplot, cover, LL, UR) %>%
  unite( microplot ,  plot, subplot, microplot, sep = '.') %>% 
  spread(species, cover , fill = 0)

devtools::use_data(plot_cover, overwrite = T)
devtools::use_data(subplot_cover, overwrite = T)
devtools::use_data(microplot_cover, overwrite = T)



# subplot_counts <- 
#   cover %>% 
#   group_by( species ) %>% 
#   summarise( nsubplots = sum(total > 0 ) ) %>% 
#   ungroup() %>% 
#   arrange( desc(nsubplots))
# 
# plot_counts <-
#   cover %>% 
#   group_by( species , plot ) %>% 
#   summarise( avg = mean(total)) %>% 
#   group_by( species ) %>% 
#   summarise( nplots = sum(avg > 0)) %>% 
#   ungroup() %>% 
#   arrange( desc(nplots))
