library(ggplot2)

phenology <- read.csv('Dropbox/Sedgwick/plot_data/phenology_data.csv')

pheno_avg <- phenology %>% group_by( species, date ) %>% summarise( veg =mean(veg, na.rm = T), flower = mean(flower, na.rm = T), fruit = mean(fruit, na.rm = T)) 

pheno_avg <- pheno_avg %>% gather( stage, percent, veg:fruit)


ggplot(pheno_avg[ pheno_avg$species == 'Agoseris heterophylla', ], aes( x = date, y = percent, fill = stage, color = stage)) + geom_bar(stat= 'identity')
