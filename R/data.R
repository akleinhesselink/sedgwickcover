#' Spring 2017 average plant cover for 24 study sites at Sedgwick
#'
#' A dataframe of average cover for all vascular plant species found at each of the 24 
#' study sites at the UC Sedgwick Reserve. Cover is an average of across five 
#' 25 x 25 cm sampling plots located at each site. Data collected 
#' by Andy Kleinhesselink in April of 2017.'
#' 
#' @format A data frame with 2016 rows and 7 variables:
#' \describe{
#'   \item{year}{year of cover estimate}
#'   \item{site}{site number, 740 to 763}
#'   \item{area}{Total sample area: 5 plots x 625 cm^2 per site}
#'   \item{USDA_symbol}{USDA symbol used to identify species}
#'   \item{n_plots}{number of plots where the species was present in each site}
#'   \item{sd_cover}{standard deviation of cover across the plots at each site}
#'   \item{avg_cover}{average cover of species across the five plots at each site}
#' }
"site_cover_2017"

#' Spring 2017 plant cover from sampling plots at 24 sites at Sedgwick
#'
#' A dataframe of cover estimates for all vascular plant species found in 25 x 25 cm
#' sampling plots at the UC Sedgwick Reserve. There are five plots at each of the 
#' 24 study sites (n = 120). Data collected by Andy Kleinhesselink in April of 2017. 
#'
#' @format A data frame with 10080 rows and 6 variables:
#' \describe{
#'   \item{year}{year of cover estimate}
#'   \item{site}{site number, 740 to 763}
#'   \item{plot}{plot number, 1 to 5}
#'   \item{USDA_symbol}{USDA symbol used to identify species}
#'   \item{area}{Sample area in cm^2}
#'   \item{cover}{estimated cover of each species in each plot}
#' }
"plot_cover_2017"

#' Spring 2017 plant cover from microplots at Sedgwick.
#'
#' A dataframe of cover estimates for vascular plants found in 10 x 10 cm 
#' microplots nested within each of the plots at each of the 24 sampling sites (n = 240)
#' at the UC Sedgwick Reserve. Data collected by Andy Kleinhesselink in April of 2017. 
#'
#' @format A data frame with 20170 rows and 7 variables:
#' \describe{
#'   \item{year}{year of cover estimate}
#'   \item{site}{Site number 740 to 763.}
#'   \item{plot}{plot number, 1 to 5}
#'   \item{subplot}{Subplot within each subplot, identified as LL and UR, lower left and upper right respectively.}
#'   \item{area}{Total sample area in cm^2}
#'   \item{USDA_symbol}{USDA symbol used to identify species}
#'   \item{cover}{cover of each species per plot}
#' }
"microplot_cover_2017"

#' Spring 2019 plant cover from sampling plots at 24 sites at Sedgwick
#'
#' A dataframe of cover estimates and total number of individuals of all vascular plants 
#' found in 55 x 55 cm sampling plots at the UC Sedgwick Reserve. There are five plots at each 
#' of the 24 study sites (n = 120). Individual counts are either direct counts across the 
#' entire plot area or are extrapolated to the whole plot area by counting all the individuals 
#' in a representative 15 x 15 cm subplot within the plot. Data collected by Andy Kleinhesselink 
#' in April of 2019. 
#'
#' @format A data frame with 10920 rows and 8 variables:
#' \describe{
#'   \item{year}{year of cover estimate}
#'   \item{site}{site number, 740 to 763}
#'   \item{plot}{plot number, 1 to 5}
#'   \item{area}{plot area in cm^2}
#'   \item{USDA_symbol}{USDA symbol used to identify species}
#'   \item{cover}{estimated cover of each species in each plot}
#'   \item{count_type}{Indicates whether counts are direct counts of individuals across the entire plot or estimated counts made by counting individuals in 15 x 15 cm subplot and extroplating that density to the entire plot.}
#'   \item{count}{number of individuals of each species in the plot}
#' }
"plot_cover_2019"


#' Spring 2019 average plant cover and density at 24 sites at Sedgwick
#'
#' A dataframe of average cover and total individual abundance for all vascular plants 
#' found at each of the 24 study sites at the UC Sedgwick Reserve. Cover is averaged and total 
#' count is summed across across five 55 x 55 cm sampling plots located at each site. Data collected 
#' by Andy Kleinhesselink in April of 2019.'
#'
#' @format A data frame with 2184 rows and 9 variables:
#' \describe{
#'   \item{year}{year of cover estimate}
#'   \item{site}{site number, 740 to 763}
#'   \item{area}{total sampled area: 5 plots x 3025 cm^2 per site}
#'   \item{USDA_symbol}{USDA symbol used to identify each species}
#'   \item{n_plots}{number of plots where the species was present in each site}
#'   \item{sd_cover}{standard deviation of cover across the plots at each site}
#'   \item{avg_cover}{average cover of species across the five plots at each site}
#'   \item{tot_count}{total number of individuals of each species across the five plots at each site}
#'   \item{sd_count}{standard deviation of counts across the five plots at each site}
#' }
"site_cover_2019"
