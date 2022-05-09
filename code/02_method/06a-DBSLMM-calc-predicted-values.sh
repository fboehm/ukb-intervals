#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=12:00:00
#SBATCH --job-name=DBSLMM-pred
#SBATCH --mem=15G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-25
#SBATCH --output=06a_DBSLMM_ukb_c_%a.out
#SBATCH --error=06a_DBSLMM_ukb_c_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fredboe@umich.edu

bash 
let k=0
for p in `seq 1 25`; do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
for chr in `seq 1 22`;do
for cross in 1 2 3 4 5; do

#for cross in 1; do
#bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/hm3/chr${chr}
bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/chr${chr}
#idxtest=${compstr1}02_pheno/01_test_idx_c/idx_pheno${p}_cross${cross}.txt
idxtest=~/research/comparisonProject/02_pheno/01_test_idx_c/idx_pheno${p}_cross${cross}.txt
#idxtest=~/research/ukb-intervals/test_index_files/test_indices_pheno_${p}_cross_${cross}_ntest1000.txt
#esteffdbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/summary_hm3_cross${cross}_chr${chr}_best.dbslmm.txt
esteffdbslmmt=~/research/ukb-intervals/results/pheno${p}/yangdbslmm/summary_ukb_cross${cross}_chr${chr}_auto.dbslmm.txt
#preddbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/pred_hm3_best_cross${cross}_chr${chr}
preddbslmmt=~/research/ukb-intervals/results/pheno${p}/yangdbslmm/predicted_ukb_cross${cross}_chr${chr}_auto.dbslmm.txt
# aggdbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/agg_hm3_best_cross${cross}_chr${chr}
#gunzip ${esteffdbslmmt}.gz
time /usr/bin/time -v -o ~/research/ukb-intervals/cluster_outputs/time-prediction-dbslmm-pheno${p}-cross${cross}-chr${chr}.txt plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --keep ${idxtest} --out ${preddbslmmt}
done
done
fi 
pid=$!
echo $pid
done

