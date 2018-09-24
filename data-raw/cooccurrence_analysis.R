# 
rm(list = ls())
library(cooccur)
library(dplyr)
library(tidyr)
library(stringr)

load('~/Dropbox/Sedgwick/plot_data/cover.data')
hummocks <- read.csv('~/Dropbox/Sedgwick/plot_data/hummock.csv')
nich_fitness <- read.csv('~/Dropbox/Sedgwick/Tapioca_data/for_will.csv')
trait_species <- c('Agoseris heterophylla', 'Amsinckia menziesii', 'Bromus madritensis', 'Centaurea melitensis', 'Chaenactis glabriuscula', 'Chorizanthe staticoides', 'Clarkia purpurea', 'Erodium cicuterium', 'Erodium moschatum', 'Euphorbia spathulata', 'Hemizonia congesta', 'Hordeum murinum', 'Lasthenia californica', 'Lotus wrangelianus', 'Medicago polymorpha' , 'Micropus californicus', 'Navarretia atractyloides', 'Plantago erecta', 'Salvia columbariae', 'Uropappus lindleyi', 'Vulpia microstachys')

plot_occurence <- 
  cover %>% 
  group_by(species, plot) %>% 
  summarise( present = sum( sum(total) > 0) ) %>% 
  spread( species, present )

subplot_occurence <- 
  cover %>% 
  left_join(hummocks) %>% 
  filter( microsite == 'hummock')%>% 
  unite( 'subplot', plot, subplot, remove = T, sep = '.') %>% 
  group_by(species, subplot) %>% 
  summarise( present = sum(total > 0)) %>% 
  spread( species, present )

microplot_occurence <- 
  cover %>% 
  left_join(hummocks) %>% 
  filter( microsite == 'hummock')%>% 
  select( species, plot, subplot, LL, UR) %>% 
  gather( microplot , value, LL:UR) %>% 
  unite( 'microplot', plot, subplot, microplot, sep = '.' ) %>% 
  group_by(species, microplot) %>% 
  summarise ( present = sum(value > 0 )) %>% 
  spread(species, present)


plot_occurence[ is.na( plot_occurence ) ] <- 0
subplot_occurence[is.na(subplot_occurence)] <- 0 
microplot_occurence[ is.na(microplot_occurence) ] <- 0

plot_cmat <- cooccur(t(plot_occurence[, -1]), spp_names = T)
plot(plot_cmat)

subplot_cmat <- cooccur(t(subplot_occurence[,-1]), spp_names = T)
plot(subplot_cmat)

microplot_cmat <- cooccur(t(microplot_occurence[, -1]), spp_names = T)
plot(microplot_cmat)

microplot_cmat$results$sp1_nam

microplot_scores <- microplot_cmat$results[ , c('p_lt', 'p_gt', 'sp1_name', 'sp2_name')]

microplot_scores <- 
  microplot_scores %>% 
  separate(sp1_name, c('genus', 'species'), sep = ' ') %>% 
  mutate( sp1_name = toupper(paste(substr(genus, 1,2), substr(species, 1,2), sep = ''))) %>% 
  select( -genus, -species) %>% 
  separate(sp2_name, c('genus', 'species'), sep = ' ') %>% 
  mutate( sp2_name = toupper(paste(substr(genus, 1,2), substr(species, 1,2), sep = ''))) %>% 
  select(-genus, -species)
  
microplot_scores$sp1_name <- str_replace(microplot_scores$sp1_name, 'EUSP', 'EUPE')
microplot_scores$sp2_name <- str_replace(microplot_scores$sp2_name, 'EUSP', 'EUPE')

niche_fitness <- nich_fitness %>% separate(species_pair, c('sp1_name', 'sp2_name'), sep = '_')

microplot_scores_switched <- microplot_scores
microplot_scores_switched$sp1_name <- microplot_scores$sp2_name
microplot_scores_switched$sp2_name <- microplot_scores$sp1_name

microplot_scores <- rbind( microplot_scores, microplot_scores_switched)

compare <- merge(microplot_scores, niche_fitness)

compare$positive_association <- compare$p_gt < 0.05
compare$negative <- compare$p_lt < 0.05

compare %>% mutate( ifelse( p_gt < 0.05, 'positive', NA))
compare %>% gather( cooccurrence, value, positive, negative)
niche_fitness


x <- seq(0, 1, length.out = 1000)
y <- 1/(1-x)
coex_curve <- data.frame( x, y)

compare$species_pairs <- paste( compare$sp1_name, compare$sp2_name, sep = '_')

library(ggplot2)
ggplot( compare, aes( y = fitness.difference, x = niche.difference, color = positive_association  )) + 
  geom_point() +  
  geom_text( aes(label = species_pairs), nudge_y = 0.1, show.legend = F) + 
  geom_line(data = coex_curve, aes(x = x, y = y), color = 'darkgray') + 
  theme_bw() +
  theme(panel.grid = element_blank()) + 
  scale_y_log10() 


ggplot(compare, aes(niche.difference, p_gt) ) + geom_point()
ggplot(compare, aes(fitness.difference, p_gt)) + geom_point()
