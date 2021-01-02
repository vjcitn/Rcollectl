This workspace was introduced using AnVILPublish.  It was built using

us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.8

The FASTQ files underlying the "airway" RNA-seq workflow were collected using commands like

```
gsutil -u landmarkanvil2 ls  gs://sra-pub-run-3/SRR1039512/SRR1039512.1
gsutil -u landmarkanvil2 cp  gs://sra-pub-run-4/SRR1039513/SRR1039513.1 .
gsutil -u landmarkanvil2 cp  gs://sra-pub-run-4/SRR1039516/SRR1039516.1 .
gsutil -u landmarkanvil2 cp  gs://sra-pub-run-2/SRR1039517/SRR1039517.1 .
gsutil -u landmarkanvil2 cp  gs://sra-pub-run-2/SRR1039520/SRR1039520.1 .
gsutil -u landmarkanvil2 cp  gs://sra-pub-run-3/SRR1039521/SRR1039521.1 .
```

A public bucket with the extracted fastq was then produced via
```
fastq-dump --split-3 *512.1 &
fastq-dump --split-3 *513.1 &
fastq-dump --split-3 *516.1 &
fastq-dump --split-3 *517.1 &
fastq-dump --split-3 *520.1 &
fastq-dump --split-3 *521.1 &
gzip *fastq
gsutil ls gs://bioc-airway-fastq
gsutil cp SRR1039508.1_2.fastq.gz gs://bioc-airway-fastq/
```
Our aim is to analyze the resource consumption in processing this sort of data with
R using Rcollectl.  We've run salmon to generate quantifications, on another system, and
we will attempt to give estimates for processing various volumes of data by various
approaches.
