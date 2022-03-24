#!/bin/bash

#SBATCH --partition=mulan
#SBATCH --time=2-00:00:00
#SBATCH --job-name=SCT_u
#SBATCH --mem=60G
#SBATCH --cpus-per-task=5
#SBATCH --array=1-5
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/01_CT_ukb_thread5_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/01_CT_ukb_thread5_%a.err

bash
let k=0

compstr=/net/mulan/disk2/yasheng/comparisonProject/
CT=${compstr}/code/02_method/01_CT_SCT.R
ref=ukb
dat=continuous
thread=5

for p in 1;do
for cross in 1 2 3 4 5; do
let k=${k}+1

if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

if [[ "$dat" == "continuous" ]]
then
echo continuous
summ=${compstr}05_internal_c/pheno${p}/output/summary_ukb_cross${cross}
path=${compstr}05_internal_c/pheno${p}/
else
echo binary
summ=${compstr}06_internal_b/pheno${p}/output/summary_ukb_cross${cross}
path=${compstr}06_internal_b/pheno${p}/
fi

cat ${summ}_chr*.assoc.txt > ${summ}.assoc.txt
sed -i '/chr/d' ${summ}.assoc.txt

esttime=${compstr}01_time_file/01_SCT_CT_ukb_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
time /usr/bin/time -v -o ${esttime} Rscript ${CT} --summ ${summ}.assoc.txt \
--path ${path} --pheno ${p} --cross ${cross} --reftype ${ref} --dat ${dat} --thread ${thread}

fi
done
done


