\name{findEIC}
\alias{findEIC}
\title{Extract EICs}
\usage{
  findEIC(msRaw, mz, limit = NULL, rtLimit = NA)
}
\arguments{
  \item{msRaw}{The mzR file handle}

  \item{mz}{The mass or mass range to extract the EIC for:
  either a single mass (with the range specified by
  \code{limit} below) or a mass range in the form of
  \code{c(min, max)}.}

  \item{limit}{If a single mass was given for \code{mz}:
  the mass window to extract.  A limit of 0.001 means that
  the EIC will be returned for \code{[mz - 0.001, mz +
  0.001]}.}

  \item{rtLimit}{If given, the retention time limits in
  form \code{c(rtmin, rtmax)} in seconds.}
}
\value{
  A \code{[rt, intensity, scan]} matrix (\code{scan} being
  the scan number.)
}
\description{
  Extract EICs from raw data for a determined mass window.
}
\author{
  Michael A. Stravs, Eawag <michael.stravs@eawag.ch>
}
\seealso{
  findMsMsHR
}

