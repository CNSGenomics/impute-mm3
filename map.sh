#!/bin/bash

#$ -N qc_align
#$ -t 1-22
#$ -S /bin/bash
#$ -cwd
#$ -o job_reports/
#$ -e job_reports/
#$ -l h_vmem=8G

# This script will take a binary plink file and:

# 1. extract individual chromosomes
# 2. update genetic distance from map file
# (For the SNPs that don't have a genetic position, SHAPEIT internally
# determines its genetic position using linear interpolation)

set -e

if [[ -n "${1}" ]]; then
  echo ${1}
  SGE_TASK_ID=${1}
fi

chr=${SGE_TASK_ID}
wd=`pwd`"/"

source parameters.sh

${plink2} --bfile ${inputdata} --chr $chr --make-bed --out ${targetdata} 
R --no-save --args ${targetdata}.bim ${refgmap} < ${genetdistR}
${plink2} --noweb --bfile ${targetdata} --make-bed --out ${targetdata} 
