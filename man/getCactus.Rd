\name{getCactus}
\alias{getCactus}
\title{Retrieve information from Cactus}
\usage{
  getCactus(identifier, representation)
}
\arguments{
  \item{identifier}{Any identifier interpreted by the
  resolver, e.g. an InChI key or a SMILES code.}

  \item{representation}{The desired representation, as
  required from the resolver. e.g. \code{stdinchikey},
  \code{chemspider_id}, \code{formula}... Refer to the
  webpage for details.}
}
\value{
  The result of the query, in plain text. Can be NA, or one
  or multiple lines (character array) of results.
}
\description{
  Retrieves information from the Cactus Chemical Identifier
  Resolver (PubChem).
}
\details{
  It is not necessary to specify in which format the
  \code{identifier} is. Somehow, cactus does this
  automatically.
}
\note{
  Note that the InChI key is retrieved with a prefix
  (\code{InChIkey=}), which must be removed for most
  database searches in other databases (e.g. CTS).
}
\examples{
# Benzene:
getCactus("C1=CC=CC=C1", "cas")
getCactus("C1=CC=CC=C1", "stdinchikey")
getCactus("C1=CC=CC=C1", "chemspider_id")
}
\author{
  Michael Stravs
}
\references{
  cactus Chemical Identifier Resolver:
  \url{http://cactus.nci.nih.gov/chemical/structure}
}
\seealso{
  \code{\link{getCtsRecord}}, \code{\link{getPcId}}
}

