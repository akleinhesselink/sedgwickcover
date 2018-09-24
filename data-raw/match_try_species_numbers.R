library(Taxonstand)

cover<- read.csv('~/Dropbox/Sedgwick/plot_data/2017_cover_data.csv')

species_list <- unique( as.character( cover$species ) )

species_clean <- TPL(species_list)

all_species_names <- paste( species_clean$New.Genus, species_clean$New.Species) # alternative species names 
all_species_names <- c( all_species_names, 'Acmispon strigosus', 'Acmispon purshianus', 'Caucalis microcarpa') # make list including synonyms


TRY <- read.table('~/Dropbox/Sedgwick/TRY_species_list.txt', sep = '\t', header = T)
trait_list <- read.table('~/Dropbox/Sedgwick/TRY_trait_index.txt', sep = '\t', skip = 2, header = T)



trait_list %>% filter ( trait_list$TraitID %in% c(1, 11, 18, 1080, 926, 109, 14, 134, 26) )

TRY <- TRY %>% rename( species = AccSpeciesName)

matches <- left_join( data.frame( species = all_species_names), TRY)
matches



paste (unique( matches$AccSpeciesID ), collapse = ',')
