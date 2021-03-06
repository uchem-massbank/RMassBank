\name{order.formula}
\alias{order.formula}
\title{Order a chemical formula correctly}
\usage{
  order.formula(formula, as.formula = TRUE, as.list =
    FALSE)
}
\arguments{
  \item{formula}{A molecular formula in string or list
  representation (\code{"C6H6"} or \code{list(C=6,H=6)}).}

  \item{as.formula}{If \code{TRUE}, the return value is
  returned as a string. This is the default.}

  \item{as.list}{If \code{TRUE}, the return value is
  returned in list representation.}
}
\description{
  Orders a chemical formula in the commonly accepted order
  (CH followed by alphabetic ordering).
}
\examples{
#
order.formula("H4C9")
order.formula("C2N5HClBr")
}
\author{
  Michele Stravs
}
\seealso{
  \code{\link{list.to.formula}}, \code{\link{add.formula}},
  \code{\link{is.valid.formula}}
}

