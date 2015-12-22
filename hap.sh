#!/bin/bash

#$ -N shapeit
#$ -t 1-22
#$ -S /bin/bash
#$ -cwd
#$ -o job_reports/
#$ -e job_reports/
#$ -l h_vmem=5G
#$ -pe onehost 8

# This script will take a reference-aligned binary plink file and:
# 1. For each chromosome perform shapeit phasing
# 2. Remove snps that don't align between reference and main panel
# 3. Convert to vcf format

# set -e
if [ -n "${1}" ]; then
    SGE_TASK_ID=${1}
fi

chr=${SGE_TASK_ID}
wd=`pwd`"/"
source parameters.sh
threads=8

flags="--thread $threads --noped"

#if [ "${chr}" -eq "23" ]; then
#    flags="$flags --chrX"
#fi

if [[ -f ${targetdata}"-align.bim" ]];
then
    targetdata="${targetdata}-align"
    echo "Found aligned set"
fi

indv=$(wc -l ${targetdata}.fam | cut -f 1 -d ' ')
echo "There are $indv individuals"

## If less than 100 indivduals, use reference panel to phase
minindiv=100
if [ $indv -lt $minindiv ]; then
    flags="$flags --input-ref ${refhaps} ${reflegend} ${refsample}"
    echo "Using reference set to phase data"
fi

## Performing phasing 
${shapeit2} --input-bed ${targetdata}.bed ${targetdata}.bim ${targetdata}.fam \
            --input-map ${refgmap} \
            --output-max ${hapout}.haps ${hapout}.sample ${flags} \
            --output-log ${wd}job_reports/shapeit/shapeit.$chr

## Convert data to vcf for minimac3
${shapeit2} -convert \
            --input-haps ${hapout} \
            --output-vcf ${targetvcf} \
            --output-log ${wd}job_reports/shapeit/shapeit.$chr \
            --thread $threads
