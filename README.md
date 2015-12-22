impute-mm3
==========

Veru simple pipeline to perform qc using plink, phase using shapeit2 and impute using minimac3 on SGE cluster, borrowing from [impute-pipe][https://github.com/CNSGenomics/impute-pipe]

#### Current limitations
- Only works with b37 aligned reference sets
- No chunking, instead uses multiple threads per chromosome
- Still experimental - requires testing

#### Differences from impute-pipe
- Will automatically use a reference set for phasing if less than 50 individuals
- Uses minimac3 for imputation
- Needs shapeit, minimac3, plink2 installed

#### Instructions
Run shell script (./init.sh):
- init.sh (Make directories)
Submit scripts to cluster (using qsub script.sh) in this order:
- qc.sh (Filter using plink)
- map.sh (Extract by chr and fill in genetic distance from map file
- align.sh (Optional step: remove any SNPs that didn't align with reference)
- hap.sh (Performing phasing using shapeit2, using reference set if < 50 individuals)
- impute.sh (Perform imputation using minimac3, convert vcf output to plink2 and do post imputation qc)
