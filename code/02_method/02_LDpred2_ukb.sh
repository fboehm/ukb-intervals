#!/bin/bash

#SBATCH --partition=mulan
#SBATCH --time=1-00:00:00
#SBATCH --job-name=LDpred2_ukb
#SBATCH --mem=30G
#SBATCH --cpus-per-task=5

#SBATCH --array=1-330%110
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/02_LDpred2_ukb_thread5_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/02_LDpred2_ukb_thread5_%a.err

bash
let k=0
let thread=5

compstr=/net/mulan/disk2/yasheng/comparisonProject/
LDpred2=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/02_LDpred2.R
ref=ukb
dist=200
dat=continuous

for model in LDpred2-inf LDpred2-auto LDpred2-m;do
for p in 1; do
for cross in 1 2 3 4 5; do
for chr in `seq 1 22`;do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

if [[ "$dat" == "continuous" ]]
then
summ=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/output/summary_ukb_cross${cross}_chr
LDpred2Path=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/LDpred2/
else
summ=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/output/summary_ukb_cross${cross}_chr
LDpred2Path=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/LDpred2/
fi
esttime=${compstr}01_time_file/02_${model}_ukb_${dat}_pheno${p}_cross${cross}_chr${chr}_thread${thread}.tm
time /usr/bin/time -v -o ${esttime} Rscript ${LDpred2} --summ ${summ} --LDpred2Path ${LDpred2Path} --pheno ${p} --cross ${cross} --dat ${dat} --reftype ${ref} --thread ${thread} --chr ${chr} --model ${model}

fi
done
done
done
done
