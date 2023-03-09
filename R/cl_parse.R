#' parse a collectl output -- could be conditional on discovered call
#' @importFrom lubridate as_datetime
#' @importFrom utils browseURL read.delim
#' @param path character(1) path to (possibly gzipped) collectl output
#' @param tz character(1) POSIXct time zone code, defaults to "EST"
#' @return a data.frame
#' @note A lubridate datetime is added as a column.
#' @examples
#' lk = cl_parse(system.file("demotab/demo_1123.tab.gz", package="Rcollectl"))
#' head(lk)
#' @export
cl_parse = function(path, tz="EST") {
	full = readLines(path)
        inds = grep("^####", full)
        stopifnot(length(inds)==2)
        lastm = inds[2]
	meta = readLines(path)[seq_len(lastm)]
	dat = read.delim(path, skip=lastm, check.names=FALSE, sep=" ")
	names(dat) = gsub("\\[(...)\\]", "\\1_", names(dat))
        dat = revise_date(dat, tz=tz)
	attr(dat, "meta") = meta
	dat
}

revise_date = function(x, tz) {
 c2 = paste(x[,1], x[,2])
 pred = gsub("(....)(..)(..)(.*)", "\\1-\\2-\\3\\4", c2)
 x$sampdate = lubridate::as_datetime(pred, tz=tz)
 x
}
