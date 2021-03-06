\name{parseMassBank}
\alias{parseMassBank}
\title{Parses a MassBank-record}
\usage{
  parseMassBank(Files)
}
\arguments{
  \item{Files}{The filepath to the plaintext-records}
}
\value{
  An mbWorkspace with the record in "compiled_ok"
}
\description{
  Reads a plaintext-MassBankrecord 
}
\details{
  Reading Annotations does not work at the moment
}
\author{
  Erik Mueller
}
\seealso{
  \code{\link{validate}},
  \code{\link{mbWorkspace-class}}
}

