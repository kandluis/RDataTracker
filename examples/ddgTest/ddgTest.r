# Tests of ddg functions.  No useful computation here.
# This test contains some deliberate errors to be sure that reasonable things
#   happen when the user does unreasonable things.  These are the warnings
#   that are expected.

#Warning messages:
#Warning in .ddg.insert.error.message(error.msg) :
#		Unable to evaluate ww in call to ddg.data
#Warning in .ddg.insert.error.message(error.msg) :
#		Unable to evaluate xx in call to ddg.data
#Warning in .ddg.insert.error.message(error.msg) :
#		Skipping parameter vector
#Warning in .ddg.insert.error.message(error.msg) : Skipping parameter 
#Warning in .ddg.insert.error.message(error.msg) :
#		No data node found for a b c
#Warning in .ddg.insert.error.message(error.msg) :
#		No data node found for no.such.data.node
#Warning in .ddg.insert.error.message(error.msg) :
#		File to copy does not exist: missingfile.txt
#Warning in .ddg.insert.error.message(error.msg) :
#		File to copy does not exist: missingdir/abc.txt
#Warning in .ddg.insert.error.message(error.msg) :
#		No data node found for missingfile.txt
#Warning in .ddg.insert.error.message(error.msg) :
#		No data node found for abc.txt
#Warning in .ddg.insert.error.message(error.msg) :
#		No procedure node found for no.such.function
#Warning in .ddg.insert.error.message(error.msg) :
#		Unable to evaluate out6 in call to ddg.data.out
#Warning in .ddg.insert.error.message(error.msg) :
#		File to copy does not exist: missingfile.txt
#Warning in .ddg.insert.error.message(error.msg) :
#		No data node found for missingfile.txt
#Warning in .ddg.insert.error.message(error.msg) :
#		File to copy does not exist: missingdir/abc.txt
#Warning in .ddg.insert.error.message(error.msg) :
#		No data node found for abc.txt
#Warning in .ddg.insert.error.message(error.msg) :
#		No procedure node found for no.such.function
#Warning in .ddg.insert.error.message(error.msg) :
#		Unable to evaluate exc6 in call to ddg.exception.out

## Directories

#ddg.library <- Sys.getenv("DDG_LIBRARY")
#if (ddg.library == "") {
#	ddg.library <- "c:/data/r/ddg/lib/ddg-library.r"
#}
#source(ddg.library)
library(RDataTracker)

### Functions
no.name.or.args.given <- function (a, b, c, d, e, f) {
	ddg.procedure()
}

lookup.args <- function (a, b, c, d, e, f) {
	ddg.procedure(lookup.ins = TRUE)
}

only.args.given <- function (a, b, y, d, e, f) {
	ddg.procedure(ins=list("w", "x", y, "z", "x + 1"))
}

only.name.given <- function (a, b, c, d, e, f) {
	ddg.procedure(only.name.given)
}

string.name.and.args.given <- function (a, b, c, d, e, f) {
	ddg.procedure("string.name.and.args.given", list("w", "x", "y", "z", "x + 1"))
}

data.in.test <- function(arg1) {
	ddg.procedure("data.in.test")
	ddg.data.in(dname="x")
}

out.test.1 <- function() {
	ddg.procedure()
	ddg.data.out(dname="out3", dvalue="c")
}

url.out.test <- function() {
	ddg.procedure()
	ddg.url.out(dname="MHC home", dvalue="https://www.mtholyoke.edu/")
}

snapshot.out.test <- function(df) {
	ddg.procedure()
	ddg.snapshot.out("pets4", "csv", df)
}

file.out.test <- function() {
	ddg.procedure()
	ddg.file.out(filename="testfile3.txt")
}

exc.test. <- function() {
	ddg.procedure()
	ddg.exception.out(dname="exc3", dvalue="c")
}

start.finish.test <- function() {
	ddg.start()
	ddg.finish()
}

main <- function() {
	options(warn=1)
	
	ddg.start("main")
	# Test ddg.data
	x <- 1+2
	ddg.data("x", x)  # String name, explicit value
	y <- paste("a", "b", "c")
	ddg.data(y)  # Name as name, no value
	ddg.data(x + 1)  # Expression for name, no value
	z <- x + 2
	ddg.data ("z")  # String name, no value
	w <- x + 3
	ddg.data(w, w)  # Name as name, explicit value
	ddg.data(ww)  # No value and there is no object with the given name
	ddg.data("xx")  # No value and there is no object with the given name
	
	# Test ddg.procedure
	no.name.or.args.given(w, x, y, z, x + 1, vector())
	lookup.args(w, x, y, z, x + 1, vector())
	only.args.given(w, x, y, z,  x + 1, vector())
	only.name.given(w, x, y, z,  x + 1, vector())
	string.name.and.args.given(w, x, y, z,  x + 1, vector())
	ddg.procedure("no.func")  # For the case where the name does not correspond to a function.  Must be a string in this case
	ddg.procedure("f0", list("no.such.data.node"))  # What happens if we try to use a data node that doesn't exist?
	simple.value <- 10
	ddg.procedure("g0", outs.data=list("simple.value"))
	year <- c(1992, 1995)
	name <- c("Ben", "Greg")
	male <- c(TRUE, TRUE) 
	kids.df <- data.frame(year, name, male)
	outfile <- "/Users/blerner/tmp/testfile2.txt"
	outfile2 <- "/Users/blerner/tmp/testfile3.txt"
	writeLines("All good dogs", outfile)
	writeLines("To be or not to be", outfile2)
	ddg.procedure("g1", outs.snapshot=list("kids.df", year), outs.file=list(outfile, "outfile2"))
	
	# Test ddg.url
	ddg.url("HF home page", "http://harvardforest.fas.harvard.edu/")
	
	# Test ddg.exception
	ddg.exception("error", "test error")
	error2 <- "Trivial error"
	ddg.exception(error2)
	
	# Test ddg.data.in
	ddg.procedure("f")
	ddg.data.in("HF home page", "f")
	ddg.data.in("error", "f")
	ddg.data.in(error2, "f")
	data.in.test(x)
	
	# Test ddg.snapshot
	year <- c(1991, 1998, 2011)
	name <- c("Sterling", "Smuggles", "Snickers")
	male <- c(FALSE, FALSE, FALSE) 
	pets.df <- data.frame(year, name, male)
	ddg.snapshot("pets", "csv", pets.df)
	ddg.snapshot("pets.df", "csv")
	pets2 <- pets.df
	ddg.snapshot(pets2, "csv")
	pets3 <- pets.df
	ddg.snapshot(pets3, "csv", pets3)
	pets4 <- pets.df
	ddg.snapshot(pets4)
	ddg.procedure("f2", list("pets", "pets.df", "pets2", "pets3", "pets4"))
	
	# Test ddg.file
	ddg.file("/Users/blerner/Documents/Process/DataProvenance/workspace/ddg-r/src/laser/ddg/r/RCheckpointNode.java")
	ddg.file("testfile.txt", "test")  # Directory is optional
	ddg.file("missingfile.txt")  # What happens if the file is not there?
	ddg.file("missingdir/abc.txt")  # What happens if the directory does not exist?
	ddg.procedure("f3", list("RCheckpointNode.java", "test", "missingfile.txt", "abc.txt"))
	
	# Test ddg.data.out
	ddg.data.out("out1", "a","no.name.or.args.given")
	ddg.data.out("out2", "b", no.name.or.args.given)
	out.test.1()
	out4 <- "d"
	ddg.data.out("out4", pname="no.name.or.args.given")
	out5 <- "e"
	ddg.data.out(out5, pname="no.name.or.args.given")
	ddg.data.out(out5, pname="no.such.function")  # bad function name
	ddg.data.out(out6, pname="no.name.or.args.given")  # bad variable name
	
	# Test ddg.url.out
	ddg.url.out("Harvard home", "http://www.harvard.edu", "only.args.given")
	ddg.url.out("R home", "http://www.r-project.org/", only.args.given)
	url.out.test()
	
	# Test ddg.snapshot.out
	ddg.snapshot.out("pets2", "csv", pets.df, "only.name.given")
	ddg.snapshot.out("pets3", "csv", pets.df, only.name.given)
	ddg.snapshot.out("pets.df", "csv", pname="only.name.given")
	pets6 <- pets.df
	ddg.snapshot.out(pets6, "csv", pname="only.name.given")
	pets.text <- "text about pets"
	ddg.snapshot.out(pets.text, "", pname="only.name.given")
	snapshot.out.test(pets.df)
	
	# Test ddg.file.out
	ddg.file.out("/Users/blerner/Documents/Process/DataProvenance/workspace/ddg-r/src/laser/ddg/r/RDataInstanceNode.java", pname="string.name.and.args.given")
	ddg.file.out("testfile2.txt", pname=string.name.and.args.given)  # Directory is optional
	ddg.file.out("missingfile.txt", pname=string.name.and.args.given)  # What happens if the file is not there?
	ddg.file.out("missingdir/abc.txt", pname=string.name.and.args.given)  # What happens if the directory does not exist?
	file.out.test()
	
	# Test ddg.exception.out
	ddg.exception.out("exc1", "a", "no.name.or.args.given")
	ddg.exception.out("exc2", "b", no.name.or.args.given)
	exc.test.()
	exc4 <- "d"
	ddg.exception.out("exc4", pname="no.name.or.args.given")
	exc5 <- "e"
	ddg.exception.out(exc5, pname="no.name.or.args.given")
	ddg.exception.out(exc5, pname="no.such.function")  # bad function name
	ddg.exception.out(exc6, pname="no.name.or.args.given")  # bad variable name

	# Test ddg.start and ddg.finish
	start.finish.test()
	
	ddg.finish("main")
}


### Run script

ddg.run(main, 
		"/Users/blerner/Documents/Process/DataProvenance/workspace/ddg-r/examples/ddgTest/ddgTest.r",
		"/Users/blerner/Documents/Process/DataProvenance/workspace/ddg-r/examples/ddgTest/ddg")
