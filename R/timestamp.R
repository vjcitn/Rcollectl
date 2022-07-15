# collectl result file name
cl_collectl_file <- function(proc) {
  paste0(proc$target, "-", as.character(Sys.info()["nodename"]), "-", proc$date, ".tab.gz")
}

# timestamp file name
cl_timestamp_file <- function(proc) {
  paste0(proc$target, "-timestamp-", proc$date, ".txt")
}

#' function to record each step with time
#' @importFrom utils read.delim
#' @param proc an entity inheriting from "Rcollectl_process" S3 class
#' @param step character(1) name of step within a workflow
#' @return a tab delimited text file 
#' @examples
#' id <- cl_start("id_name")
#' #code 
#' cl_timestamp(id, "step1")
#' # code
#' cl_timestamp(id, "step2")
#' # code
#' cl_timestamp(id, "step3")
#' # code
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
    file <- cl_collectl_file(arg)
  }
  else {
    file <- arg
  }
  return(cl_parse(arg))
}

# read in timestamp data
cl_timestamp_data <- function(arg) {
  if (inherits(arg, "Rcollectl_process")) {
    file <- cl_timestamp_file(arg)
  }
  else {
    tmp <- unlist(strsplit(basename(arg), "-"))
    hostname <- tmp[length(tmp) - 1]
    target <- sub(paste0("-", hostname, ".*"), "", basename(path))
    date <- sub(paste0(".*", hostname, "-"), "", basename(path))
    date <- sub(".tab.gz.*", "", date)
    file <- paste0(dirname(path), "/", target, "-timestamp-", date, ".txt")
  }
  timestamps <- read.delim(file, header = FALSE, 
                           col.names = c("Step", "sampdate"), sep = "\t")
  timestamps$sampdate <- as.POSIXct(timestamps$sampdate)
  return(timestamps)
}


#' function to plot usage with time of each step
#' @importFrom utils read.delim
#' @param arg proc (an entity inheriting from "Rcollectl_process" S3 class) or path to collectl output
#' @return ggplot 
#' @examples
#' plot_usage(cl_parse(path)) + 
#' cl_timestamp_layer(path) + 
#'   cl_timestamp_label(path) + 
#'   theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
#' @export
cl_timestamp_layer <- function(arg) {
  timestamps <- cl_timestamp_data(arg)
  geom_vline(xintercept = timestamps$sampdate, color = "blue")
}

#' @export
cl_timestamp_label <- function(arg) {
  usage_df_all <- cl_collectl_data(arg)
  timestamps <- cl_timestamp_data(arg)
  
  xlabel_time <- as.numeric(round(
    difftime(
      as.POSIXct(timestamps$sampdate), 
      as.POSIXct(usage_df_all[1, "sampdate"]),
      units='mins')
  ))
  xlabel_time <- paste0(floor(xlabel_time / 60), ":", sprintf("%02d", xlabel_time %% 60))
  
  scale_x_continuous(
    breaks = as.POSIXct(timestamps$sampdate), 
    labels = paste0(xlabel_time, "\n", timestamps$Step))
}

