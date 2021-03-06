#' @import mzR
#' @importClassesFrom mzR
#' @importMethodsFrom mzR
# library(mzR)
NULL

#' Extract MS/MS spectra for specified precursor
#' 
#' Extracts MS/MS spectra from LC-MS raw data for a specified precursor, specified
#' either via the RMassBank compound list (see \code{\link{loadList}}) or via a mass.
#' 
#' Different versions of the function get the data from different sources.
#' 
#' @usage findMsMsHR(fileName, cpdID, mode="pH",confirmMode =0, useRtLimit = TRUE, dppm=10)
#' 
#' 		findMsMsHR.mass(msRaw, mz, limit.coarse, limit.fine, rtLimits = NA, maxCount = NA,
#' 		headerCache = NA)
#' 
#' 		findMsMsHR.direct(msRaw, cpdID, mode = "pH", confirmMode = 0,
#'  	useRtLimit = TRUE, dppm=10, limit.coarse=0.5)
#' 
#' @aliases findMsMsHR.mass findMsMsHR.direct findMsMsHR
#' @param fileName The file to open and search the MS2 spectrum in.
#' @param msRaw The opened raw file (mzR file handle) to search the MS2 spectrum in.
#' @param cpdID The compound ID in the compound list (see \code{\link{loadList}})
#' 			to use for formula lookup.
#' @param mz The mass to use for spectrum search.
#' @param dppm The limit in ppm to use for fine limit (see below) calculation.
#' @param limit.coarse The coarse limit to use for locating potential MS2 scans:
#'			this tolerance is used when finding scans with a suitable precursor
#' 			ion value.  
#' @param limit.fine The fine limit to use for locating MS2 scans: this tolerance
#' 			is used when locating an appropriate analyte peak in the MS1 precursor
#' 			spectrum.
#' @param mode The processing mode (determines which ion/adduct is searched):
#' 			\code{"pH", "pNa", "pM", "mH", "mM", "mFA"} for different ions 
#' 			([M+H]+, [M+Na]+, [M]+, [M-H]-, [M]-, [M+FA]-). 
#' @param confirmMode Whether to use the highest-intensity precursor (=0), second-
#' 			highest (=1), third-highest (=2)...
#' @param useRtLimit Whether to respect retention time limits from the compound list.
#' @param rtLimits \code{c(min, max)}: Minimum and maximum retention time to use
#' 			when locating the MS2 scans. 
#' @param headerCache If present, the complete \code{mzR::header(msRaw)}. Passing
#' 			this value is useful if spectra for multiple compounds should be 
#' 			extracted from the same mzML file, since it avoids getting the data
#' 			freshly from \code{msRaw} for every compound.
#' @param maxCount The maximal number of spectra groups to return. One spectra group
#' 			consists of all data-dependent scans from the same precursor whose precursor
#' 			mass matches the specified search mass.
#' @return	For \code{findMsMsHR} and \code{findMsMsHR.direct}: A "spectrum set", a list with items:
#' 			\item{foundOK}{\code{TRUE} if a spectrum was found, \code{FALSE} otherwise.
#' 				Note: if \code{FALSE}, all other values can be missing!}
#' 			\item{parentScan}{The scan number of the precursor scan.}
#' 			\item{parentHeader}{The header row of the parent scan, as returned by 
#' 				\code{mzR::header}.}
#' 			\item{childScans}{The scan numbers of the data-dependent MS2 scans.}
#' 			\item{childHeaders}{The header rows of the MS2 scan, as returned by
#' 				\code{mzR::header}.}
#' 			\item{parentPeak}{The MS1 precursor spectrum as a 2-column matrix}
#' 			\item{peaks}{A list of  2-column \code{mz, int} matrices of the MS2 scans.}
#' 			For \code{findMsMsHR.mass}: a list of "spectrum sets" as defined above, sorted
#' 			by decreasing precursor intensity.
#' 
#' @examples \dontrun{
#' 			loadList("mycompoundlist.csv")
#' 			# if Atrazine has compound ID 1:
#' 			msms_atrazine <- findMsMsHR("Atrazine_0001_pos.mzML", 1, "pH")
#' 			# Or alternatively:
#' 			msRaw <- openMSfile("Atrazine_0001_pos.mzML")
#' 			msms_atrazine <- findMsMsHR.direct(msRaw, 1, "pH")
#' 			# Or directly by mass (this will return a list of spectra sets):
#' 			mz <- findMz(1)$mzCenter
#' 			msms_atrazine_all <- findMsMsHR.mass(msRaw, mz, 1, ppm(msRaw, 10, p=TRUE))
#' 			msms_atrazine <- msms_atrazine_all[[1]]
#' }
#' @author Michael A. Stravs, Eawag <michael.stravs@@eawag.ch>
#' @seealso findEIC
#' @export
findMsMsHR <- function(fileName, cpdID, mode="pH",confirmMode =0, useRtLimit = TRUE, dppm=10)
{
	
	# access data directly for finding the MS/MS data. This is done using
	# mzR.
	msRaw <- openMSfile(fileName)
	ret <- findMsMsHR.direct(msRaw, cpdID, mode, confirmMode, useRtLimit, dppm)
	mzR::close(msRaw)
	return(ret)
}

#' @export
findMsMsHRperX.workflow <- function(w, mode="pH", mzabs=0.1, method="centWave",
								peakwidth=c(5,12), prefilter=c(0,0),
								ppm=25, snthr=2, MS1 = NA) {
	w@specs <- list()
	splitfn <- strsplit(w@files,'_')
	splitsfn <- splitfn[[1]]
	cpdID <- as.numeric(splitsfn[2])
	
	specs <- lapply(w@files, function(fileName){ 
							spec <- findMsMsHRperxcms.direct(fileName, cpdID, mode=mode, mzabs = mzabs, method = method,
							peakwidth = peakwidth, prefilter = prefilter, 
							ppm = ppm, snthr = snthr, MS1 = MS1)
							return(spec)
	}				)
	w@specs[[1]] <- toRMB(specs,cpdID,mode=mode)
	names(w@specs) <- basename(as.character(w@files[1]))
	w@files <- w@files[1]
	return(w)
}

#' @export
findMsMsHRperxcms.direct <- function(fileName, cpdID, mode="pH", mzabs=0.1, method="centWave",
								peakwidth=c(5,12), prefilter=c(0,0),
								ppm=25, snthr=2, MS1 = NA) {
	
	parentMass <- findMz(cpdID)$mzCenter
	RT <- findRt(cpdID)$RT * 60
	mzabs <- 0.1
	
	getRT <- function(xa) {
		rt <- sapply(xa@pspectra, function(x) {median(peaks(xa@xcmsSet)[x, "rt"])})
	}
	##
	## MS
	##
	
	
	
	##
	## MSMS
	##
	xrmsms <- xcmsRaw(fileName, includeMSn=TRUE)

	## Where is the wanted isolation ?
	precursorrange <- range(which(xrmsms@msnPrecursorMz == parentMass)) ## TODO: add ppm one day

	## Fake MS1 from MSn scans
	xrmsmsAsMs <- msn2xcms(xrmsms)

	## Fake s simplistic xcmsSet
	xsmsms <-  xcmsSet (files=fileName,
					method="MS1")

	peaks(xsmsms) <- findPeaks(xrmsmsAsMs, method="centWave", peakwidth=c(5,12),
							prefilter=c(0,0), ppm=25, snthr=2,
							scanrange=precursorrange)

	## Get pspec 
	pl <- peaks(xsmsms)[,c("mz", "rt")]

        ## Best: find precursor peak
	candidates <- which( pl[,"mz"] < parentMass + mzabs & pl[,"mz"] > parentMass - mzabs
						& pl[,"rt"] < RT * 1.1 & pl[,"rt"] > RT * 0.9 )

        
	anmsms <- xsAnnotate(xsmsms)
	anmsms <- groupFWHM(anmsms)
    
	## Now find the pspec for compound
	psp <- which(sapply(anmsms@pspectra, function(x) {candidates %in% x}))

    ## 2nd best: Spectrum closest to MS1
	##psp <- which.min( abs(getRT(anmsms) - actualRT))

    ## 3rd Best: find pspec closest to RT from spreadsheet
	##psp <- which.min( abs(abs(getRT(anmsms) - RT) )

	
	return(getpspectra(anmsms, psp))
}

#' @export
findMsMsHR.mass <- function(msRaw, mz, limit.coarse, limit.fine, rtLimits = NA, maxCount = NA,
		headerCache = NA)
{
	eic <- findEIC(msRaw, mz, limit.fine, rtLimits)
	#	if(!is.na(rtLimits))
	#	{  
	#		eic <- subset(eic, rt >= rtLimits[[1]] & rt <= rtLimits[[2]])
	#	}
	if(!is.na(headerCache))
		headerData <- headerCache
	else
		headerData <- as.data.frame(header(msRaw))
	
	# Find MS2 spectra with precursors which are in the allowed 
	# scan filter (coarse limit) range
	findValidPrecursors <- headerData[
			(headerData$precursorMZ > mz - limit.coarse) &
			(headerData$precursorMZ < mz + limit.coarse),]
	# Find the precursors for the found spectra
	validPrecursors <- unique(findValidPrecursors$precursorScanNum)
	# check whether the precursors are real: must be within fine limits!
	# previously even "bad" precursors were taken. e.g. 1-benzylpiperazine
	which_OK <- lapply(validPrecursors, function(pscan)
			{
				pplist <- as.data.frame(
						mzR::peaks(msRaw, which(headerData$acquisitionNum == pscan)))
				colnames(pplist) <- c("mz","int")
				pplist <- pplist[(pplist$mz >= mz -limit.fine)
								& (pplist$mz <= mz + limit.fine),]
				if(nrow(pplist) > 0)
					return(TRUE)
				return(FALSE)
			})
	validPrecursors <- validPrecursors[which(which_OK==TRUE)]
	# Crop the "EIC" to the valid precursor scans
	eic <- eic[eic$scan %in% validPrecursors,]
	# Order by intensity, descending
	eic <- eic[order(eic$intensity, decreasing=TRUE),]
	if(nrow(eic) == 0)
		return(list(list(foundOK = FALSE)))
	if(!is.na(maxCount))
	{
		spectraCount <- min(maxCount, nrow(eic))
		eic <- eic[1:spectraCount,]
	}
	# Construct all spectra groups in decreasing intensity order
	spectra <- lapply(eic$scan, function(masterScan)
			{
				masterHeader <- headerData[headerData$acquisitionNum == masterScan,]
				childHeaders <- headerData[(headerData$precursorScanNum == masterScan) 
					& (headerData$precursorMZ > mz - limit.coarse) 
					& (headerData$precursorMZ < mz + limit.coarse) ,]
				childScans <- childHeaders$acquisitionNum
				
				msPeaks <- mzR::peaks(msRaw, masterHeader$seqNum)
				# if deprofile option is set: run deprofiling
				deprofile.setting <- getOption("RMassBank")$deprofile
				if(!is.na(deprofile.setting))
					msPeaks <- deprofile.scan(
							msPeaks, method = deprofile.setting, noise = NA, colnames = FALSE
							)
				colnames(msPeaks) <- c("mz","int")
				msmsPeaks <- lapply(childHeaders$seqNum, function(scan)
						{
							pks <- mzR::peaks(msRaw, scan)
							if(!is.na(deprofile.setting))
							{								
								pks <- deprofile.scan(
										pks, method = deprofile.setting, noise = NA, colnames = FALSE
								)
							}
							colnames(pks) <- c("mz","int")
							return(pks)
						}
				)
				return(list(
								foundOK = TRUE,
								parentScan = masterScan,
								parentHeader = masterHeader,
								childScans = childScans,
								childHeaders= childHeaders,
								parentPeak=msPeaks,
								peaks=msmsPeaks
						#xset=xset#,
						#msRaw=msRaw
						))
			})
	names(spectra) <- eic$acquisitionNum
	return(spectra)
}

#' @export
findMsMsHR.direct <- function(msRaw, cpdID, mode = "pH", confirmMode = 0, useRtLimit = TRUE, dppm=10, limit.coarse=0.5)
{
  # for finding the peak RT: use the gauss-fitted centwave peak
  # (centroid data converted with TOPP is necessary. save as
  # mzData, since this is correctly read :P)
  #xset <- xcmsSet(fileName, method="centWave",ppm=5, fitgauss=TRUE)

  # find cpd m/z
  mzLimits <- findMz(cpdID, mode)
  mz <- mzLimits$mzCenter
  limit.fine <- ppm(mz, dppm, p=TRUE)
  if(!useRtLimit)
	  rtLimits <- NA
  else
  {
	  rtMargin <- getOption("RMassBank")$rtMargin
	  dbRt <- findRt(cpdID)
	  rtLimits <- c(dbRt$RT - rtMargin, dbRt$RT + rtMargin) * 60
  }
  spectra <- findMsMsHR.mass(msRaw, mz, limit.coarse, limit.fine, rtLimits, confirmMode + 1)
  spectra[[confirmMode + 1]]$mz <- mzLimits
  return(spectra[[confirmMode + 1]])
}


# Finds the EIC for a mass trace with a window of x ppm.
# (For ppm = 10, this is +5 / -5 ppm from the non-recalibrated mz.)
#' Extract EICs 
#' 
#' Extract EICs from raw data for a determined mass window.
#' 
#' @param msRaw The mzR file handle 
#' @param mz The mass or mass range to extract the EIC for: either a single mass
#' 			(with the range specified by \code{limit} below) or a mass range
#' 			in the form of \code{c(min, max)}. 
#' @param limit If a single mass was given for \code{mz}: the mass window to extract.
#' 			A limit of 0.001 means that the EIC will be returned for \code{[mz - 0.001, mz + 0.001]}.
#' @param rtLimit If given, the retention time limits in form \code{c(rtmin, rtmax)} in seconds.
#' @return A \code{[rt, intensity, scan]} matrix (\code{scan} being the scan number.) 
#' @author Michael A. Stravs, Eawag <michael.stravs@@eawag.ch>
#' @seealso findMsMsHR
#' @export
findEIC <- function(msRaw, mz, limit = NULL, rtLimit = NA)
{
	# calculate mz upper and lower limits for "integration"
	if(all(c("mzMin", "mzMax") %in% names(mz)))
		mzlimits <- c(mz$mzMin, mz$mzMax)
	else
		mzlimits <- c(mz - limit, mz + limit)
	# Find peaklists for all MS1 scans
	headerData <- as.data.frame(header(msRaw))
	# If RT limit is already given, retrieve only candidates in the first place,
	# since this makes everything much faster.
	if(all(!is.na(rtLimit)))
		headerMS1 <- headerData[
				(headerData$msLevel == 1) & (headerData$retentionTime >= rtLimit[[1]])
						& (headerData$retentionTime <= rtLimit[[2]])
				,]
	else
		headerMS1 <- headerData[headerData$msLevel == 1,]
	pks <- mzR::peaks(msRaw, headerMS1$seqNum)
	# Sum intensities in the given mass window for each scan
	pks_t <- unlist(lapply(pks, function(peaktable)
						sum(peaktable[which((peaktable[,1] >= mzlimits[[1]]) & (peaktable[,1] <= mzlimits[[2]])) ,2])))
	rt <- headerMS1$retentionTime
	scan <- headerMS1$acquisitionNum
	return(data.frame(rt = rt, intensity=pks_t, scan=scan))
}

#' @export
toRMB <- function(msmsXCMSspecs = NA, cpdID = NA, mode="pH", MS1spec = NA){
	if(is.na(msmsXCMSspecs)){
			stop("You need a readable spectrum!")
	}
	if(is.na(cpdID)){
			stop("Please supply the compoundID!")
	}
	numScan <- length(msmsXCMSspecs)
	ret <- list()
	ret$foundOK <- 1
	ret$parentscan <- 1
	ret$parentHeader <- matrix(0, ncol = 20, nrow = 1)
	rownames(ret$parentHeader) <-1
	colnames(ret$parentHeader) <- c("seqNum", "acquisitionNum", "msLevel", "peaksCount", "totIonCurrent", "retentionTime", "basepeakMZ", 
									"basePeakIntensity", "collisionEnergy", "ionisationEnergy", "lowMZ", "highMZ", "precursorScanNum",
									"precursorMZ", "precursorCharge", "precursorIntensity", "mergedScan", "mergedResultScanNum", 
									"mergedResultStartScanNum", "mergedResultEndScanNum")
	ret$parentHeader[1,1:3] <- 1
	##Write nothing in the parents if there is no MS1-spec
	if(is.na(MS1spec)){
		ret$parentHeader[1,4:20] <- 0
	} else { ##Else use the MS1spec spec to write everything into the parents
		ret$parentHeader[1,4] <- length(MS1spec[,1])
		ret$parentHeader[1,5] <- 0
		ret$parentHeader[1,6] <- findRt(cpdID)
		ret$parentHeader[1,7] <- MS1spec[which.max(MS1spec[,7]),1]
		ret$parentHeader[1,8] <- max(MS1spec[,7])
		ret$parentHeader[1,9] <- 0
		ret$parentHeader[1,10] <- 0
		ret$parentHeader[1,11] <- min(MS1spec[,1])
		ret$parentHeader[1,12] <- max(MS1spec[,1])
		ret$parentHeader[1,13:20] <- 0 ##Has no precursor and merge is not yet implemented
	}
	ret$parentHeader <- as.data.frame(ret$parentHeader)
	
	##Write the peaks into the childscans
	ret$childScans <- 2:(numScan+1)
	ret$childHeader <- matrix(0, ncol = 20, nrow = numScan)
	childHeader <- t(sapply(msmsXCMSspecs, function(spec){
		header <- vector()
		header[3] <- 2
		header[4] <- length(spec[,1])
		header[5] <- 0 ##Does this matter?
		header[6] <- median(spec[,4])
		header[7] <- spec[which.max(spec[,7]),1]
		header[8] <- max(spec[,7])
		header[9] <- 0 ##Does this matter?
		header[10] <- 0 ##Does this matter?
		header[11] <- min(spec[,1])
		header[12] <- max(spec[,1]) 
		header[13] <- 1
		header[14] <- findMz(cpdID)[[3]]
		header[15] <- -1 ##Will be changed for different charges
		header[16] <- 0 ##There sadly isnt any precursor intensity to find in the msms-scans. Workaround? msmsXCMS@files[1]
		header[17:20] <- 0 ##Will be changed if merge is wanted
		return(header)
		}))
		childHeader[,1:2] <- 2:(length(msmsXCMSspecs)+1)
	
	
	ret$childHeader <- as.data.frame(childHeader)
	rownames(ret$childHeader) <- 2:(numScan+1)
	colnames(ret$childHeader) <- c("seqNum", "acquisitionNum", "msLevel", "peaksCount", "totIonCurrent", "retentionTime", "basepeakMZ", 
									"basePeakIntensity", "collisionEnergy", "ionisationEnergy", "lowMZ", "highMZ", "precursorScanNum",
									"precursorMZ", "precursorCharge", "precursorIntensity", "mergedScan", "mergedResultScanNum", 
									"mergedResultStartScanNum", "mergedResultEndScanNum")
	
	ret$parentPeak <- matrix(nrow = 1, ncol = 2)
	colnames(ret$parentPeak) <- c("mz","int")
	ret$parentPeak[1,] <- c(findMz(cpdID,mode=mode)$mzCenter,100)
	ret$peaks <- list()
	ret$peaks <- lapply (msmsXCMSspecs, function(specs){
									peaks <- matrix(nrow = length(specs[,1]), ncol = 2)
									colnames(peaks) <- c("mz","int")
									peaks[,1] <- specs[,1]
									peaks[,2] <- specs[,7]
									return(peaks)
								})
	ret$mz <- findMz(cpdID,mode=mode)
	ret$id <- cpdID
	ret$formula <- findFormula(cpdID)
	return(ret)
}

#' @export
addPeaksManually <- function(w, cpdID, handSpec, mode = "pH"){
	childHeaderAddition <- t(sapply(handSpec, function(spec){
			header <- vector()
			header[3] <- 2
			header[4] <- length(spec[,1])
			header[5] <- 0 ##Does this matter?
			header[6] <- findRt(cpdID)$RT * 60
			header[7] <- spec[which.max(spec[,2]),1]
			header[8] <- max(spec[,2])
			header[9] <- 0 ##Does this matter?
			header[10] <- 0 ##Does this matter?
			header[11] <- min(spec[,1])
			header[12] <- max(spec[,1])
			header[13] <- 1
			header[14] <- findMz(cpdID)[[3]]
			header[15] <- -1 ##Will be changed for different charges
			header[16] <- 0 ##There sadly isnt any precursor intensity to find in the msms-scans. Workaround? msmsXCMS@files[1]
			header[17:20] <- 0 ##Will be changed if merge is wanted
			return(header)
		}))
	##Set colnames and rownames
	colnames(childHeaderAddition) <- c("seqNum", "acquisitionNum", "msLevel", "peaksCount", "totIonCurrent", "retentionTime", "basepeakMZ", 
										"basePeakIntensity", "collisionEnergy", "ionisationEnergy", "lowMZ", "highMZ", "precursorScanNum",
										"precursorMZ", "precursorCharge", "precursorIntensity", "mergedScan", "mergedResultScanNum", 
										"mergedResultStartScanNum", "mergedResultEndScanNum")
	##Convert the manual peaklists
	peaksHand <- lapply (handSpec, function(specs){
							peaks <- matrix(nrow = length(specs[,1]), ncol = 2)
							colnames(peaks) <- c("mz","int")
							peaks <- specs
							return(peaks)
						})
	
	##Where do the peaks and the header need to be added?
	pos <- sapply(w@specs,function(spec){cpdID %in% spec$id})
	##If the compound for the cpdID isn't in specs yet, add a new spectrum
	if(length(pos) == 0){
		pos <- length(w@specs) + 1
		childHeaderAddition[,1:2] <- 1
		w@specs[[pos]] <- list()
		w@specs[[pos]]$foundOK <- 1
		w@specs[[pos]]$parentscan <- 1
		w@specs[[pos]]$parentHeader <- matrix(0, ncol = 20, nrow = 1)
		rownames(w@specs[[pos]]$parentHeader) <- 1
		colnames(w@specs[[pos]]$parentHeader) <- c("seqNum", "acquisitionNum", "msLevel", "peaksCount", "totIonCurrent", "retentionTime", "basepeakMZ", 
									"basePeakIntensity", "collisionEnergy", "ionisationEnergy", "lowMZ", "highMZ", "precursorScanNum",
									"precursorMZ", "precursorCharge", "precursorIntensity", "mergedScan", "mergedResultScanNum", 
									"mergedResultStartScanNum", "mergedResultEndScanNum")
		w@specs[[pos]]$parentHeader[1,1:3] <- 1
		w@specs[[pos]]$parentHeader[1,4:20] <- 0
		w@specs[[pos]]$childScans <- 1
		w@specs[[pos]]$childHeader <- childHeaderAddition
		w@specs[[pos]]$parentPeak <- matrix(nrow = 1, ncol = 2)
		colnames(w@specs[[pos]]$parentPeak) <- c("mz","int")
		w@specs[[pos]]$parentPeak[1,] <- c(findMz(cpdID,mode=mode)$mzCenter,100)
		w@specs[[pos]]$peaks <- peaksHand
		w@specs[[pos]]$mz <- findMz(cpdID,mode=mode)
		w@specs[[pos]]$id <- cpdID
		w@specs[[pos]]$formula <- findFormula(cpdID)
	} else { pos <- which(pos)
			w@specs[[pos]]$childHeader <- rbind(w@specs[[pos]]$childHeader,childHeaderAddition)
			w@specs[[pos]]$peaks <- c(w@specs[[pos]]$peaks, peaksHand) }
		
		return(w)
}

#' @export
addMB <- function(w, cpdID, fileName, mode){
	mb <- parseMassBank(fileName)
	peaklist <- list()
	peaklist[[1]] <- mb@compiled_ok[[1]][["PK$PEAK"]][,1:2]
	w <- addPeaksManually(w, cpdID, peaklist[[1]], mode)
	return(w)
}