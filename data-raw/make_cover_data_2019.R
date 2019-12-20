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
  mutate( area = 15*15, 
          year = 2019, 
          type = 'subplot') %>% 
  select( year, site, plot, round, type, area, USDA_symbol, cover, count) 
  
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
  mutate( area = 55*55, 
          year = 2019, 
          type = 'wholeplot') %>% 
  select( year, site, plot, round, type, area, USDA_symbol, cover, count ) 

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
  mutate( area = 55*55, 
          year = 2019, 
          type = 'wholeplot') %>% 
  select( year, site, plot, round, type, area, USDA_symbol, cover, count) 


# --------------------------------------------------------- #   

# 1. bind early and late wholeplot data 
# 2. take max of early and late sampling rounds ( highest plot cover for each species )
# 3. use subplot count data to estimate wholeplot count 
# 4. bind subplot estimates to wholeplot cover/count data 
# 5. output data in correct format

subplot_density <-   
  subplot_early %>% 
  mutate( subplot_density = count/area )  %>% 
  select( year, round, site, plot, USDA_symbol, subplot_density) %>% 
  mutate( site = as.numeric(site), plot = as.numeric(plot)) 

all_data <- 
  bind_rows(
    wholeplot_early, 
    wholeplot_late) %>% 
  mutate( site = as.numeric(site), plot = as.numeric(plot)) %>% 
  left_join(subplot_density) %>% 
  mutate( estimated_count = subplot_density*area ) %>% 
  mutate( cover = ifelse( is.na(cover), 0 , cover )) %>% 
  group_by( year, site, plot, type, area, USDA_symbol ) %>% 
  filter( cover == max(cover) & (!is.na(count) | !is.na(estimated_count)) ) %>% 
  ungroup() 
  
final_data <- 
  expand.grid( 
  year = unique(all_data$year), 
  area = unique(all_data$area),
  type = unique(all_data$type),
  site = as.numeric( unique( all_data$site)), 
  plot = as.numeric(unique( all_data$plot)), 
  USDA_symbol = (unique(all_data$USDA_symbol))) %>% 
  left_join(all_data) %>% 
  mutate( cover = ifelse(is.na(cover), 0, cover )) %>% 
  mutate( count = ifelse(cover == 0 , 0, count)) %>% 
  ungroup() %>% 
  rename( 'direct_count' = count) %>% 
  pivot_longer(c(direct_count, estimated_count), "count_type", values_to = 'count' )  %>% 
  filter( !is.na(count)) 
  
# final_data %>% 
#   group_by( year,site, plot, USDA_symbol) %>% 
#   filter( !is.na(count)) %>% 
#   filter( n() > 1 ) %>% 
#   filter( !is.na(subplot_density)) %>% 
#   spread( count_type, count) %>% 
#   ggplot( aes( x = estimated_count, y = direct_count)) + 
#   geom_point() + 
#   geom_text(aes( label = USDA_symbol)) + 
#   geom_abline(intercept = 0, slope = 1)

final_data <- 
  final_data %>% 
  group_by( year, area, site, plot, USDA_symbol) %>% 
  filter( row_number() == 1) %>% 
  select( - type , - round, - subplot_density) 

# --------- Prepare final dataframes for export --------------------------- # 
site_cover_2019 <- 
  final_data %>% 
  select( year, area, site, plot, USDA_symbol, cover, count ) %>% 
  group_by( year, site, USDA_symbol) %>%
  summarise( area = sum(area), tot_count = sum(count), avg_cover = mean(cover), sd_cover = sd(cover), sd_count = sd(count), n_plots = sum(cover > 0 )) %>% 
  select(year, site, area, USDA_symbol, n_plots, sd_cover, avg_cover, tot_count, sd_count) %>% 
  ungroup() %>% 
  as.data.frame()

plot_cover_2019 <- 
  final_data %>% 
  ungroup() %>% 
  select( year, site, plot, area, USDA_symbol, cover, count_type, count)  %>% 
  as.data.frame()

# Check that all species are in the species list ------------------- # 
site_cover_2019[!site_cover_2019$USDA_symbol %in% sedgwick_plants$USDA_symbol , ] %>% ungroup() %>% distinct(USDA_symbol)
plot_cover_2019[!plot_cover_2019$USDA_symbol %in% sedgwick_plants$USDA_symbol , ] %>% ungroup() %>% distinct(USDA_symbol)
# ------------------------------------------------------------------- # 


usethis::use_data(site_cover_2019, overwrite = T)
usethis::use_data(plot_cover_2019, overwrite = T)

