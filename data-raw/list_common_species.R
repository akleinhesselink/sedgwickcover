library(dplyr, tidyr)
library(ggplot2)
rm(list = ls())

load('~/Dropbox/Sedgwick_cover_data/cover.data')

max_cover <- cover %>% 
  mutate( total = ifelse(is.na(total), 0 , total )) %>%
  group_by( species) %>% 
  summarise ( mx = max(total) ) %>% arrange( mx )

commonness <-  merge(plot_counts, max_cover) 

commonness <- commonness %>% arrange( desc(mx), desc(nplots))

write.csv(file = '~/Dropbox/Sedgwick_cover_data/species_commonness.csv', commonness,  row.names = F)

max_cover <- 
  cover %>% 
  group_by( species, plot ) %>% 
  filter( sum(nsubplots) == max(sum(nsubplots))) %>% 
  summarise(avg_cover = mean(total)) %>% 
  arrange( species, desc(avg_cover)) %>% 
  filter( row_number() < 3)

indicator_sp <- 
  cover %>% 
  group_by( species, plot ) %>% 
  filter( (species == 'Plantago erecta' & total > 0) | (species == 'Croton setigerus' & total > 0)) %>% 
  summarise( avg_cover = mean(total))

spp_phenology <- rbind(max_cover, indicator_sp) %>% select( species, plot, avg_cover) %>% distinct() 

write.csv(spp_phenology, '~/Dropbox/Sedgwick_cover_data/2018_phenology_sites.csv', row.names = F)

hts<- read.csv('~/Dropbox/2017-traits/2017-plant-heights.csv')
hts %>% group_by(species) %>% summarise(n())
