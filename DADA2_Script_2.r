#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if (length(args)!7) {
  stop("Arguments must be provided as Input path, Forward Trunc, Reverse Trunc, Seqtab save, Tax Save, PhyloseqSave (input file).n", call.=FALSE)
}

# DADA2 analysis

source("https://bioconductor.org/biocLite.R")

Install_And_Load <- function(Required_Packages)
{
    Remaining_Packages <- Required_Packages[!(Required_Packages %in% installed.packages()[,"Package"])];

    if(length(Remaining_Packages))
    {
        install.packages(Remaining_Packages);
    }
    for(package_name in Required_Packages)
    {
        library(package_name,character.only=TRUE,quietly=TRUE);
    }
}
Required_Packages=c("dada2", "phyloseq");
Install_And_Load(Required_Packages);

path <- args[1]
fnFs <- sort(list.files(path, pattern="_R1."))
fnRs <- sort(list.files(path, pattern="_R2."))
filtpath <- file.path("filtered")
filtpath
fnFs
args[2]
args[3]
if(length(fnFs) != length(fnRs)) stop("Forward and reverse files do not match.")
# Filtering: THESE PARAMETERS ARENT OPTIMAL FOR ALL DATASETS
filterAndTrim(fwd=file.path(path, fnFs), filt=file.path(filtpath, fnFs),
rev=file.path(path, fnRs), filt.rev=file.path(filtpath, fnRs),
truncLen=c(220,150), maxEE=2, truncQ=11, maxN=0, rm.phix=TRUE,
compress=TRUE, verbose=TRUE, multithread=TRUE)

filtFs <- list.files(filtpath, pattern="_R1", full.names = TRUE)
filtRs <- list.files(filtpath, pattern="_R2", full.names = TRUE)
sample.names <- sapply(strsplit(basename(filtFs), "_"), `[`, 1) # Assumes filename = samplename_XXX.fastq.gz
sample.namesR <- sapply(strsplit(basename(filtRs), "_"), `[`, 1) # Assumes filename = samplename_XXX.fastq.gz
if(!identical(sample.names, sample.namesR)) stop("Forward and reverse files do not match.")
names(filtFs) <- sample.names
names(filtRs) <- sample.names
set.seed(100)
# Learn forward error rates
errF <- learnErrors(filtFs, nread=2e6, multithread=TRUE)
# Learn reverse error rates
errR <- learnErrors(filtRs, nread=2e6, multithread=TRUE)
# Sample inference and merger of paired-end reads
mergers <- vector("list", length(sample.names))
names(mergers) <- sample.names
for(sam in sample.names) {
  cat("Processing:", sam, "\n")
    derepF <- derepFastq(filtFs[[sam]])
    ddF <- dada(derepF, err=errF, multithread=TRUE)
    derepR <- derepFastq(filtRs[[sam]])
    ddR <- dada(derepR, err=errR, multithread=TRUE)
    merger <- mergePairs(ddF, derepF, ddR, derepR)
    mergers[[sam]] <- merger
}
rm(derepF); rm(derepR)
# Construct sequence table and remove chimeras
seqtab <- makeSequenceTable(mergers)

seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)

saveRDS(seqtab.nochim, args[4])

sum(seqtab.nochim)/sum(seqtab)

taxa <- assignTaxonomy(seqtab.nochim, args[5], multithread=TRUE)

saveRDS(taxa, args[6])

Phyloseq <- phyloseq(otu_table(seqtab.nochim, taxa_are_rows=FALSE), tax_table(taxa))

saveRDS(taxa, args[7])
