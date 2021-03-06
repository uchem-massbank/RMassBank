\name{findMass}
\alias{findMass}
\title{Calculate exact mass}
\usage{
  findMass(cpdID_or_smiles)
}
\arguments{
  \item{cpdID_or_smiles}{SMILES code or compound ID of the
  molecule. (Numerics are treated as compound ID).}
}
\value{
  Returns the exact mass of the uncharged molecule.
}
\description{
  Retrieves the exact mass of the uncharged molecule. It
  works directly from the SMILES and therefore is used in
  the MassBank workflow (\code{\link{mbWorkflow}}) - there,
  all properties are calculated from the SMILES code
  retrieved from the database. (Alternatively, takes also
  the compound ID as parameter and looks it up.)
  Calculation relies on Rcdk.
}
\examples{
##
findMass("OC[C@H]1OC(O)[C@H](O)[C@@H](O)[C@@H]1O")
}
\author{
  Michael Stravs
}
\seealso{
  \code{\link{findMz}}
}

