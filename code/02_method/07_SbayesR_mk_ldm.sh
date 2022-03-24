#!/bin/bash

#SBATCH --partition=nomosix,mulan
#SBATCH --time=1-00:00:00
#SBATCH --job-name=ldm
#SBATCH --mem=25G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-22
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/07_mk_ldm_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/07_mk_ldm_%a.err

bash
let k=0

MKLDM=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/07_SbayesR_mk_ldm.R

for chr in `seq 1 22`; do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
Rscript ${MKLDM} --chr ${chr}
fi
done

