#' Age-conditional reference distribution of D-score
#' 
#' A data frame containing the age-dependent distribution of the 
#' D-score for children aged 0-5 years. The distribution is modelled
#' after the LMS distribution (Cole & Green, 1992), and is equal for
#' both boys and girls. The LMS values can be used to graph 
#' reference charts and to calculate age-conditonal Z-scores, also 
#' known as DAZ.
#' 
#' @docType data
#' @format A \code{data.frame} with 144 rows and 19 variables:
#' \describe{
#' \item{pop}{Population, either \code{dutch} or \code{gcdg}}
#' \item{age}{Decimal age in years}
#' \item{mu}{M-curve, median D-score, P50}
#' \item{sigma}{S-curve, spread expressed as coefficient of variation}
#' \item{nu}{L-curve, the lambda coefficient of the LMS model for skewness}
#' \item{P3}{P3 percentile}
#' \item{P10}{P10 percentile}
#' \item{P25}{P25 percentile}
#' \item{P50}{P50 percentile}
#' \item{P75}{P75 percentile}
#' \item{P90}{P90 percentile}
#' \item{P97}{P97 percentile}
#' \item{SDM2}{-2SD centile}
#' \item{SDM1}{-1SD centile}
#' \item{SD0}{0SD centile, median}
#' \item{SDP1}{+1SD centile}
#' \item{SDP2}{+2SD centile}
#' }
#' @details 
#' The \code{"dutch"} references were calculated from the SMOCC data, and cover 
#' age range 0-2.5 years.
#' The \code{"gcdg"} references were calculated from the 15 cohorts of the GCDG-study,
#' and cover age range 0-5 years.
#' @examples 
#' head(builtin_references)
#' 
#' @references
#' Cole TJ, Green PJ (1992). Smoothing reference centile curves: The LMS 
#' method and penalized likelihood. Statistics in Medicine, 11(10), 
#' 1305-1319.
#' 
#' Van Buuren S (2014). Growth charts of human development.
#' Stat Methods Med Res, 23(4), 346-368.
#' @seealso \code{\link{dscore}}
"builtin_references"