### Tests the S4 Object functionalities of RDataTracker
# Originally created by Barbara Lerner

# Modified by Luis Perez 7-Jul-2014
# Modified by Luis Perez 17-Jul-2014

#ddg.library <- Sys.getenv("DDG_LIBRARY")
#if (ddg.library == "") {
#	ddg.library <- "c:/data/r/ddg/lib/ddg-library.r"
#}
#source("/Users/barbaralerner/Documents/Process/DataProvenance/github/RDataTracker/R/RDataTracker.R")
library(RDataTracker)
require(methods)
# ddg.debug.on()
# options(warn=2)

# get initial time
startTime <- Sys.time()
invisible(force(startTime))

## Directories
testDir <- "[DIR_DEFAULT]/"
setwd(testDir)

ddg.r.script.path = paste(testDir,"S4ObjectTest.R",sep="")
ddg.path = paste(testDir,"[DDG-DIR]",sep="")

# Initialize the provenance graph
ddg.init(ddg.r.script.path,
         ddg.path,
    enable.console=TRUE)


#setGeneric("toString", function(object) {
#			standardGeneric("toString")
#		})

setClass("SampleObj",
		slots = c(
				sampleCode = "integer", 
				nIndividuals = "integer", 
				areaCode = "integer"))

as.character.SampleObj <- function(x) {
#toString.SampleObj <- function(object) {
	str <- paste("sampleCode =", x@sampleCode, "\n")
	str <- paste(str, "nIndividuals =", x@nIndividuals, "\n")
	str <- paste(str, "areaCode =", x@areaCode, "\n")
	return(str)
}
#
#as.character.SampleObj <- function(x) {
#	toString.SampleObj(x)
#}

#setMethod("toString", 
##setMethod("as.vector", 
##		signature(object = "SampleObj", mode = "character"),
#		signature(object = "SampleObj"),
#		toString.SampleObj)
#		
setMethod("as.character", 
		signature(x = "SampleObj"),
		as.character.SampleObj)

generateSamples <- function (n) {
	ddg.start()
	samplesArr <- list()
	ddg.procedure("new samples", outs.data=list("samplesArr"))
	for (ix in 1:n) {
		newSample <- new ("SampleObj", 
				sampleCode = ix, 
				nIndividuals = as.integer(ix * 10), 
				areaCode = as.integer(ix * 100))
		ddg.procedure("new sample", outs.data=list("newSample"))
		ddg.procedure("add to samples", ins=list("newSample", "samplesArr"))
		samplesArr = c(samplesArr, newSample)
		ddg.data.out(samplesArr, pname="add to samples")
				
	}
	ddg.finish()
	return (samplesArr)
}

generate1Sample <- function () {
	ddg.start()
	newSample <- new ("SampleObj", 
				sampleCode = as.integer(1), 
				nIndividuals = as.integer(10), 
				areaCode = as.integer(100))
	ddg.procedure("new sample", outs.data=list("newSample"))
		
	ddg.finish()
	return (newSample)
}

totalNumOfSample <- 5
newSample <- generate1Sample()
samplesArr <- generateSamples(totalNumOfSample)
ddg.save(quit=TRUE)

# Calculate total time of execution
endTime <- Sys.time()
cat("Execution Time =", difftime(endTime,startTime,"secs"))
