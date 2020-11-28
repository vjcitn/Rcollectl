<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

<!--
[![BioC
status](http://www.bioconductor.org/shields/build/release/bioc/Rcollectl.svg)](https://bioconductor.org/checkResults/release/bioc-LATEST/Rcollectl)
[![BioC dev
status](http://www.bioconductor.org/shields/build/devel/bioc/Rcollectl.svg)](https://bioconductor.org/checkResults/devel/bioc-LATEST/Rcollectl)
-->
[![R build
status](https://github.com/vjcitn/Rcollectl/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/vjcitn/Rcollectl/actions)
[![Codecov test
coverage](https://codecov.io/gh/vjcitn/Rcollectl/branch/main/graph/badge.svg)](https://codecov.io/gh/vjcitn/Rcollectl?branch=main)
<!--
[![Support site activity, last 6 months: tagged questions/avg. answers
per question/avg. comments per question/accepted answers, or 0 if no
tagged
posts.](http://www.bioconductor.org/shields/posts/Rcollectl.svg)](https://support.bioconductor.org/t/Rcollectl/)
-->
[![GitHub
issues](https://img.shields.io/github/issues/vjcitn/Rcollectl)](https://github.com/vjcitn/Rcollectl/issues)
<!-- badges: end -->

# Rcollectl: simple interfaces to collectl output

Instrumentation demonstrations are conducted using the [collectl](http://collectl.sourceforge.net/index.html) suite of tools.  

These have been bundled in to the docker container vjcitn/instr:0.0.1, which is Rstudio-enabled.  The Dockerfile
is shown below, and might be worth updating.

Here's how we can use collectl:
```
collectl -scdmn -P -f./col1.txt &
```
This will background a process that will write into a file prefixed by  `col1.txt-` and suffixed by `.tab.gz`.
Once the process is killed, the file is closed and available for reading.  It records information on system usage at 1-second intervals.

Here is an example of the output:
```
rstudio@saturn-8a436301-39c9-4c5e-9cb6-3cd154c9204d:~$ more col*tab
################################################################################
# Collectl:   V4.0.5-1  HiRes: 1  Options: -scdmn -P -f./col1.txt
# Host:       saturn-8a436301-39c9-4c5e-9cb6-3cd154c9204d  DaemonOpts:
# Booted:     1606157348.36 [20201123-18:49:08]
# Distro:     debian buster/sid, Ubuntu 18.04.4 LTS  Platform: Unknown
# Date:       20201123-185752  Secs: 1606157872 TZ: +0000
# SubSys:     cdmn Options:  Interval: 1 NumCPUs: 4 [HYPER] NumBud: 0 Flags: i
# Filters:    NfsFilt:  EnvFilt:  TcpFilt: ituc
# HZ:         100  Arch: x86_64-linux-gnu-thread-multi PageSize: 4096
# Cpu:        GenuineIntel Speed(MHz): 2300.000 Cores: 2  Siblings: 4 Nodes: 1
# Kernel:     4.9.0-14-amd64  Memory: 15404688 kB  Swap: 0 kB
# NumDisks:   2 DiskNames: sdb sda
# NumNets:    3 NetNames: docker0:?? lo:?? eth0:-1
################################################################################
#Date Time [CPU]User% [CPU]Nice% [CPU]Sys% [CPU]Wait% [CPU]Irq% [CPU]Soft% [CPU]Steal% [CPU]Idle% [CPU
]Totl% [CPU]Guest% [CPU]GuestN% [CPU]Intrpt/sec [CPU]Ctx/sec [CPU]Proc/sec [CPU]ProcQue [CPU]ProcRun [
CPU]L-Avg1 [CPU]L-Avg5 [CPU]L-Avg15 [CPU]RunTot [CPU]BlkTot [MEM]Tot [MEM]Used [MEM]Free [MEM]Shared [
MEM]Buf [MEM]Cached [MEM]Slab [MEM]Map [MEM]Anon [MEM]AnonH [MEM]Commit [MEM]Locked [MEM]SwapTot [MEM]
SwapUsed [MEM]SwapFree [MEM]SwapIn [MEM]SwapOut [MEM]Dirty [MEM]Clean [MEM]Laundry [MEM]Inactive [MEM]
PageIn [MEM]PageOut [MEM]PageFaults [MEM]PageMajFaults [MEM]HugeTotal [MEM]HugeFree [MEM]HugeRsvd [MEM
]SUnreclaim [NET]RxPktTot [NET]TxPktTot [NET]RxKBTot [NET]TxKBTot [NET]RxCmpTot [NET]RxMltTot [NET]TxC
mpTot [NET]RxErrsTot [NET]TxErrsTot [DSK]ReadTot [DSK]WriteTot [DSK]OpsTot [DSK]ReadKBTot [DSK]WriteKB
Tot [DSK]KbTot [DSK]ReadMrgTot [DSK]WriteMrgTot [DSK]MrgTot
20201123 18:57:54 1 0 0 0 0 0 0 99 1 0 0 2280 3556 1 413 0 0.03 0.57 0.45 0 0 15404688 8010132 7394556
 0 726548 5955516 496572 284848 690188 0 3174836 0 0 0 0 0 0 32 0 0 5666612 0 0 212 0 0 0 0 32072 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
20201123 18:57:55 0 0 0 0 0 0 0 99 1 0 0 534 1027 0 413 0 0.03 0.57 0.45 0 0 15404688 8010048 7394640
0 726548 5955516 496572 284848 690244 0 3174836 0 0 0 0 0 0 32 0 0 5666612 0 0 70 0 0 0 0 32072 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
20201123 18:57:56 0 0 0 0 0 0 0 100 0 0 0 608 1032 0 413 0 0.03 0.57 0.45 0 0 15404688 8010048 7394640
 0 726548 5955516 496572 284848 690260 0 3174836 0 0 0 0 0 0 32 0 0 5666612 0 0 4 0 0 0 0 32072 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
20201123 18:57:57 1 0 0 0 0 0 0 99 1 0 0 656 1093 0 413 0 0.03 0.57 0.45 0 0 15404688 8010032 7394656
0 726548 5955516 496508 284848 690260 0 3174836 0 0 0 0 0 0 28 0 0 5666612 0 0 1 0 0 0 0 32016 0 0 0 0
 0 0 0 0 0 0 0 0 0 0 0 0 0 0

```


## Dockerfile follows:
```
FROM us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.6

# This is to avoid the error
# 'debconf: unable to initialize frontend: Dialog'
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update ; \
    apt-get -y install collectl



# Add back other env vars
RUN echo "TERRA_R_PLATFORM='anvil-rstudio-bioconductor'" >> /usr/local/lib/R/etc/Renviron.site \
    && echo "TERRA_R_PLATFORM_BINARY_VERSION='0.99.1'" >> /usr/local/lib/R/etc/Renviron.site

USER root

# Init command for s6-overlay
CMD ["/init"]
```
