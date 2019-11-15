rm(list = ls())
library(tidyverse)
library(readxl)
library(sedgwickspecies)

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
  left_join(read_csv('data-raw/cover_2019/whole_plot_late_codes.csv'))  %>% 
  left_join(sedgwick_plants, by= 'USDA_symbol' ) %>% 
  pivot_wider( names_from = type, values_from = value) %>% 
  mutate( area_cm2 = 55*55, 
          year = 2019, 
          type = 'wholeplot') %>% 
  select( year, site, plot, round, type, area_cm2, USDA_symbol, cover, count) 


subplot_comparison <- 
  subplot_early %>%
  rename( 'subplot_cover' = cover, 
          'subplot_count' = count) %>% 
  left_join(wholeplot_early %>% 
              mutate( 'wholeplot_cover' = cover, 
                      'wholeplot_count' = count) , by = c('year', 'site', 'plot', 'round', 'USDA_symbol')) 

r2 <- summary( lm( data = subplot_comparison, wholeplot_cover ~ subplot_cover ) )$r.squared

subplot_comparison %>% 
  ggplot( aes( x = subplot_cover, y = wholeplot_cover)) + 
  geom_point() + 
  geom_abline(aes( intercept = 0, slope = 1 )) + 
  annotate( 10, 90, geom = 'label', label = paste0 ( 'R^2', '=', round( r2, 2) ))

subplot_comparison %>% 
  filter( !is.na( subplot_count), !is.na(wholeplot_count)) %>% 
  mutate( expected_wholeplot_count = subplot_count*(area_cm2.y/area_cm2.x)) %>% 
  ggplot( aes( expected_wholeplot_count, wholeplot_count) ) + 
  geom_point() +
  geom_abline(aes( intercept = 0, slope = 1 ))

subplot_comparison %>% 
  ggplot( aes( x = wholeplot_cover, wholeplot_count , color = USDA_symbol == "PLER3")) + 
  geom_point() 
  
subplot_comparison %>% 
  ggplot( aes( x = wholeplot_cover, wholeplot_count , color = USDA_symbol == "PLER3")) + 
  geom_point() 


