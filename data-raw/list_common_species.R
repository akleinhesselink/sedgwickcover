rm(list = ls())
library(tidyverse)

outfile <- 'data-raw/species_rarity.csv'

load('data/plot_cover.rda')

max_cover <- apply( plot_cover[, -1], 2, max) 
total_plots <- apply( plot_cover[, -1], 2, function(x) sum( x > 0) )

species_commoness <- data.frame( cbind( max_cover, total_plots) )

write_csv(species_commoness, path = outfile)
