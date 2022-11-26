#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=1-00:00:00
#SBATCH --job-name=allele-scoring
#SBATCH --mem=2G
#SBATCH --array=1-220
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/allele-scoring_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/allele-scoring_%a.err

let k=0
dats=(continuous binary)
fbstr=~/research/ukb-intervals/

for dat in ${dats[@]}; do
  for chr in `seq 1 22`;do
    #for p in `seq 1 25`; do
    for p in 1; do 
      for cross in `seq 1 5`; do
        let k=${k}+1
        if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
          # bfile
          bfile=${fbstr}/plink_file/ukb/${dat}/chr${chr}
          if [ "$dat" == "continuous" ]; then
            idxtest=${fbstr}02_pheno/01_test_idx_c/idx_pheno${p}_cross${cross}.txt
            esteffdbslmmt=${fbstr}05_internal_c/pheno${p}/DBSLMM/summary_ukb_cross${cross}_chr${chr}_best.dbslmm.txt
            # outfile defined here
            preddbslmmt=${fbstr}05_internal_c/pheno${p}/DBSLMM/pred_ukb_best_cross${cross}_chr${chr}
          else 
            idxtest=${fbstr}02_pheno/04_test_idx_b/idx_pheno${p}_cross${cross}.txt
            esteffdbslmmt=${fbstr}06_internal_b/pheno${p}/DBSLMM/summary_ukb_cross${cross}_chr${chr}_best.dbslmm.txt
            # outfile defined here
            preddbslmmt=${fbstr}06_internal_b/pheno${p}/DBSLMM/pred_ukb_best_cross${cross}_chr${chr}
          fi
          plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --keep ${idxtest} --out ${preddbslmmt}
        fi
      done
    done
  done
done  
