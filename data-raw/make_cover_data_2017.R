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
  group_by(species, site, plot) %>% 
  filter( row_number(total) == which.max(total)) # take the max of the two rounds of cover per subplot 

cover <- 
  cover %>% 
  ungroup() %>% 
  left_join(sedgwick_plants %>% 
              bind_rows(read_csv('data-raw/cover_2017/special_names.csv')) %>% 
              select(calflora_binomial, USDA_symbol), by = c('species' = 'calflora_binomial')) %>% 
  select( site, plot, USDA_symbol, total, LL, UR )

cover <- 
  expand.grid( USDA_symbol = unique( cover$USDA_symbol ), 
             site = unique( cover$site ), 
             plot = unique( cover$plot ) ) %>% 
  left_join(cover) %>% 
  mutate( total = ifelse( is.na( total ), 0, total )) 

site_cover_2017 <- 
  cover %>% 
  group_by( site, USDA_symbol ) %>% 
  summarise( n_plots = sum( total > 0 ), 
             avg_cover = mean(total),
             sd_cover = sd( total )) %>% 
  mutate( area_cm2 = 5*(25*25), 
          year = 2017) %>% 
  select( year, site, area_cm2, USDA_symbol, n_plots, sd_cover, avg_cover)
  
### **NOTE** I'm reversing plot order in lower sites to match the plot order used 
### in the 2019 sampling.  That is plots go from lowest plot to upper plot, except 
## Nebraska (762) which is flat. 

plot_cover_2017 <- 
  cover %>% 
  ungroup() %>% 
  rename( 'cover' = total) %>% 
  mutate( area_cm2 = 25*25, 
          LL = ifelse( cover == 0 , 0, LL), 
          UR = ifelse( cover == 0 , 0, UR ), 
          year = 2017) %>% 
  mutate( plot = ifelse( (site > 755) & site != 762, 6 - plot, plot )) %>% ### Reverse order of plots in lower sites 
  select( year, site, plot, area_cm2, USDA_symbol, cover, LL, UR )

subplot_cover_2017 <- 
  plot_cover_2017 %>% 
  ungroup() %>% 
  select( year, site, plot, LL, UR, USDA_symbol ) %>%
  gather( subplot, cover, LL, UR) %>% 
  mutate( area_cm2 = 10*10) %>% 
  mutate( plot = ifelse( (site > 755) & site != 762, 6 - plot, plot )) %>% ### Reverse order of plots in lower sites 
  select( year, site, plot, subplot, area_cm2, USDA_symbol, cover) 
  
# Check that all species are in the species list ------------------- # 
site_cover_2017[!site_cover_2017$USDA_symbol %in% sedgwick_plants$USDA_symbol , ] %>% ungroup() %>% distinct(USDA_symbol)
plot_cover_2017[!plot_cover_2017$USDA_symbol %in% sedgwick_plants$USDA_symbol , ] %>% ungroup() %>% distinct(USDA_symbol)
subplot_cover_2017[!subplot_cover_2017$USDA_symbol %in% sedgwick_plants$USDA_symbol,   ]%>% ungroup() %>% distinct(USDA_symbol)
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
