rm(list =ls())
library(ggplot2)
library(dplyr)
library(tidyr)

load('~/Dropbox/Sedgwick_cover_data/cover.data')

traits <- read.csv('~/Dropbox/Sedgwick_cover_data/BIEN_species_traits.csv')

head(traits)

levels(traits$trait_name)

my_traits <- traits %>% filter( trait_name %in% c( 'leaf carbon content per leaf nitrogen content', 'leaf area', 'seed mass', 'leaf dry mass per leaf fresh mass', 'whole plant height', 'whole plant leaf area per whole plant leaf dry mass' )) 

my_traits <- my_traits %>% group_by(scrubbed_species_binomial, trait_name) %>% mutate( trait_value = as.numeric( levels(trait_value) )[ trait_value ] ) %>% summarise( avg_trait_value = mean(trait_value))

levels( my_traits$scrubbed_species_binomial )

my_traits <- my_traits %>% filter( scrubbed_species_binomial != 'Quercus douglasii')

p <- ggplot( my_traits, aes( x = avg_trait_value ) ) + geom_histogram() + facet_wrap(~trait_name)
trait_dists <- my_traits %>% group_by( trait_name ) %>% do( pp = p %+% . )
trait_dists$pp

my_traits <- my_traits %>% spread( trait_name, avg_trait_value)

test <- merge( avg_cover %>% gather( species, cover, -plot ), my_traits, by.x = 'species', by.y = 'scrubbed_species_binomial')

head( test %>% arrange( plot) )

weighted_trait_avg <- function( cover, trait ) { 
  cover <- cover[ !is.na(trait)] 
  trait <- trait[ !is.na(trait)]
  tot_cover <- sum(cover ) 
  weights <- cover/tot_cover 
  sum( trait*weights ) / length(cover)
}

test <- test %>% gather(key =  trait_name,value =  trait_value, `leaf area`:`whole plant leaf area per whole plant leaf dry mass`)

test <- test %>% group_by( plot, trait_name ) %>% summarise(weighted_avg = weighted_trait_avg(cover, trait_value ))


p2 <- ggplot(test, aes( x = plot, y = weighted_avg)) + geom_point()  + facet_wrap( ~trait_name)

p2 <- test %>% group_by( trait_name ) %>% do(pp = p2 %+% .)

p2$pp 

test <-  test %>% spread( trait_name, weighted_avg) 
test <- test %>% dplyr::select(-`leaf area`)
pairs(test[, -1])

head( test )

test$`whole plant leaf area per whole plant leaf dry mass`
test_pca <- princomp(test[,-1])
plot(test_pca)

biplot(test_pca)

tfit <- envfit(ord, test[, -1])

plot(efit)
plot(ord)
plot(efit)
plot(tfit, col = 'red')
