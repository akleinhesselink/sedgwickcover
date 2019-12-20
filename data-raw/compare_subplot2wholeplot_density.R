rm(list = ls())
library(tidyverse)
library(readxl)
library(sedgwickspecies)
library(lme4)
library(optimx)

my_path <-  'data-raw/cover_2019'
my_files <- dir(my_path, full.names = T, pattern = '*7[0-9]{2}')
colnames <- c( 'species', sort( c( paste0( rep(1:5, 2), c('_acover', '_bcount')))))
site_id <- str_extract(my_files[str_detect(my_files, 'subplot')], '7[0-9]{2}')

# Early Round Subplots --------------------------------------- # 
subplot_early <- lapply( my_files[ str_detect(my_files, 'subplot') ] , read_xlsx, col_names = colnames, range = 'A2:K100')
subplot_early <- lapply( subplot_early, function(x) x[!is.na(x$species), ] )
has_data <- which(lapply( subplot_early, length) > 0 ) 
subplot_early <- mapply( x = subplot_early[has_data], y = site_id[has_data], FUN =  function(x, y) { x$site <- y; return(x) }, SIMPLIFY = F )
subplot_early <- do.call(rbind, subplot_early)

subplot_early <- 
  subplot_early %>% 
  pivot_longer(cols = 2:11) %>% 
  separate( name, c('plot', 'type'), sep= '_') %>% 
  mutate( type = str_sub(type, start = 2)) %>% 
  mutate( round = 'early', extent = 'sub-subplot')  %>% 
  left_join(read_csv('data-raw/cover_2019/subplot_early_codes.csv'), by = 'species') %>% 
  left_join(sedgwick_plants, by = 'USDA_symbol')  %>% 
  pivot_wider( names_from = type, values_from = value ) %>% 
  mutate( area_cm2 = 15*15, 
          year = 2019, 
          type = 'subplot') %>% 
  select( year, site, plot, round, type, area_cm2, USDA_symbol, cover, count) 

# Early round wholeplot -------------------------------------------------------- # 
wholeplot_early_files <- my_files[ str_detect(my_files, 'wholeplot.xlsx')]
wholeplot_early <- lapply(  wholeplot_early_files , read_xlsx, col_names = colnames, range = 'A2:K100')
wholeplot_early <- lapply( wholeplot_early, function(x) x[!is.na(x$species), ] )
has_data <- which(lapply( wholeplot_early, length) > 0 ) 
wholeplot_early <- mapply( x = wholeplot_early[has_data], y = site_id[has_data], FUN =  function(x, y) { x$site <- y; return(x) }, SIMPLIFY = F )
wholeplot_early <- do.call(rbind, wholeplot_early)

wholeplot_early <- 
  wholeplot_early %>% 
  pivot_longer(cols = 2:11) %>% 
  separate( name, c('plot', 'type'), sep= '_') %>% 
  mutate( type = str_sub(type, start = 2)) %>% 
  mutate( round = 'early', extent = 'wholeplot') %>% 
  left_join(read_csv('data-raw/cover_2019/whole_plot_early_codes.csv'), by = 'species') %>% 
  left_join(sedgwick_plants, by = 'USDA_symbol') %>% 
  pivot_wider( names_from = type, values_from = value ) %>% 
  mutate( area_cm2 = 55*55, 
          year = 2019, 
          type = 'wholeplot') %>% 
  select( year, site, plot, round, type, area_cm2, USDA_symbol, cover, count ) 

# Late round wholeplot -------------------------------------------------------- # 
wholeplot_late_files <- my_files[ str_detect(my_files, 'wholeplot_late.xlsx')]
wholeplot_late <- lapply(  wholeplot_late_files , read_xlsx, col_names = colnames, range = 'A2:K100')
wholeplot_late <- lapply( wholeplot_late, function(x) x[!is.na(x$species), ] )
has_data <- which(lapply( wholeplot_late, length) > 0 ) 

wholeplot_late <- mapply( x = wholeplot_late[has_data], y = site_id[has_data], FUN =  function(x, y) { x$site <- y; return(x) }, SIMPLIFY = F )
wholeplot_late <- do.call(rbind, wholeplot_late)

wholeplot_late <- 
  wholeplot_late %>% 
  pivot_longer(cols = 2:11) %>% 
  separate( name, c('plot', 'type'), sep= '_') %>% 
  mutate( type = str_sub(type, start = 2)) %>% 
  mutate( round = 'late', extent = 'wholeplot') %>% 
  left_join(read_csv('data-raw/cover_2019/whole_plot_late_codes.csv')) %>% 
  left_join(sedgwick_plants, by= 'USDA_symbol' ) %>% 
  pivot_wider( names_from = type, values_from = value) %>% 
  mutate( area_cm2 = 55*55, 
          year = 2019, 
          type = 'wholeplot') %>% 
  select( year, site, plot, round, type, area_cm2, USDA_symbol, cover, count) 


# ------------ Calculate densities and compare ------------ # 
densities <-
  bind_rows(subplot_early, wholeplot_early, wholeplot_late) %>% 
  mutate( density = count/area_cm2) %>% 
  group_by( year, site, plot, type, area_cm2, USDA_symbol) %>% 
  filter( cover == max(cover)) %>% 
  group_by( USDA_symbol) %>% 
  filter( n_distinct(type) > 1  )  #%>%

densities %>% 
  ggplot( aes( x = cover, y = density, color = type )) + 
  geom_point() + 
  geom_smooth( method = 'lm')  + 
  facet_wrap(~USDA_symbol, scales = 'free') 

dd <- densities %>% 
  group_by( USDA_symbol ) %>% 
  filter( n_distinct(site, plot ) > 10 )

densities %>% 
  filter( round == 'early') %>% 
  group_by( USDA_symbol, site, plot) %>% 
  summarise( reps = sum(!is.na(count)) ) %>% 
  arrange( desc(reps ))

cover2count_mod <- glmer( data = dd, 
                          count ~ offset( log(area_cm2)) + cover*type + (cover*type | USDA_symbol),
                          family = 'poisson')

cover2density_mod <- lmer( data = dd, 
                           density ~ cover*type + (cover*type | USDA_symbol),
                           control = lmerControl(optimizer= "optimx",
                                                 optCtrl  = list(method="L-BFGS-B")))


dd$density_predicted <- predict( cover2density_mod, newdata = dd)
dd$count_predicted <- predict(cover2count_mod, newdata = dd, type = 'response')

dd %>% 
  group_by( USDA_symbol ) %>% 
  filter( n_distinct(type) > 1) %>%
  filter( type == 'wholeplot' , !is.na(density)) %>% 
  ggplot( aes( x = density_predicted, y = density)) + 
  geom_point() + 
  geom_abline(aes( intercept = 0, slope = 1 )) + 
  facet_wrap( ~ USDA_symbol) + 
  coord_equal()

dd %>% 
  group_by( USDA_symbol ) %>% 
  filter( n_distinct(type) > 1) %>%
  filter( type == 'wholeplot' , !is.na(count)) %>% 
  ggplot( aes( x = count_predicted, y = count)) + 
  geom_point() + 
  geom_abline(aes( intercept = 0, slope = 1 )) + 
  facet_wrap( ~ USDA_symbol) + coord_equal()

# ------------ compare predicted wholeplot count to wholeplot estimates from subplot density ---------- # 
compare_counts <- dd %>% 
  filter( type == 'subplot') %>% 
  left_join(dd %>% 
              filter( type == 'wholeplot'), by = c('year', 'site', 'plot', 'round', 'USDA_symbol')) %>% 
  filter( !is.na(count.y)) %>% 
  mutate( count_extrapolated = density.x*area_cm2.y) %>% 
  select( site, plot, USDA_symbol, count.y, count_predicted.y, count_extrapolated) %>% 
  rename( 'count' = count.y , 
          'glmer_predicted' = count_predicted.y) %>% 
  ungroup() %>% 
  gather( type, predicted_count, glmer_predicted:count_extrapolated) 

compare_counts %>% 
  ggplot( aes( x = predicted_count, y = count, color = type)) +  
  geom_point(size = 3) + 
  geom_abline(aes( intercept = 0, slope = 1)) + 
  theme_bw()


compare_counts %>% 
  group_by( type ) %>% 
  summarise( RMSE = sqrt( mean(( count - predicted_count )^2)) ) # extropolated counts look better 




