#' browse a page defining units of collectl reporting
#' @param \dots passed to \link{browseURL}
#' @return side effect is running browseURL
#' @examples
#' if (interactive()) {
#' browse_units()
#' }
#' @export
browse_units = function(...) {
	 path = system.file("units", "cl_units.html", package="Rcollectl")
	 browseURL(paste0("file://", path), ...)
}
