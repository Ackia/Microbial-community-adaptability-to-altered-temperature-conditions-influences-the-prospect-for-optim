# Microbial-community-adaptability-to-altered-temperature-conditions-influences-the-prospect-for-optim
The operating temperature strongly affects biogas yield, process stability and prospect for process optimization. Yet, many questions remains on how changed temperature influences on microbial communities and how to optimally manage the process in association to such changes. A long-term anaerobic digestion experiment was conducted to determine temperature-related questions raised by operative full-scale biogas plants and to evaluate optimization potentials and links to microbial community structure and responses. Four digesters fed household and slaughterhouse waste were operated in sets of two, at 37°C or 52°C, followed by a gradual increase or decrease in temperature in one digester in each set. Stability and flexibility of the digesters were then assessed by step-wise increases in organic loading rate (OLR) from 3 to 7 g VS/L/day, concurrently with decreased hydraulic retention time from 33-40 days to 14-17 days. The digester that had altered from thermophilic to mesophilic conditions failed at 6 g VS/L/day, whereas the digesters with constant temperature and the mesophilic-to-thermophilic digester remained stable at all OLR investigated. Amplicon sequencing showed divergent grouping of the mesophilic communities, whereas the thermophilic communities were nearly identical after the temperature change. Both biological and chemical parameters indicated that lagging in resilience of the acetate and propionate-degrading populations inherited from the community shaped by the initial operation at thermophilic conditions caused the thermophilic-to-mesophilic process less resistant to stress and counteracted process optimization. Overall, these results are valuable in the development of guidelines for process monitoring and strategies during changed temperature conditions with the prospect to optimize performances. 

# Data Avilability

Raw sequences were submitted to the NCBI Sequence Read Archive (SRA) under the study accession number PRJEB24500.

# Description of scripts included

Scripts are included for reproducing the analysis. All scripts have been processed in the Planetsmasher HPCC running Linux Linux CentOS, kernel 3.10.0-693.11.6.el7. x86_64 

If you want to reproduce in your own enviroment be sure to review the scripts beforehand.

## Cutadapt.sh
cutadapt.sh removes primers from the preparation of the 16S rRNA amplicons.

## DADA2_Script_1.r
Initial processing of reads. Takes the output directory of the cutadapt.sh script and processes the reads for plotting quality. Is used to estimate truncation length for forward and reverse reads in DADA_Script_2.r

Requires two input arguments; path to cutadapt.sh output and plotname.pdf

## DADA2_Script_2.r
Continuation of DADA2_Script_1.r, takes input from cutadapt.sh script and further processes the reads according to the [DADA2 tutorial](https://benjjneb.github.io/dada2/bigdata_paired.html) with some minor modifications.

Requires seven arguments; path to cutadapt.sh output, trunc length forward reads, trunc length reverse reads, filename of rds obejct for the seqtab, path to the trainsset for [taxonomic assignment](https://benjjneb.github.io/dada2/assign.html), savename of the rds object for the taxa table, savename of the phyloseq object resulting from the combination of seqtab and tax_tab.
