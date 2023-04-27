#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=2-00:00:00
#SBATCH --job-name=cvplus
#SBATCH --mem=16G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-25
#SBATCH --output=/net/mulan/disk2/fredboe/research/ukb-intervals/cluster_outputs/cvplus_%a.out
#SBATCH --error=/net/mulan/disk2/fredboe/research/ukb-intervals/cluster_outputs/cvplus_%a.err


let k=0
for trait in `seq 1 25`; do
    let k=${k}+1
    if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
        Rscript --vanilla cv-plus.R ${trait}
    fi
done
