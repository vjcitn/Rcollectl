#' parse a collectl output -- could be conditional on discovered call
#' @importFrom lubridate as_datetime
#' @importFrom utils browseURL read.delim
#' @param path character(1) path to (possibly gzipped) collectl output
#' @return a data.frame
#' @note A lubridate datetime is added as a column.
#' @examples
#' lk = cl_parse(system.file("demotab/demo_1123.tab.gz", package="Rcollectl"))
#' head(lk)
#' @export
cl_parse = function(path) {
	meta = readLines(path, n=14)
	dat = read.delim(path, skip=14, check.names=FALSE, sep=" ")
	names(dat) = gsub("\\[(...)\\]", "\\1_", names(dat))
        dat = revise_date(dat)
	attr(dat, "meta") = meta
	dat
}

revise_date = function(x) {
 c2 = paste(x[,1], x[,2])
 pred = gsub("(....)(..)(..)(.*)", "\\1-\\2-\\3\\4", c2)
 x$sampdate = lubridate::as_datetime(pred)
 x
}
