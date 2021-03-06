% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/milestones.R
\docType{data}
\name{milestones}
\alias{milestones}
\title{Outcomes on developmental milestones for preterm-born children}
\format{
A \code{data.frame} with 100 rows and 62 variables:\tabular{ll}{
   Name \tab Label \cr
   \code{id} \tab Integer, child ID \cr
   \code{agedays} \tab Integer, age in days \cr
   \code{age} \tab Numeric, decimal age in years \cr
   \code{sex} \tab Character, "male", "female" \cr
   \code{gagebrth} \tab Integer, gestational age in days \cr
   \code{ddifmd001} \tab Integer, Fixates eyes: 1 = yes, 0 = no \cr
   \code{...} \tab and so on.. \cr
}
}
\usage{
milestones
}
\description{
A demo dataset with developmental scores at the item level for
a set of 27 preterm children.
}
\examples{
head(milestones)
}
\seealso{
\code{\link[=dscore]{dscore()}}
}
\keyword{datasets}
