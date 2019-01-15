library(ggplot2)
library(vegan)
library(dplyr)
library(tidyr)
rm(list = ls())

# This is Broken

env %>% filter( type == 'upper') %>% select(plot) %>% arrange(plot)
#avg_cover <- avg_cover %>% filter(plot < 756)
#env <- env %>% filter( type == 'upper')

ord <- metaMDS(avg_cover[, -1], k = 2)
plot(ord, type = 't')

env2 <- env %>% select( -lat, -lon, -Tmin, -ele) %>% arrange( plot )
env2
efit <- envfit(ord, env2[,-1] )

plot(ord, type = 't')
plot(efit, p.max = 0.05, axis = T)


species_scores <- data.frame( ord$species )
species_scores$species <- row.names(species_scores)
species_scores <- left_join(species_scores, plot_counts)

gg <- ggplot( species_scores, aes( MDS1, MDS2) ) + geom_point() 

plot_scores <- data.frame( ord$points )
plot_scores$plot <- avg_cover$plot
efit_vectors <- data.frame( efit$vectors$arrows, efit$vectors$r )

plot_scores <- merge( plot_scores, env[, c('plot', 'type', 'microsite')])

base_gg <- 
  ggplot( plot_scores, aes( MDS1, MDS2, color = type, shape  = microsite )) + 
  geom_point(size = 5, alpha = 0.5) + 
  theme_bw() +
  theme(panel.grid= element_blank()) 

base_gg
species_scores

trait_species <- c('Agoseris heterophylla', 'Amsinckia menziesii', 'Bromus madritensis', 'Centaurea melitensis', 'Chaenactis glabriuscula', 'Chorizanthe staticoides', 'Clarkia purpurea', 'Erodium cicuterium', 'Erodium moschatum', 'Euphorbia spathulata', 'Hemizonia congesta', 'Hordeum murinum', 'Lasthenia californica', 'Lotus wrangelianus', 'Medicago polymorpha' , 'Micropus californicus', 'Navarretia atractyloides', 'Plantago erecta', 'Salvia columbariae', 'Uropappus lindleyi', 'Vulpia microstachys')
indicator_species <- c('Centaurea melitensis', 'Clarkia purpurea', 'Erodium moschatum', 'Claytonia perfoliata', 'Amsinckia menziesii', 'Croton setigerus', 'Bromus hordeaceus', 'Bromus diandrus', 'Hordeum murinum', 'Avena fatua', 'Avena barbata', 'Lactuca serriola', 'Hemizonia congesta', 'Chaenactis glabriuscula', 'Plantago erecta', 'Navarretia atractyloides', 'Coreopsis bigelovii')

base_gg + geom_text(data = species_scores %>% filter( species %in% trait_species), aes( MDS1, MDS2, label = species, shape = NA), color = 'black', size = 3)

ord_species <- base_gg + geom_text(data = species_scores %>% filter( species %in% indicator_species), aes ( MDS1, MDS2, color = NA, label = species, shape = NA ) ) 

ord_species
plot(ord)
plot(efit, display = 'lc', axis = T )

efit$vectors$arrows[c('Ca_.', 'K_.', 'Sand_.'), ]
sqrt( efit$vectors$r[c('Ca_.', 'K_.', 'Sand_.')] )
efit$vectors$pvals

efit_vectors$label <- row.names(efit_vectors)

efit_vectors[, 1:2] <- efit_vectors[, 1:2]*2.5*sqrt( efit_vectors$efit.vectors.r )
efit_vectors$line_end <- 0.9*efit_vectors[, 1:2]

efit_vectors$x_start <- 0 
efit_vectors$y_start <- 0 

plot_vectors <- efit_vectors[ efit$vectors$pvals < 0.05 , ]

base_gg + 
  geom_segment( data = plot_vectors, aes(x = x_start, y = y_start, xend = line_end[,1], yend = line_end[,2], shape = NULL), arrow = arrow(length = unit(0.1, 'cm')), color = 'gray' ) + 
  geom_text( data = plot_vectors , aes(x = NMDS1, y = NMDS2, label = label, shape = NA), color = 'black') 


ggplot( plot_scores, aes( MDS1, MDS2, shape  = microsite )) + 
  geom_point(size = 5, alpha = 0.5) + 
  theme_bw() +
  theme(panel.grid= element_blank()) +
  geom_segment( data = plot_vectors, aes(x = x_start, y = y_start, xend = line_end[,1], yend = line_end[,2], shape = NULL), arrow = arrow(length = unit(0.1, 'cm')), color = 'gray' ) + 
  geom_text( data = plot_vectors , aes(x = NMDS1, y = NMDS2, label = label, shape = NA), color = 'black') +
  geom_text(data = species_scores %>% filter( species %in% indicator_species), aes ( MDS1, MDS2, label = species, shape = NA ))

