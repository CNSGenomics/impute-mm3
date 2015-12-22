#!/usr/bin/env bash

# Exe
######################
readonly shapeit2="/ibscratch/wrayvisscher/reference_data/exe/bin/shapeit"
readonly mm3omp="/ibscratch/wrayvisscher/reference_data/exe/Minimac3-omp"
readonly plink2="/ibscratch/wrayvisscher/reference_data/exe/plink2"
readonly genetdistR="${wd}genetdist.R"

# Initial QC thresholds
######################
MAF="0.005"
HWE="0.000001"
geno="0.05"
mind="0.05"

# Filtering thresholds
######################
filterMAF="0.000001"
filterHWE="0.000001"
filtergeno="0.02"
filtermind="0.1"
filterInfo="0.3"

#Change according to data set
#############################
rawdata="${wd}data/target/dataname" 
impdata="dataname_1kg_p1v3"

#Input/Output Data
##################
inputdata="${wd}data/target/inputdata"
targetdata="${wd}data/target/chr${chr}/DAT${chr}"
targetdatadir="${wd}data/target/chr${chr}"
hapdatadir="${wd}data/haplotypes/chr${chr}/"
hapout="${hapdatadir}DAT${chr}"
targetvcf="${hapdatadir}DAT${chr}.vcf"
impdatadir="${wd}data/imputed/"
plinkimpdir="${wd}data/plink/"
imputedvcf="${wd}data/imputed/data_1kg_p1v3_${chr}"
imputedplink="${wd}data/plink/${impdata}_${chr}"
imputedplinkqc="${wd}data/plink/${impdata}_qc_${chr}"
chrdata="DAT${chr}"

#Reference Data for Phasing
###########################
refdatadir="/ibscratch/wrayvisscher/reference_data/1000_genomes/ALL_1000G_phase1integrated_v3_impute/"
reflegend="${refdatadir}ALL_1000G_phase1integrated_v3_chr${chr}_impute.legend.gz"
refhaps="${refdatadir}ALL_1000G_phase1integrated_v3_chr${chr}_impute.hap.gz"
refsample="${refdatadir}ALL_1000G_phase1integrated_v3.sample"
refgmap="${refdatadir}genetic_map_chr${chr}_combined_b37.txt"

#Reference Data for Imputation - m3vcf Phase1
#############################################
refdatadir="/ibscratch/wrayvisscher/reference_data/1000_genomes/1000G_Phase1_M3VCF/"
refvcf="${refdatadir}${chr}.1000g.Phase1.v3.With.Parameter.Estimates.m3vcf.gz"

# shapeit2 (use reference set if less than 50 individuals)
#########################################################
minindiv=50

# minimac3 interval (default is 5Mb) (currently not used)
#########################################################
interval=5000000

# Additional directories required
####################################

if [ ! -d "${targetdatadir}" ]; then
  mkdir ${targetdatadir}
fi

if [ ! -d "${plinkimpdir}" ]; then
  mkdir ${plinkimpdir}
fi

if [ ! -d "${hapdatadir}" ]; then
  mkdir ${hapdatadir}
fi
