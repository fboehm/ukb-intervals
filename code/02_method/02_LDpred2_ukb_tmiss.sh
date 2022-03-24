#!/bin/bash

#SBATCH --partition=mulan
#SBATCH --time=2-00:00:00
#SBATCH --job-name=LDpred2_ukb
#SBATCH --mem=30G
#SBATCH --cpus-per-task=5

#SBATCH --array=1-4
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/02_LDpred2_ukb_c_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/02_LDpred2_ukb_c_%a.err

bash
let k=0

compstr=/net/mulan/disk2/yasheng/comparisonProject/
LDpred2=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/02_LDpred2.R
ref=ukb
dist=200

dat=c
p=1

threadMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/LDpred2_miss/thread.txt
crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/LDpred2_miss/cross.txt
chrMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/LDpred2_miss/chr.txt

for iter in `seq 1 4`
do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

thread=`tail -n+${iter} ${threadMiss} | head -1`
cross=`tail -n+${iter} ${crossMiss} | head -1`
chr=`tail -n+${iter} ${chrMiss} | head -1`

if [[ "$dat" == "c" ]]
then
summ=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/output/summary_ukb_cross${cross}_chr
LDpred2Path=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/LDpred2/
else
summ=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/output/summary_ukb_cross${cross}_chr
LDpred2Path=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/LDpred2/
fi
esttime=${compstr}01_time_file/02_LDpred2_ukb_${dat}_pheno${p}_cross${cross}_chr${chr}_thread${thread}.tm
time /usr/bin/time -v -o ${esttime} Rscript ${LDpred2} --summ ${summ} --LDpred2Path ${LDpred2Path} --pheno ${p} --cross ${cross} --dat ${dat} --reftype ${ref} --thread ${thread} --chr ${chr} --dist ${dist}

fi

done
