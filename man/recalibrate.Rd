\name{recalibrate}
\alias{recalibrate}
\alias{recalibrate.loess}
\title{Predefined recalibration functions.}
\usage{
  recalibrate.loess(rcdata)
}
\arguments{
  \item{rcdata}{A data frame with at least the columns
  \code{recalfield} and \code{mzFound}. \code{recalfield}
  will usually contain delta(ppm) or delta(mz) values and
  is the target parameter for the recalibration.}
}
\value{
  Returns a model for recalibration to be used with
  \code{predict} and the like.
}
\description{
  Predefined fits to use for recalibration: Loess fit and
  GAM fit.
}
\details{
  Provides a Loess fit (\code{recalibrate.loess}) to a
  given recalibration parameter. If MS and MS/MS data
  should be fit together, recalibrate.loess provides good
  default settings for Orbitrap instruments.

  \code{recalibrate()} itself is only a dummy function and
  does not do anything.

  Alternatively other functions can be defined. Which
  functions are used for recalibration is specified by the
  RMassBank options file. (Note: if \code{recalibrateMS1:
  common}, the \code{recalibrator: MS1} value is
  irrelevant, since for a common curve generated with the
  function specified in \code{recalibrator: MS2} will be
  used.)
}
\examples{
\dontrun{
rcdata <- subset(spec$peaksMatched, formulaCount==1)
ms1data <- recalibrate.addMS1data(spec, mode, 15)
rcdata <- rbind(rcdata, ms1data)
rcdata$recalfield <- rcdata$dppm
rcCurve <- recalibrate.loess(rcdata)
# define a spectrum and recalibrate it
s <- matrix(c(100,150,200,88.8887,95.0005,222.2223), ncol=2)
colnames(s) <- c("mz", "int")
recalS <- recalibrateSingleSpec(s, rcCurve)

Alternative: define an custom recalibrator function with different parameters
recalibrate.MyOwnLoess <- function(rcdata)
{
	return(loess(recalfield ~ mzFound, data=rcdata, family=c("symmetric"),
					degree = 2, span=0.4))
}
# This can then be specified in the RMassBank settings file:
# recalibrateMS1: common
# recalibrator:
#    MS1: recalibrate.loess
#    MS2: recalibrate.MyOwnLoess")
# [...]
}
}
\author{
  Michael Stravs, EAWAG <michael.stravs@eawag.ch>
}

