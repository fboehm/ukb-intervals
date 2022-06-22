#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=10:00:00
#SBATCH --job-name=impute-val
#SBATCH --mem=2G

#SBATCH --array=1-22
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/impute-val_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/impute-val_%a.err

bash 
let k=0
compStr=/net/mulan/disk2/yasheng/comparisonProject/
#for p in `seq 1 10`; do
  for chr in `seq 1 22`; do
    let k=${k}+1
    if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
      bfileSubP=~/research/ukb-intervals/dat/simulations-ding/validation/chr${chr}
      # impute
      geno_impute=${compStr}code/01_process_dat/05_geno_imputation.R
      input=${bfileSubP}
      output=~/research/ukb-intervals/dat/simulations-ding/validation/impute/chr${chr}
      Rscript ${geno_impute} --plinkin ${input} --plinkout ${output}

    fi
  done
#done
