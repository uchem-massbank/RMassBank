\name{ppm}
\alias{ppm}
\title{Calculate ppm values}
\usage{
  ppm(mass, dppm, l = FALSE, p = FALSE)
}
\arguments{
  \item{mass}{The "real" mass}

  \item{dppm}{The mass deviation to calculate}

  \item{l}{Boolean: return limits? Defaults to FALSE.}

  \item{p}{Boolean: return ppm error itself? Defaults to
  FALSE.}
}
\value{
  By default (\code{l=FALSE, p=FALSE}) the function returns
  the mass plus the ppm error (for 123.00000 and 10 ppm:
  123.00123, or for 123 and -10 ppm: 122.99877).

  For \code{l=TRUE}, the function returns the upper and
  lower limit (sic!) For \code{p=TRUE}, just the difference
  itself is returned (0.00123 for 123/10ppm).
}
\description{
  Calculates ppm values for a given mass.
}
\details{
  This is a helper function used in RMassBank code.
}
\examples{
ppm(100, 10)
}
\author{
  Michael A. Stravs, Eawag <michael.stravs@eawag.ch>
}

