#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=1-00:00:00
#SBATCH --job-name=allele-verif
#SBATCH --mem=2G
#SBATCH --array=1-1100%100
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/allele-scoring-verif/allele-scoring-verif_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/allele-scoring-verif/allele-scoring-verif_%a.err

let k=0

# h & p are command line args
hsq=${h}
pcausal=${p}

for chr in `seq 1 22`;do

for p in `seq 1 10`; do
for fold in `seq 1 5`; do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
  
# bfile
#compstr1=/net/mulan/disk2/yasheng/comparisonProject/
#compstr=/net/mulan/home/yasheng/comparisonProject/
bfile=~/research/ukb-intervals/dat/simulations-ding/verification/chr${chr}
#bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/hm3/chr${chr}
#idxtest=${compstr1}02_pheno/01_test_idx_c/idx_pheno${p}_cross${cross}.txt
#idxtest=~/research/ukb-intervals/dat/simulations-ding/test-ids-fold${fold}.txt

#esteffdbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/summary_hm3_cross${cross}_chr${chr}_best.dbslmm.txt
esteffdbslmmt=~/research/ukb-intervals/dat/simulations-ding/DBSLMM_hsq${hsq}_pcausal${pcausal}/summary_ukb_pheno${p}_fold${fold}_chr${chr}_best.dbslmm.txt
#preddbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/pred_hm3_best_cross${cross}_chr${chr}
# aggdbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/agg_hm3_best_cross${cross}_chr${chr}
outpath=~/research/ukb-intervals/dat/simulations-ding/verification/allele-scores_hsq${hsq}_pcausal${pcausal}
mkdir -p ${outpath}
preddbslmmt=${outpath}/pred_ukb_pheno${p}_fold${fold}_chr${chr}_best.dbslmm.txt
#gunzip ${esteffdbslmmt}.gz
plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum  --out ${preddbslmmt}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --keep ${idxagg} --out ${aggdbslmm
fi
done
done
done

