# test
# timestamp file name
cl_timestamp_file <- function(proc) {
  paste0(proc$target, "-", proc$node_name, "-", proc$date, ".timestamp.txt")
}

#' @rdname cl_timestamp
#' @title Functions to add time stamps to collectl output
#' @importFrom utils read.delim
#' @param proc an entity inheriting from "Rcollectl_process" S3 class
#' @param step character(1) name of step within a workflow
#' @return `cl_timestamp()` returns a tab delimited text file
#' @examples
#' id <- cl_start() 
#' Sys.sleep(2)
#' cl_timestamp(id, "step1")
#' Sys.sleep(2)
#' Sys.sleep(2)
#' cl_timestamp(id, "step2")
#' Sys.sleep(2)
#' Sys.sleep(2)
#' cl_timestamp(id, "step3")
#' Sys.sleep(2)
#' cl_stop(id)
#' @export
cl_timestamp <- function(proc, step) {
  con <- file(cl_timestamp_file(proc))
  open(con, "a")
  on.exit(close(con))
  text <- paste(step, Sys.time(), sep="\t")
  writeLines(text, con)
  invisible(NULL)
}

# read in collectl output data
cl_collectl_data <- function(arg) {
  if (inherits(arg, "Rcollectl_process")) {
    file <- cl_result_path(arg)
  } else {
    file <- arg
  }
  return(cl_parse(file))
}

# read in timestamp data
cl_timestamp_data <- function(arg, tz="EST") {
  if (inherits(arg, "Rcollectl_process")) {
    file <- cl_timestamp_file(arg)
  } else {
    file <- sub(".tab.gz$", ".timestamp.txt", arg)
  }
  timestamps <- read.delim(file, header = FALSE,
    col.names = c("Step", "sampdate"), sep = "\t")
  timestamps$sampdate <- as.POSIXct(timestamps$sampdate, tz=tz)
  return(timestamps)
}


#' @rdname cl_timestamp
#' @importFrom utils read.delim
#' @param arg proc (an entity inheriting from "Rcollectl_process" S3 class) or path to collectl output
#' @return `cl_timestamp_layer()` and `cl_timestamp_label()` return objects that can be combined with ggplot.
#' @examples
#' path <- cl_result_path(id)
#' plot_usage(cl_parse(path)) +
#'   cl_timestamp_layer(path) +
#'   cl_timestamp_label(path) +
#'   ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1))
#' @export
cl_timestamp_layer <- function(arg) {
  timestamps <- cl_timestamp_data(arg)
  geom_vline(xintercept = timestamps$sampdate, color = "blue")
}

#' @rdname cl_timestamp
#' @param tz character(1) time zone code
#' @export
cl_timestamp_label <- function(arg, tz="EST") {
  usage_df_all <- cl_collectl_data(arg)
  timestamps <- cl_timestamp_data(arg)

  xlabel_time <- as.numeric(round(
    difftime(
      as.POSIXct(timestamps$sampdate, tz=tz),
      as.POSIXct(usage_df_all[1, "sampdate"], tz=tz),
      units='mins')
  ))
  xlabel_time <- sprintf("%d:%02d", floor(xlabel_time / 60), xlabel_time %% 60)

  scale_x_continuous(
    breaks = as.POSIXct(timestamps$sampdate, tz=tz),
    labels = paste0(xlabel_time, "\n", timestamps$Step))
}
