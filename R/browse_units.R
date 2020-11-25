#' browse a page defining units of collectl reporting
#' @return side effect is running browseURL
#' @examples
#' if (interactive()) {
#' browse_units()
#' }
#' @export
browse_units = function() {
	 browseURL(system.file("units/cl_units.html", package="Rcollectl"))
}
