#!/bin/bash

#SBATCH --partition=mulan
#SBATCH --time=1-00:00:00
#SBATCH --job-name=LDpred2_bm
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --array=1-10
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/02_LDpred2_hm3_bm%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/02_LDpred2_hm3_bm%a.err

bash
let k=0

LDpred2=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/02_LDpred2.R
compstr=/net/mulan/disk2/yasheng/comparisonProject/
ref=hm3
dat=binary
thread=4

phenoMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/LDpred2_miss/pheno.txt
crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/LDpred2_miss/cross.txt
chrMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/LDpred2_miss/chr.txt

for iter in `seq 1 10`
do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
p=`head -n ${iter} ${phenoMiss} | tail -n 1`
cross=`head -n ${iter} ${crossMiss} | tail -n 1`
chr=`head -n ${iter} ${chrMiss} | tail -n 1`

if [[ "$dat" == "continuous" ]]
then
echo continuous 
summ=${compstr}05_internal_c/pheno${p}/output/summary_${ref}_cross${cross}_chr
LDpred2Path=${compstr}05_internal_c/pheno${p}/LDpred2/
else
echo binary
summ=${compstr}06_internal_b/pheno${p}/output/summary_${ref}_cross${cross}_chr
LDpred2Path=${compstr}06_internal_b/pheno${p}/LDpred2/
fi
# esttime=${compstr}01_time_file/02_${model}_hm3_${dat}_pheno${p}_cross${cross}_chr${chr}_thread${thread}.tm
# time /usr/bin/time -v -o ${esttime} 
Rscript ${LDpred2} --summ ${summ} --LDpred2Path ${LDpred2Path} --pheno ${p} --cross ${cross} --dat ${dat} \
 --reftype ${ref} --thread ${thread} --chr ${chr} 
# --model ${model}

fi
done

