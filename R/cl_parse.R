#' parse a collectl output -- could be conditional on discovered call
#' @param path character(1) path to (possibly gzipped) collectl output
#' @examples
#' lk = cl_parse(system.file("demo/demo_1123.tab.gz", package="Rcollectl"))
#' head(lk)
#' @export
cl_parse = function(path) {
	meta = readLines(path, n=14)
	dat = read.delim(path, skip=14, check.names=FALSE, sep=" ")
	names(dat) = gsub("\\[(...)\\]", "\\1_", names(dat))
	attr(dat, "meta") = meta
	dat
}
