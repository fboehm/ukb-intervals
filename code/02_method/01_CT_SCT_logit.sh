#!/bin/bash

#SBATCH --partition=nomosix
#SBATCH --time=1-00:00:00
#SBATCH --job-name=CT_l
#SBATCH --mem=35G
#SBATCH --cpus-per-task=5

#SBATCH --array=1-5
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/01_CT_logit_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/01_CT_logit_%a.err

bash
let k=0

compstr=/net/mulan/disk2/yasheng/comparisonProject/
CT=${compstr}code/02_method/01_CT_SCT_logit.R
thread=5
ref=hm3
dat=binary

for p in 14;do
for cross in 1 2 3 4 5; do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

# phenoMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/CT_miss/pheno.txt
# crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/CT_miss/cross.txt

# for iter in `seq 1 18`
# do
# let k=${k}+1
# if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
# then

# p=`head -n ${iter} ${phenoMiss} | tail -n 1`
# cross=`head -n ${iter} ${crossMiss} | tail -n 1`

echo binary
summ_logit=${compstr}06_internal_b/pheno${p}/output/summary_hm3_cross${cross}
cat ${summ_logit}_chr*.assoc.logistic > ${summ_logit}.assoc.logistic
path=${compstr}06_internal_b/pheno${p}/

# esttime=${compstr}01_time_file/01_SCT_CT_hm3_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
# time /usr/bin/time -v -o ${esttime} 
Rscript ${CT} --summ ${summ_logit}.assoc.logistic \
--path ${path} --pheno ${p} --cross ${cross} --reftype ${ref} --dat ${dat} --thread ${thread}


fi
done
done

