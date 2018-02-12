#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "Plot.pdf"
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

# File parsing
path <- args[1]
fnFs <- sort(list.files(path, pattern="_R1."))
fnRs <- sort(list.files(path, pattern="_R2."))
fnFs <- file.path(path, fnFs)
fnRs <- file.path(path, fnRs)
pdf(file=args[2])
plotQualityProfile(fnFs[1:2])
plotQualityProfile(fnRs[1:2])
dev.off()
