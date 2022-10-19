#!/bin/bash

#SBATCH --partition=nomosix
#SBATCH --time=6-00:00:00
#SBATCH --job-name=SCT_u
#SBATCH --mem=60G
#SBATCH --cpus-per-task=5
#SBATCH --array=1-125%25
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/01_CT_ukb_c_thread5_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/01_CT_ukb_c_thread5_%a.err

let k=0

fbstr=~/research/ukb-intervals/
compstr=/net/mulan/disk2/yasheng/comparisonProject/
CT=${fbstr}/code_sheng/01_CT_SCT.R
ref=ukb
dat=continuous
thread=5

for p in `seq 1 25`;do
for cross in 1 2 3 4 5; do
let k=${k}+1

if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

if [[ "$dat" == "continuous" ]]
then
echo continuous
summ=${fbstr}05_internal_c/pheno${p}/output/summary_ukb_cross${cross}
path=${fbstr}05_internal_c/pheno${p}/
else
echo binary
summ=${fbstr}06_internal_b/pheno${p}/output/summary_ukb_cross${cross}
path=${fbstr}06_internal_b/pheno${p}/
fi

mkdir -p ${path}/CT
mkdir -p ${path}/SCT

cat ${summ}_chr*.assoc.txt > ${summ}.assoc.txt
sed -i '/chr/d' ${summ}.assoc.txt

#esttime=${compstr}01_time_file/01_SCT_CT_ukb_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
#time /usr/bin/time -v -o ${esttime} 
Rscript ${CT} --summ ${summ}.assoc.txt \
--path ${path} --pheno ${p} --cross ${cross} --reftype ${ref} --dat ${dat} --thread ${thread}

# rm ${path}CT/summary_cross${cross}.bk
# rm ${path}CT/summary_cross${cross}.rds

fi
done
done


