\name{loadInfolists}
\alias{loadInfolist}
\alias{loadInfolists}
\alias{resetInfolists}
\title{Load MassBank compound information lists}
\usage{
  loadInfolists(mb, path)

  loadInfolist(mb, fileName)

  resetInfolists(mb)
}
\arguments{
  \item{path}{Directory in which the namelists reside. All
  CSV files in this directory will be loaded.}

  \item{fileName}{A single namelist to be loaded.}

  \item{mb}{The \code{mbWorkspace} to load/reset the lists
  in.}
}
\value{
  The new workspace with loaded/reset lists.
}
\description{
  Loads MassBank compound information lists (i.e. the lists
  which were created in the first two steps of the MassBank
  \code{\link{mbWorkflow}} and subsequently edited by
  hand.).
}
\details{
  \code{resetInfolists} clears the information lists, i.e.
  it creates a new empty list in \code{mbdata_archive}.
  \code{loadInfolist} loads a single CSV file, whereas
  \code{loadInfolists} loads a whole directory.
}
\examples{
#
\dontrun{mb <- resetInfolists(mb)
	mb <- loadInfolist(mb, "my_csv_infolist.csv")}
}
\author{
  Michael Stravs
}

