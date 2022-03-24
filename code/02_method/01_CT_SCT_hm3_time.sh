#!/bin/bash

#SBATCH --partition=nomosix
#SBATCH --time=1-00:00:00
#SBATCH --job-name=CT_b
#SBATCH --mem=30G
#SBATCH --cpus-per-task=5

#SBATCH --array=8
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/01_CT_hm3_thread5_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/01_CT_hm3_thread5_%a.err

bash
let k=0

compstr=/net/mulan/disk2/yasheng/comparisonProject/
CT=${compstr}code/02_method/01_CT_SCT.R
thread=5
ref=hm3


for dat in binary continuous;do
for cross in 1 2 3 4 5; do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

if [[ "$dat" == "continuous" ]]
then

echo continuous
p=1
summ=${compstr}05_internal_c/pheno${p}/output/summary_hm3_cross${cross}
cat ${summ}_chr*.assoc.txt > ${summ}.assoc.txt
path=${compstr}05_internal_c/pheno${p}/

else

p=9
echo binary
summ=${compstr}06_internal_b/pheno${p}/output/summary_hm3_cross${cross}
cat ${summ}_chr*.assoc.txt > ${summ}.assoc.txt
path=${compstr}06_internal_b/pheno${p}/

fi


esttime=${compstr}01_time_file/01_SCT_CT_hm3_${dat}_pheno${p}_cross${cross}_thread${thread}x.tm
time /usr/bin/time -v -o ${esttime} Rscript ${CT} --summ ${summ}.assoc.txt \
--path ${path} --pheno ${p} --cross ${cross} --reftype ${ref} --dat ${dat} --thread ${thread}


fi
done
done

