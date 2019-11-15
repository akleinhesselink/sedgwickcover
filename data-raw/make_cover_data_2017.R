rm(list = ls())
library(tidyverse)
library(sedgwickspecies)

cover1 <- read.csv( 'data-raw/cover_2017/2017_first_round_cover_data.csv')
cover2 <- read.csv('data-raw/cover_2017/2017_second_round_cover_data.csv')
cover1$round <- 'early'
cover2$round <- 'late'  

cover <- rbind(cover1, cover2)
cover[ is.na(cover)] <- 0

cover <- 
  cover %>% 
  rename( subplot = plot , plot = site )

cover <- 
  cover %>% 
  group_by(species, plot , subplot ) %>% 
  filter( row_number(total) == which.max(total)) # take the max of the two rounds of cover per subplot 

cover <- 
  cover %>% 
  left_join(sedgwick_plants %>% 
              bind_rows(read_csv('data-raw/cover_2017/special_names.csv')) %>% 
              select(calflora_binomial, USDA_symbol), by = c('species' = 'calflora_binomial'))

site_cover_2017 <- 
  cover %>% 
  group_by(plot, USDA_symbol) %>% 
  rename( 'site' = plot) %>% 
  summarise(cover = mean(total)) %>% 
  mutate( year = 2017, area_cm2 = 5*55*55) %>% 
  select( year, site, area_cm2, USDA_symbol, cover )

plot_cover_2017 <- 
  cover %>% 
  ungroup() %>%
  select(plot, subplot, USDA_symbol, total ) %>% 
  rename( 'cover' = total, 
          'site' = plot, 
          'plot' = subplot)  %>% 
  mutate( year = 2017, area_cm2 = 25*25 ) %>% 
  select( year, site, plot, area_cm2, USDA_symbol, cover )

subplot_cover_2017 <- 
  cover %>% 
  ungroup() %>% 
  select( plot, subplot, LL, UR, species, USDA_symbol ) %>%
  gather( microplot, cover, LL, UR) %>%
  rename( 'site' = plot) %>% 
  rename( 'plot' = subplot ) %>% 
  rename( 'subplot' = microplot )  %>% 
  mutate( year = 2017, area_cm2 = 10*10) %>% 
  select( year, site, plot, subplot, area_cm2, USDA_symbol, cover) 
  
# Check that all species are in the species list ------------------- # 
site_cover_2017[!site_cover_2017$USDA_symbol %in% sedgwick_plants$USDA_symbol , ] 
plot_cover_2017[!plot_cover_2017$USDA_symbol %in% sedgwick_plants$USDA_symbol , ] 
subplot_cover_2017[!subplot_cover_2017$USDA_symbol %in% sedgwick_plants$USDA_symbol,   ]
# ------------------------------------------------------------------- # 

usethis::use_data(site_cover_2017, overwrite = T)
usethis::use_data(plot_cover_2017, overwrite = T)
usethis::use_data(subplot_cover_2017, overwrite = T)


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
