#!/bin/bash
# Cutadapt script for cleaning 16S data, requires already demulutiplexed data in the form of SAMPLE_R*_001.fastq.gz. Designed for paired end.
exec 3>&1 4>&2 #Create log
trap 'exec 2>&4 1>&3' 0 1 2 3 #Create log
exec 1>cutadapt.out 2>&1 #Create log
mkdir -p trimmed #Create trimmed directory if not present
module load cutadapt # Load module cutadapt, can be omitted outside of a module environment
for file in *_R1_001.fastq.gz; do # For-loop for processing files
prefix=${file%_R1_001.fastq.gz}; # Define prefix, e.g. sample name, from filename
FwdIn=${prefix}_R1_001.fastq.gz; # Define inpout forward reads (R1)
RevIn=${prefix}_R2_001.fastq.gz; # Define input reverse reads (R2)
prefix="${file%%_*}" # Modify prefix
FwdOut=${prefix}_trimmed_R1.fastq.gz # Define output forward reads (R1)
RevOut=${prefix}_trimmed_R2.fastq.gz # # Define output reverse reads (R2)
cutadapt -g GTGBCAGCMGCCGCGGTAA -G GACTACHVGGGTATCTAATCC --max-n 0 \
--maximum-length 300 --minimum-length 250 --pair-filter=both \
--discard-untrimmed  -o ./trimmed/${FwdOut} \
-p ./trimmed/${RevOut} ${FwdIn} ${RevIn}; # Run Cutadapt
done; # For-loop done
module unload cutadapt # Unload module
