#!/bin/bash

#SBATCH --partition=mulan
#SBATCH --time=1-00:00:00
#SBATCH --job-name=LDpred2c
#SBATCH --mem=16G
#SBATCH --cpus-per-task=5
#SBATCH --array=441-660
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/02_LDpred2_thread5%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/02_LDpred2_thread5%a.err

bash
let k=0

compstr=/net/mulan/disk2/yasheng/comparisonProject/
LDpred2=${compstr}code/02_method/02_LDpred2.R
ref=hm3
thread=5

for model in LDpred2-inf LDpred2-auto LDpred2-m;do


for dat in continuous binary;do
for cross in 1 2 3 4 5; do
for chr in `seq 1 22`;do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

if [[ "$dat" == "continuous" ]]
then
echo continuous 
p=1
summ=${compstr}05_internal_c/pheno${p}/output/summary_${ref}_cross${cross}_chr
LDpred2Path=${compstr}05_internal_c/pheno${p}/LDpred2/
else
p=9
echo binary
summ=${compstr}06_internal_b/pheno${p}/output/summary_${ref}_cross${cross}_chr
LDpred2Path=${compstr}06_internal_b/pheno${p}/LDpred2/
fi
esttime=${compstr}01_time_file/02_${model}_hm3_${dat}_pheno${p}_cross${cross}_chr${chr}_thread${thread}.tm
time /usr/bin/time -v -o ${esttime} Rscript ${LDpred2} --summ ${summ} --LDpred2Path ${LDpred2Path} --pheno ${p} --cross ${cross} --dat ${dat} \
 --reftype ${ref} --thread ${thread} --chr ${chr} --model ${model}

fi
done
done
done
done

