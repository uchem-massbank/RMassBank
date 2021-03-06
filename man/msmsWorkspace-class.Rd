\docType{class}
\name{msmsWorkspace-class}
\alias{msmsWorkspace-class}
\alias{show,msmsWorkspace-method}
\title{Workspace for \code{msmsWorkflow} data}
\description{
  A workspace which stores input and output data for
  \code{\link{msmsWorkflow}}.
}
\details{
  Slots:

  \describe{ \item{files}{The input file names}
  \item{specs}{The spectra extracted from the raw files}
  \item{analyzedSpecs}{The spectra with annotated peaks
  after workflow step 2.} \item{aggregatedSpecs}{The
  \code{analyzedSpec} data regrouped and aggregated, after
  workflow step 3.} \item{rc, rc.ms1}{The recalibration
  curves generated in workflow step 4.}
  \item{recalibratedSpecs}{The spectra from \code{specs}
  recalibrated with the curves from \code{rc, rc,ms1}.}
  \item{analyzedRcSpecs}{The recalibrated spectra with
  annotated peaks after workflow step 5.}
  \item{aggregatedRcSpecs}{The \code{analyzedRcSpec} data
  regrouped and aggregated, after workflow step 6.}
  \item{reanalyzedRcSpecs}{The regrouped and aggregated
  spectra, with added reanalyzed peaks (after step 7, see
  \code{\link{reanalyzeFailpeaks}}).}
  \item{refilteredRcSpecs}{Final data to use for MassBank
  record creation after multiplicity filtering (step 8).} }

  Methods: \describe{ \item{show}{Shows a brief summary of
  the object. Currently only the included files.} }
}
\author{
  Michael Stravs, Eawag <michael.stravs@eawag.ch>
}
\seealso{
  \code{\link{msmsWorkflow}}
}

