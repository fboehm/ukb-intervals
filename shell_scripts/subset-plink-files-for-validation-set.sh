#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=10:00:00
#SBATCH --job-name=subset-plink
#SBATCH --mem=2G

#SBATCH --array=1-22
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/subset-plink_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/subset-plink_%a.err

bash 
let k=0
compStr=/net/mulan/disk2/yasheng/comparisonProject/
idxSub=~/research/ukb-intervals/dat/simulations-ding/validation-ids.txt
#for p in `seq 1 10`; do
  for chr in `seq 1 22`; do
    let k=${k}+1
    if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
      bfileAll=/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/chr${chr}
      bfileSub=~/research/ukb-intervals/dat/simulations-ding/validation/allchr${chr}
      bfileSubP=~/research/ukb-intervals/dat/simulations-ding/validation/chr${chr}
      plink-1.9 --silent --bfile ${bfileAll} --keep ${idxSub} --make-bed --out ${bfileSub}
      plink-1.9 --silent --bfile ${bfileSub} --maf 0.01 --make-bed --out ${bfileSubP}
      rm ${bfileSub}.bed
      rm ${bfileSub}.bim
      rm ${bfileSub}.fam
    fi
  done
#done
