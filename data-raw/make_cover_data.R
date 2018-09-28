rm(list = ls())
library(tidyverse)
library(sedgwickspecies)

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

site_cover <- 
  cover %>% 
  group_by(plot, species) %>% 
  rename( 'site' = plot) %>% 
  summarise( cover = mean(total))

subplot_cover <- 
  cover %>% 
  select(plot, subplot, species, total ) %>% 
  rename( 'cover' = total, 
          'site' = plot)  

microplot_cover <- 
  cover %>% 
  select( plot, subplot, LL, UR, species ) %>%
  gather( microplot, cover, LL, UR) %>%
  rename( 'site' = plot) %>% 
  select( site, subplot, microplot, species, cover )

devtools::use_data(site_cover, overwrite = T)
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
