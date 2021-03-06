\name{filterLowaccResults}
\alias{filterLowaccResults}
\title{Filter peaks with low accuracy}
\usage{
  filterLowaccResults(peaks, mode = "fine")
}
\arguments{
  \item{peaks}{A data frame with at least the columns
  \code{mzFound} and \code{dppm}.}

  \item{mode}{\code{coarse} or \code{fine}, see below.}
}
\value{
  A \code{list(TRUE = goodPeakDataframe, FALSE =
  badPeakDataframe)} is returned: A data frame with all
  peaks which are "good" is in \code{return[["TRUE"]]}.
}
\description{
  Filters a peak table (with annotated formulas) for
  accuracy. Low-accuracy peaks are removed.
}
\details{
  In the \code{coarse} mode, mass tolerance is set to 10
  ppm (above m/z 120) and 15 ppm (below m/z 120). This is
  useful for formula assignment before recalibration, where
  a wide window is desirable to accomodate the high mass
  deviations at low m/z values, so we get a nice
  recalibration curve.

  In the \code{fine} run, the mass tolerance is set to 5
  ppm over the whole mass range. This should be applied
  after recalibration.
}
\examples{
# from analyzeMsMs:
\dontrun{childPeaksFilt <- filterLowaccResults(childPeaksInt, filterMode)}
}
\author{
  Michael Stravs
}
\seealso{
  \code{\link{analyzeMsMs}},
  \code{\link{filterPeakSatellites}}
}

