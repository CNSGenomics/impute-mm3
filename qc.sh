#!/bin/bash

#$ -N qc
#$ -S /bin/bash
#$ -cwd
#$ -o job_reports/
#$ -e job_reports/
#$ -l h_vmem=8G

# 1. Initial QC

wd=`pwd`"/"
source parameters.sh

${plink2} --bfile ${rawdata} --maf $MAF --mind $mind --geno $geno --hwe $HWE --make-bed --out ${inputdata}
