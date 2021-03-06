\docType{class}
\name{mbWorkspace-class}
\alias{mbWorkspace-class}
\alias{show,mbWorkspace-method}
\title{Workspace for \code{mbWorkflow} data}
\description{
  A workspace which stores input and output data for use
  with \code{mbWorkflow}.
}
\details{
  Slots: \describe{ \item{aggregatedRcSpecs,
  refilteredRcSpecs}{The corresponding input data from
  \code{\link{msmsWorkspace-class}}}
  \item{additionalPeaks}{A list of additional peaks which
  can be loaded using \code{\link{addPeaks}}.}
  \item{mbdata, mbdata_archive, mbdata_relisted}{Infolist
  data: Data for annotation of MassBank records, which can
  be loaded using \code{\link{loadInfolists}}.}
  \item{compiled, compiled_ok}{ Compiled tree-structured
  MassBank records. \code{compiled_ok} contains only the
  compounds with at least one valid spectrum.}
  \item{mbfiles}{Compiled MassBank records in text
  representation.} \item{molfile}{MOL files with the
  compound structures.} \item{ok,problems}{Index lists for
  internal use which denote which compounds have valid
  spectra.} }

  Methods: \describe{ \item{show}{Shows a brief summary of
  the object. Currently only a stub.} }
}
\author{
  Michael Stravs, Eawag <michael.stravs@eawag.ch>
}
\seealso{
  \code{\link{mbWorkflow}}
}

