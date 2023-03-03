#' check for collectl availability
#' @return logical(1)
#' @examples
#' cl_exists()
#' @export
cl_exists = function() {
  x = try(system2("collectl", "--help", stdout=TRUE))
  if (!inherits(x, "try-error") && length(x)>30) return(TRUE)
  FALSE
}

#' start collectl if possible
#' @importFrom processx process
#' @param target character(1) path; destination of collectl report
#' @return instance of `Rcollectl_process` with components `process` (a processx R6 instance) and
#' `target` (a file path where collectl results will be written)
#' @examples
#' if (cl_exists()) {
#'   zz = cl_start()
#'   Sys.sleep(2)
#'   print(zz)
#'   Sys.sleep(2)
#'   print(cl_result_path(zz))
#'   cl_stop(zz)
#'   Sys.sleep(2)
#'   zz$process$is_alive()
#' }
#' @export
cl_start = function(target = tempfile()) {
 proc = try(processx::process$new("collectl", args=c("-scdmn", "-P", paste("-f", target, sep=""))))
 ans = list(process=proc, target=target, node_name=Sys.info()[["nodename"]],
  date=format(Sys.Date(), "%Y%m%d"))
 class(ans) = "Rcollectl_process"
 ans
}

#' print method for Rcollectl process
#' @param x an entity inheriting from "Rcollectl_process" S3 class
#' @param \dots not used
#' @return invisibly returns the input
#' @examples
#' example(cl_start)
#' @export
print.Rcollectl_process = function(x, ...) {
 cat("Rcollectl process object\n  ")
 print(x$process)
 cat("  ")
 cat(x$target, "\n")
 invisible(x)
}

#' stop collectl via processx interrupt
#' @param proc an entity inheriting from "Rcollectl_process" S3 class
#' @return invisibly returns the input
#' @examples
#' example(cl_start)
#' @export
cl_stop = function(proc) {
 stopifnot(inherits(proc, "Rcollectl_process"))
 proc$process$interrupt()
 invisible(proc)
}

#' get full path to collectl report
#' @param proc an entity inheriting from "Rcollectl_process" S3 class
#' @return character(1) path to report
#' @examples
#' example(cl_start)
#' @export
cl_result_path = function(proc) {
 stopifnot(inherits(proc, "Rcollectl_process"))
 dn = dirname(proc$target)
 paste0(proc$target, "-", proc$node_name, "-", proc$date, ".tab.gz")
}
