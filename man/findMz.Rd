\name{findMz}
\alias{findCAS}
\alias{findFormula}
\alias{findMz}
\alias{findName}
\alias{findRt}
\alias{findSmiles}
\title{Find compound information}
\usage{
  findMz(cpdID, mode = "pH", ppm = 10, deltaMz = 0)

  findRt(cpdID)

  findSmiles(cpdID)

  findFormula(cpdID)

  findCAS(cpdID)

  findName(cpdID)
}
\arguments{
  \item{cpdID}{The compound ID in the compound list.}

  \item{mode}{Specifies the species of the molecule: An
  empty string specifies uncharged monoisotopic mass,
  \code{\var{pH}} (positive H) specifies [M+H]+,
  \code{\var{pNa}} specifies [M+Na]+, \code{\var{pM}}
  specifies [M]+, \code{\var{mH}} and \code{\var{mFA}}
  specify [M-H]- and [M+FA]-, respectively. (I apologize
  for the naming of \code{\var{pH}} which has absolutely
  nothing to do with chemical \emph{pH} values.)}

  \item{ppm}{Specifies ppm window (10 ppm will return the
  range of the molecular mass + and - 10 ppm).}

  \item{deltaMz}{Specifies additional m/z window to add to
  the range (deltaMz = 0.02 will return the range of the
  molecular mass +- 0.02 (and additionally +- the set ppm
  value).}
}
\value{
  \code{findMz} will return a \code{list(mzCenter=, mzMin=,
  mzMax=)} with the molecular weight of the given ion, as
  calculated from the SMILES code and Rcdk.

  \code{findRt},
  \code{findSmiles},\code{findCAS},\code{findName} will
  return the corresponding entry from the compound list.
  \code{findFormula} returns the molecular formula as
  determined from the SMILES code.
}
\description{
  Retrieves compound information from the loaded compound
  list or calculates it from the SMILES code in the list.
}
\examples{
\dontrun{\%
	findMz(123, "pH", 5)
	findFormula(123)
}
}
\author{
  Michael Stravs
}
\seealso{
  \code{\link{findMass}}, \code{\link{loadList}},
  \code{\link{findMz.formula}}
}

