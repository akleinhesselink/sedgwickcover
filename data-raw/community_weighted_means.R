rm(list = ls())
library(tidyverse)
library(sedgwicktraits)
library(sedgwickspecies)
library(vegan)

load('~/Dropbox/projects/Sedgwick_cover_data/cover.data')

avg_cover <- 
  avg_cover %>% 
  gather(calflora_binomial, cover,  -plot ) %>% 
  left_join(
    sedgwick_plants %>% 
      distinct(calflora_binomial, USDA_symbol)
  ) %>% 
  select( plot, USDA_symbol, cover)

cwms <- 
  avg_cover %>% 
  left_join(sedgwicktraits) %>% 
  gather( trait, value, -plot, -USDA_symbol, -cover, -notes, -dataset, -seed_mass_data_source, -max_height_data_source) %>% 
  group_by( plot, trait ) %>% 
  summarise( value = mean( cover*value, na.rm = T )) 

cwms %>% 
  ggplot( aes( x = plot, y = value)) + 
  geom_point() + 
  facet_wrap(~trait, scales = 'free') 

 
cwms <- cwms %>% 
  spread( trait, value) 

cwms_pca <- 
  cwms %>% 
  ungroup() %>% 
  select(`LAR(cm2/g)`, `leaf_size(cm2)`, `LDMC(mg/g)`, `SLA (g/cm2)`, `max_height(cm)`, `seed_mass(g)`, `phenology (DOY 50% fruit)`) %>% 
  princomp()

biplot(cwms_pca)

View(sedgwicktraits)


