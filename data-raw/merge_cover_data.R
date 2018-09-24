rm(list = ls())
library(vegan)
library(dplyr)
library(tidyr)

env <- read.csv('~/Dropbox/Sedgwick/spatial_tapioca/data/environmental/all_environmental_data.csv')

cover1 <- read.csv( '~/Dropbox/Sedgwick/plot_data/2017_first_round_cover_data.csv')
cover2 <- read.csv('~/Dropbox/Sedgwick/plot_data/2017_second_round_cover_data.csv')
cover1$round <- 1
cover2$round <- 2 

cover <- rbind(cover1, cover2)
cover[ is.na(cover)] <- 0

cover <- 
  cover %>% 
  rename( subplot = plot , plot = site )

cover <- cover %>% group_by(species, plot , subplot ) %>% filter( row_number(total) == which.max(total)) # take the max of the two rounds of cover per subplot 

subplot_counts <- 
  cover %>% 
  group_by( species ) %>% 
  summarise( nsubplots = sum(total > 0 ) ) %>% 
  ungroup() %>% 
  arrange( desc(nsubplots))

plot_counts <-
  cover %>% 
  group_by( species , plot ) %>% 
  summarise( avg = mean(total)) %>% 
  group_by( species ) %>% 
  summarise( nplots = sum(avg > 0)) %>% 
  ungroup() %>% 
  arrange( desc(nplots))

cover <- 
  left_join(cover, subplot_counts ) %>% 
  filter(nsubplots > 3) # filter out species occuring in less than three subplots 

avg_cover <- 
  cover %>% 
  group_by(plot, species) %>% 
  summarise( avg_cover = mean(total) ) %>% 
  spread( species, avg_cover)

avg_cover[ is.na(avg_cover)] <- 0

save( cover, env, plot_counts, subplot_counts, avg_cover, file = 'cover.data' )

