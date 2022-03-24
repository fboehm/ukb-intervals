#!/bin/bash

#SBATCH --partition=nomosix,mulan
#SBATCH --time=2:00:00
#SBATCH --job-name=lassosum
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-10
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/03_lassosum_hm3_thread1_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/03_lassosum_hm3_thread1_%a.err

bash
let k=0

lassosum=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/03_lassosum.R
compstr=/net/mulan/disk2/yasheng/comparisonProject/
ref=hm3
thread=1

for dat in binary continuous; do
for cross in 1 2 3 4 5; do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

if [[ "$dat" == "continuous" ]]
then
echo continuous 
p=1
summ=${compstr}05_internal_c/pheno${p}/output/summary_hm3_cross${cross}
path=${compstr}05_internal_c/pheno${p}/lassosum/
else
echo binary
p=9
summ=${compstr}06_internal_b/pheno${p}/output/summary_hm3_cross${cross}
path=${compstr}06_internal_b/pheno${p}/lassosum/
fi

# cat ${summ}_chr*.assoc.txt > ${summ}.assoc.txt
nobs=`sed -n "2p" ${summ}.assoc.txt | awk '{print $5}'`
nmis=`sed -n "2p" ${summ}.assoc.txt | awk '{print $4}'`
n=$(echo "${nobs}+${nmis}" | bc -l)

esttime=${compstr}01_time_file/03_lassosum_hm3_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
time /usr/bin/time -v -o ${esttime} Rscript ${lassosum} --summ ${summ}.assoc.txt --dat ${dat} --pheno ${p} --n ${n} --thread ${thread} --cross ${cross} --reftype ${ref} --path ${path}
fi
done
done

