#!/bin/bash

#SBATCH --partition=nomosix
#SBATCH --time=2-00:00:00
#SBATCH --job-name=CT_cm
#SBATCH --mem=30G
#SBATCH --cpus-per-task=5

#SBATCH --array=1-20
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/01_CT_hm3_m%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/01_CT_hm3_m%a.err

bash
let k=0

compstr=/net/mulan/disk2/yasheng/comparisonProject/
CT=${compstr}code/02_method/01_CT_SCT.R
dat=continuous
thread=5
ref=hm3

phenoMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/CT_miss/pheno.txt
crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/CT_miss/cross.txt

for iter in `seq 1 5`;do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

p=`head -n ${iter} ${phenoMiss} | tail -n 1`
cross=`head -n ${iter} ${crossMiss} | tail -n 1`

if [[ "$dat" == "continuous" ]]
then

echo continuous
summ=${compstr}05_internal_c/pheno${p}/output/summary_hm3_cross${cross}
cat ${summ}_chr*.assoc.txt > ${summ}.assoc.txt
path=${compstr}05_internal_c/pheno${p}/

else

echo binary
summ=${compstr}06_internal_b/pheno${p}/output/summary_hm3_cross${cross}
cat ${summ}_chr*.assoc.txt > ${summ}.assoc.txt
path=${compstr}06_internal_b/pheno${p}/

fi
esttime=${compstr}01_time_file/01_SCT_CT_hm3_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
time /usr/bin/time -v -o ${esttime} Rscript ${CT} --summ ${summ}.assoc.txt \
--path ${path} --pheno ${p} --cross ${cross} --reftype ${ref} --dat ${dat} --thread ${thread}


fi
done
