#!/bin/bash

#$ -N m3impute
#$ -t 1-22
#$ -S /bin/bash
#$ -cwd
#$ -o job_reports/
#$ -e job_reports/
#$ -l h_vmem=4G
#$ -pe onehost 10

set -e
if [ -n "${1}" ]; then
    SGE_TASK_ID=${1}
fi

chr=${SGE_TASK_ID}
wd=`pwd`"/"
source parameters.sh
threads=10

echo "Imputing on $threads threads"

#impute
${mm3omp} --refHaps $refvcf \
          --haps $targetvcf \
          --prefix $imputedvcf \
          --cpus $threads

#convert to plink format
${plink2} --vcf ${imputedvcf}.dose.vcf.gz --make-bed --out $imputedplink --threads $threads
${plink2} --bfile ${imputedplink} --hwe ${filterHWE} --maf ${filterMAF} --make-bed --out ${imputedplinkqc} --threads $threads
