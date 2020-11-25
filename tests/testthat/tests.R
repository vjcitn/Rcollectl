
library(Rcollectl)

test_that("cl_parse succeeds", {
 lk = cl_parse(system.file("demotab/demo_1123.tab.gz", package="Rcollectl"))
 expect_true(all(dim(lk)==c(478,71)))
 expect_true(length(grep("CPU", names(lk)))==21)
})

test_that("plot_usage succeeds", {
 lk = cl_parse(system.file("demotab/demo_1123.tab.gz", package="Rcollectl"))
 x = plot_usage(lk)
 expect_true("ggplot" %in% class(x))
 expect_true("FacetGrid" %in% class(x$facet))
})
