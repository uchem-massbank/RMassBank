\name{RmbDefaultSettings}
\alias{RmbDefaultSettings}
\alias{RmbSettingsTemplate}
\alias{loadRmbSettings}
\alias{loadRmbSettingsFromEnv}
\title{RMassBank settings}
\usage{
  loadRmbSettings(file_or_list)

  loadRmbSettingsFromEnv(env = .GlobalEnv)

  RmbDefaultSettings()

  RmbSettingsTemplate(target)
}
\arguments{
  \item{file_or_list}{The file (YML or R format) or R
  \code{list} with the settings to load.}

  \item{target}{The path where the template setting file
  should be stored.}

  \item{env}{The environment to load the settings from.}
}
\value{
  None.
}
\description{
  Load, set and reset settings for RMassBank.
}
\details{
  \code{RmbSettingsTemplate} creates a template file in
  which you can adjust the settings as you like. Before
  using RMassBank, you must then load the settings file
  using \code{loadRmbSettings}. \code{RmbDefaultSettings}
  loads the default settings. \code{loadRmbSettingsFromEnv}
  loads the settings stored in env$RmbSettings, which is
  useful when reloading archives with saved settings
  inside.

  Note: no settings are loaded upon loading MassBank! This
  is intended, so that one never forgets to load the
  correct settings.

  The settings are described in \code{\link{RmbSettings}}.
}
\note{
  \bold{The default settings will not work for you unless
  you have, by chance, installed OpenBabel into the same
  directory as I have!}
}
\examples{
# Create a standard settings file and load it (unedited)
	RmbSettingsTemplate("mysettings.ini")
 loadRmbSettings("mysettings.ini")
 unlink("mysettings.ini")
}
\author{
  Michael Stravs
}
\seealso{
  \code{\link{RmbSettings}}
}

