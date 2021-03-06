% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/viz.R
\name{plot_usage}
\alias{plot_usage}
\title{elementary display of usage data from collectl}
\usage{
plot_usage(x)
}
\arguments{
\item{x}{output of cl_parse}
}
\value{
ggplot with geom_point and facet_grid
}
\description{
elementary display of usage data from collectl
}
\examples{
lk = cl_parse(system.file("demotab/demo_1123.tab.gz", package="Rcollectl"))
plot_usage(lk)
}
