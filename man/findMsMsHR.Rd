\name{findMsMsHR}
\alias{findMsMsHR}
\alias{findMsMsHR.direct}
\alias{findMsMsHR.mass}
\title{Extract MS/MS spectra for specified precursor}
\usage{
  findMsMsHR(fileName, cpdID, mode="pH",confirmMode =0,
    useRtLimit = TRUE, dppm=10)

  findMsMsHR.mass(msRaw, mz, limit.coarse, limit.fine,
    rtLimits = NA, maxCount = NA, headerCache = NA)

  findMsMsHR.direct(msRaw, cpdID, mode = "pH", confirmMode
    = 0, useRtLimit = TRUE, dppm=10, limit.coarse=0.5)
}
\arguments{
  \item{fileName}{The file to open and search the MS2
  spectrum in.}

  \item{msRaw}{The opened raw file (mzR file handle) to
  search the MS2 spectrum in.}

  \item{cpdID}{The compound ID in the compound list (see
  \code{\link{loadList}}) to use for formula lookup.}

  \item{mz}{The mass to use for spectrum search.}

  \item{dppm}{The limit in ppm to use for fine limit (see
  below) calculation.}

  \item{limit.coarse}{The coarse limit to use for locating
  potential MS2 scans: this tolerance is used when finding
  scans with a suitable precursor ion value.}

  \item{limit.fine}{The fine limit to use for locating MS2
  scans: this tolerance is used when locating an
  appropriate analyte peak in the MS1 precursor spectrum.}

  \item{mode}{The processing mode (determines which
  ion/adduct is searched): \code{"pH", "pNa", "pM", "mH",
  "mM", "mFA"} for different ions ([M+H]+, [M+Na]+, [M]+,
  [M-H]-, [M]-, [M+FA]-).}

  \item{confirmMode}{Whether to use the highest-intensity
  precursor (=0), second- highest (=1), third-highest
  (=2)...}

  \item{useRtLimit}{Whether to respect retention time
  limits from the compound list.}

  \item{rtLimits}{\code{c(min, max)}: Minimum and maximum
  retention time to use when locating the MS2 scans.}

  \item{headerCache}{If present, the complete
  \code{mzR::header(msRaw)}. Passing this value is useful
  if spectra for multiple compounds should be extracted
  from the same mzML file, since it avoids getting the data
  freshly from \code{msRaw} for every compound.}

  \item{maxCount}{The maximal number of spectra groups to
  return. One spectra group consists of all data-dependent
  scans from the same precursor whose precursor mass
  matches the specified search mass.}
}
\value{
  For \code{findMsMsHR} and \code{findMsMsHR.direct}: A
  "spectrum set", a list with items:
  \item{foundOK}{\code{TRUE} if a spectrum was found,
  \code{FALSE} otherwise.  Note: if \code{FALSE}, all other
  values can be missing!} \item{parentScan}{The scan number
  of the precursor scan.} \item{parentHeader}{The header
  row of the parent scan, as returned by
  \code{mzR::header}.} \item{childScans}{The scan numbers
  of the data-dependent MS2 scans.} \item{childHeaders}{The
  header rows of the MS2 scan, as returned by
  \code{mzR::header}.} \item{parentPeak}{The MS1 precursor
  spectrum as a 2-column matrix} \item{peaks}{A list of
  2-column \code{mz, int} matrices of the MS2 scans.} For
  \code{findMsMsHR.mass}: a list of "spectrum sets" as
  defined above, sorted by decreasing precursor intensity.
}
\description{
  Extracts MS/MS spectra from LC-MS raw data for a
  specified precursor, specified either via the RMassBank
  compound list (see \code{\link{loadList}}) or via a mass.
}
\details{
  Different versions of the function get the data from
  different sources.
}
\examples{
\dontrun{
			loadList("mycompoundlist.csv")
			# if Atrazine has compound ID 1:
			msms_atrazine <- findMsMsHR("Atrazine_0001_pos.mzML", 1, "pH")
			# Or alternatively:
			msRaw <- openMSfile("Atrazine_0001_pos.mzML")
			msms_atrazine <- findMsMsHR.direct(msRaw, 1, "pH")
			# Or directly by mass (this will return a list of spectra sets):
			mz <- findMz(1)$mzCenter
			msms_atrazine_all <- findMsMsHR.mass(msRaw, mz, 1, ppm(msRaw, 10, p=TRUE))
			msms_atrazine <- msms_atrazine_all[[1]]
}
}
\author{
  Michael A. Stravs, Eawag <michael.stravs@eawag.ch>
}
\seealso{
  findEIC
}

