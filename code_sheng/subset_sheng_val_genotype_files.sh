#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=1-00:00:00
#SBATCH --job-name=subsetting
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-1100%300
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/subset_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/subset_%a.err

dats=(continuous binary)
plink=/usr/cluster/bin/plink-1.9

let k=0

for dat in ${dats[@]}; do
  for p in `seq 1 25`; do
    for chr in `seq 1 22`; do
      let k=${k}+1
      if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
        infile=/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/chr${chr}
        idfile=../03_subsample/${dat}/pheno${p}/val/ukb/01_idx.txt
        outpath=../03_subsample/${dat}/pheno${p}/val/ukb/geno/
        mkdir -p ${outpath}
        outfile=${outpath}chr${chr}
        ${plink} --bfile ${infile} --keep ${idfile} --make-bed --out ${outfile}
      fi
    done
  done
done
