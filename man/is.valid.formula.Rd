\name{is.valid.formula}
\alias{is.valid.formula}
\title{Check validity of formula}
\usage{
  is.valid.formula(formula)
}
\arguments{
  \item{formula}{A molecular formula in string or list
  representation (\code{"C6H6"} or \code{list(C=6,H=6)}).}
}
\description{
  Checks whether the formula is chemically valid, i.e. has
  no zero-count or negative-count elements.
}
\details{
  The check is only meant to identify formulas which have
  negative elements, which can arise from the subtraction
  of adducts.  It is \bold{not} a high-level formula
  "validity" check like e.g. the Rcdk function
  \code{isvalid.formula} which uses the nitrogen rule or a
  DBE rule.
}
\examples{
#
is.valid.formula(list(C=0,H=1,Br=2))
is.valid.formula("CH2Cl")
is.valid.formula("C0H2")
}
\author{
  Michael Stravs
}
\seealso{
  \code{\link{list.to.formula}}, \code{\link{add.formula}},
  \code{\link{order.formula}}
}

