#' Spring 2017 average plant cover for each of the 24 study sites at Sedgwick.
#'
#' A dataframe of average cover for all vascular plant species found at each of the 24 
#' study sites at the UC Sedgwick Reserve. Cover reported is simply an average of 
#' cover across the five 25 x 25 cm sampling plots located at each site. Data collected 
#' by Andy Kleinhesselink in April of 2017.'
#' 
#' @format A data frame with 2016 rows and 7 variables:
#' \describe{
#'   \item{year}{year of cover estimate}
#'   \item{site}{site number, 740 to 763}
#'   \item{area}{Total sample area in cm^2}
#'   \item{USDA_symbol}{USDA symbol used to identify species}
#'   \item{n_plot}{number of plots where the species was present in each site}
#'   \item{sd_cover}{standard deviation of cover across the plots at each site}
#'   \item{avg_cover}{average cover of species across the five plots at each site}
#' }
"site_cover_2017"

#' Spring 2017 plant cover from sampling plots at each of the 24 sites at Sedgwick.
#'
#' A dataframe of cover estimates for all vascular plant species found in five
#' 20 x 20 cm plots located along a 10 m transect at each of the 24 study sites at 
#' the UC Sedgwick Reserve. Data collected by Andy Kleinhesselink in April of 2017. 
#'
#' @format A data frame with 10080 rows and 8 variables:
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
#' A dataframe of cover estimates for all vascular plant species found in 
#' 10 x 10 cm microplots nested within each plot at each of the 24 sampling sites
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
"subplot_cover_2017"