#' Herbaceous plant cover from 24 sites at the UC Sedgwick Reserve.
#'
#' A data frame for average plant cover from 24 monitoring sites at 
#' the UC Sedgwick Reserve in Santa Barbara Co. CA, USA. Data were collected in 
#' the spring of 2017 by visually estimating percent cover in 5 25 x 25 cm subplots
#' at each site and then taking the average. Cover estimates were made in mid-spring
#' and late spring and the maximum cover per species per site was used. 
#'
#' @format A data frame with 397 rows and 3 variables:
#' \describe{
#'   \item{site}{site number, 740 to 763}
#'   \item{species}{latin binomial of species, using calflora taxonomy}
#'   \item{cover}{average cover of each species across the five subplots at each site}
#' }
"site_cover"

#' Herbaceous plant cover from five subplots at 24 sites at the UC Sedgwick Reserve.
#'
#' A dataframe for plant cover from five subplots at each of 24 sites at
#' the UC Sedgwick Reserve in Santa Barbara Co. CA, USA. Data were collected in 
#' the spring of 2017 by visually estimating percent cover in each of 5 25 x 25 cm 
#' subplots at each site. Cover estimates were made in mid-spring
#' and late spring and the maximum cover per species per site is reported. 
#'
#' @format A data frame with 1973 rows and 3 variables:
#' \describe{
#'   \item{site}{Site number 740 to 763} 
#'   \item{subplot}{ Subplot per site, numbered 1 to 5} 
#'   \item{species}{latin binomial of species, using calflora taxonomy}
#'   \item{cover}{cover of each species}
#' }
"subplot_cover"

#' Herbaceous plant cover from two microplots in each of five subplots at 24 sites at the UC Sedgwick Reserve.
#'
#' A dataframe for average plant cover from two microplots per each of the 
#' five subplots at each of the 24 sites at Sedgwick the UC Sedgwick Reserve in 
#' Santa Barbara Co. CA, USA. Data were collected in the spring of 2017 by 
#' visually estimating percent cover in two 10 x 10 cm microplots within each
#' 25 x 25 cm subplot at each site. Cover estimates were made in mid-spring
#' and late spring and the maximum cover per species per site is reported. 
#'
#' @format A data frame with 3946 rows and 5 variables:
#' \describe{
#'   \item{site}{Site number 740 to 763.
#'   \item{subplot}{ Subplot per site, numbered 1 to 5} 
#'   \item{microplot}{ Microplot within each subplot, identified as LL and UR, lower left and upper right respectively. }
#'   \item{species}{latin binomial of species, using calflora taxonomy}
#'   \item{cover}{cover of each species}
#' }
"microplot_cover"
