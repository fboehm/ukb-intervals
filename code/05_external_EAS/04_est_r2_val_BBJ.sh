#!/bin/bash

#SBATCH --partition=nomosix,mulan
#SBATCH --time=06:00:00
#SBATCH --job-name=EAS
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-780%200
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/04_est_r2_val_EAS_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/04_est_r2_val_EAS_%a.err

bash
let k=0

easpath=/net/mulan/disk2/yasheng/comparisonProject/code/05_external_EAS/
estR=${easpath}04_est_r2_val_BBJ.R
data=${easpath}dat.txt
pheno=${easpath}pheno.txt

for method in CT DBSLMM lassosum auto inf nosp sp nps PRScs sblup SbayesR SCT bagging;do
for iter in `seq 1 12`; do
for cross in 1 2 3 4 5; do
# for iter in 1; do
# for cross in 1; do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

p=`tail -n+${iter} ${pheno} | head -1`
d=`tail -n+${iter} ${data} | head -1`
Rscript ${estR} --pheno ${p} --cross ${cross} --data ${d} --method ${method}

fi

done
done
done


