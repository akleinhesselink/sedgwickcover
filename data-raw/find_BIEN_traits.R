library(BIEN)
library(Taxonstand)
library(dplyr)
library(tidyr)

rm(list = ls())
cover <- read.csv('~/Dropbox/Sedgwick_cover_data/2017_first_round_cover_data.csv')

uspecies <- as.character( unique( cover$species ) )
uspecies


#corrected_species <- TPL(uspecies)
#corrected_species[ corrected_species$Typo , ] 
#good_species <- corrected_species[ corrected_species$Taxonomic.status == 'Accepted', ]
#bad_species <- corrected_species[ corrected_species$Taxonomic.status == '', ] 
#species2 <- TPL(paste(bad_species$New.Genus, bad_species$New.Species)) # need a second check because the initial check often returns a false negative
#good_species2 <- species2[ species2$Taxonomic.status == 'Accepted', ]
#good_species <- rbind( good_species, good_species2)
#uspecies <- paste( good_species$New.Genus[ good_species$Taxonomic.status == 'Accepted'], good_species$New.Species[ good_species$Taxonomic.status == 'Accepted'  ] )

traits <- BIEN_trait_species(uspecies)
traits
BIEN_trait_genus('Acmispon')

seed_mass <- traits %>% group_by( scrubbed_species_binomial, trait_name) %>% summarise( n() )  %>% ungroup() %>% filter( trait_name == 'seed mass')

write.csv(traits, '~/Dropbox/Sedgwick/plot_data/BIEN_species_traits.csv', row.names = F)


load('~/Dropbox/Sedgwick_cover_data/cover.data')


spp_list <- avg_cover %>% gather( species, cover, -plot ) %>% group_by(species) %>% distinct(species)

write.csv(spp_list, '~/Dropbox/Sedgwick_cover_data/my_spp_list.csv', row.names = F)
