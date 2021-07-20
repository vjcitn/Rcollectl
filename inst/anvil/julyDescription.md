The purpose of this workspace is to demonstrate tools produced with R to
measure resource usage in Terra sessions.

With the Rcollectl package and a custom docker image (we used `vjcitn/instr:3.13.2001` that includes the [collectl](http://collectl.sourceforge.net/)
infrastructure installed for immediate use, we can measure the activities undertaken when
the Bioconductor 3.13 [rnaseqGene workflow](https://www.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html) is executed.

We use `cl_start()` to begin monitoring, `cl_stop()` to stop and save the activity data, `parse_cl()` to ingest the performance data, and `plot_usage()` to
produce a display in which we can evaluate duration,  memory consumption, completeness of CPU utilization, network traffic, and disk I/O.

![collectl](https://storage.googleapis.com/bioc-anvil-images/julyCollectlImg.png)
