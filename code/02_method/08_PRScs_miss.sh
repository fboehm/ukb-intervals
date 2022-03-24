#!/bin/bash

#SBATCH --partition=nomosix
#SBATCH --time=24:00:00
#SBATCH --job-name=PRScs_mc
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-28
#SBATCH --output=/net/mulan/home/yasheng/comparisonProject/00_cluster_file/08_PRScs_hm3_mc%a.out
#SBATCH --error=/net/mulan/home/yasheng/comparisonProject/00_cluster_file/08_PRScs_hm3_mc%a.err

bash
let k=0

compstr=/net/mulan/disk2/yasheng/comparisonProject/
PRScsscript=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/08_PRScs_script.sh
dat=continuous
PRScspath=/net/mulan/home/yasheng/comparisonProject/program/PRScs-master/

phenoMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/PRScs_miss/pheno.txt
crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/PRScs_miss/cross.txt
chrMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/PRScs_miss/chr.txt
# phiMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/PRScs_miss/phi.txt

for iter in `seq 1 27` 29
do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
p=`head -n ${iter} ${phenoMiss} | tail -n 1`
cross=`head -n ${iter} ${crossMiss} | tail -n 1`
chr=`head -n ${iter} ${chrMiss} | tail -n 1`
# phi=`head -n ${iter} ${phiMiss} | tail -n 1`
phi=auto
# reference=${compstr}/04_reference/hm3/ldblk_1kg_eur_cross${cross}
reference=/net/mulan/home/yasheng/comparisonProject/04_reference/hm3/pheno${p}/ldblk_1kg_eur_cross${cross}
valgeno=${compstr}/03_subsample/${dat}/pheno${p}/hm3/impute/chr

if [[ "$dat" == "continuous" ]]
then 
summ=${compstr}05_internal_c/pheno${p}/output/summary_hm3_cross${cross}_chr
estfile=${compstr}05_internal_c/pheno${p}/PRScs/esteff_cross${cross}_chr
predfile=${compstr}05_internal_c/pheno${p}/PRScs/pred_cross${cross}_chr
valpheno=${compstr}/03_subsample/${dat}/pheno${p}/02_pheno_c.txt
else 
summ=${compstr}06_internal_b/pheno${p}/output/summary_hm3_cross${cross}_chr
estfile=${compstr}06_internal_b/pheno${p}/PRScs/esteff_cross${cross}_chr
predfile=${compstr}06_internal_b/pheno${p}/PRScs/pred_cross${cross}_chr
valpheno=${compstr}/03_subsample/${dat}/pheno${p}/02_pheno_c.txt
fi

# esttime=${compstr}01_time_file/08_PRScs_hm3_${dat}_pheno${p}_cross${cross}_chr${chr}_thread${thread}.tm
# time /usr/bin/time -v -o ${esttime} 
bash ${PRScsscript} -P ${PRScspath} -s ${summ} -r ${reference} -v ${valgeno} -p ${valpheno} -o ${estfile} -f ${predfile} -h ${chr} -I ${phi}

fi
done
