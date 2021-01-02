This workspace was introduced using AnVILPublish.  It was built using

dockerhub vjcitn/instr:0.0.3

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

We installed snakemake with pip3 and salmon via
```
wget https://github.com/COMBINE-lab/salmon/releases/download/v1.4.0/salmon-1.4.0_linux_x86_64.tar.gz
```


We obtained GENCODE transcript sequences:

```
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_36/gencode.v36.transcripts.fa.gz
```
And built the index `gencode.v36_salmon_1.4.0` via

```
salmon index --gencode -t gencode.v36.transcripts.fa.gz -i gencode.v36_salmon_1.4.0
```


For a single sample (paired-end) we have a snakemake file:

```
rstudio@saturn-1f2f18e5-4182-40c0-8449-1f301b5c3b03:~$ cat snakemake_one
DATASETS = ["SRR1039508.1"]

SALMON = "/home/rstudio/bin/salmon"

rule all:
  input: expand("quants/{dataset}/quant.sf", dataset=DATASETS)

rule salmon_quant:
    input:
        r1 = "fastq/{sample}_1.fastq.gz",
        r2 = "fastq/{sample}_2.fastq.gz",
        index = "/home/rstudio/gencode.v36_salmon_1.4.0"
    output:
        "quants/{sample}/quant.sf"
    params:
        dir = "quants/{sample}"
    shell:
        "{SALMON} quant -i {input.index} -l A -p 6 --validateMappings \
         --gcBias --numGibbsSamples 20 -o {params.dir} \
         -1 {input.r1} -2 {input.r2}"
```

When used with

```
snakemake -j1 --snakefile snakemake_one
```

it takes 6 minutes to produce quants
```
└── SRR1039508.1
    ├── aux_info
    │   ├── ambig_info.tsv
    │   ├── bootstrap
    │   │   ├── bootstraps.gz
    │   │   └── names.tsv.gz
    │   ├── expected_bias.gz
    │   ├── exp_gc.gz
    │   ├── fld.gz
    │   ├── meta_info.json
    │   ├── observed_bias_3p.gz
    │   ├── observed_bias.gz
    │   └── obs_gc.gz
    ├── cmd_info.json
    ├── lib_format_counts.json
    ├── libParams
    │   └── flenDist.txt
    ├── logs
    │   └── salmon_quant.log
    └── quant.sf
```


