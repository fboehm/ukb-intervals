#!/bin/bash

#SBATCH --partition=mulan
#SBATCH --time=24:00:00
#SBATCH --job-name=PRScs
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-220
#SBATCH --output=/net/mulan/home/yasheng/comparisonProject/00_cluster_file/08_PRScs_%a.out
#SBATCH --error=/net/mulan/home/yasheng/comparisonProject/00_cluster_file/08_PRScs_%a.err

bash
let k=0

compstr=/net/mulan/disk2/yasheng/comparisonProject/
PRScsscript=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/08_PRScs_script.sh
dat=binary
PRScspath=/net/mulan/home/yasheng/comparisonProject/program/PRScs-master/

for dat in binary continuous; do
for phi in 1e-02;do
for cross in 1 2 3 4 5; do
for chr in `seq 1 22`;do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

# reference=${compstr}/04_reference/hm3/ldblk_1kg_eur_cross${cross}

if [[ "$dat" == "continuous" ]]
then 
p=1
reference=/net/mulan/home/yasheng/comparisonProject/04_reference/hm3/pheno${p}/ldblk_1kg_eur_cross${cross}
summ=${compstr}05_internal_c/pheno${p}/output/summary_hm3_cross${cross}_chr
estfile=/net/mulan/disk2/yasheng/comparisonProject-archive/05_internal_c/pheno${p}/PRScs/esteff_cross${cross}_chr
predfile=/net/mulan/disk2/yasheng/comparisonProject-archive/05_internal_c/pheno${p}/PRScs/pred_cross${cross}_chr
valpheno=${compstr}/03_subsample/${dat}/pheno${p}/02_pheno_c.txt
valgeno=${compstr}/03_subsample/${dat}/pheno${p}/val/hm3/impute_inter/chr${chr}
else 
p=9
reference=/net/mulan/home/yasheng/comparisonProject/04_reference/hm3/pheno${p}/ldblk_1kg_eur_cross${cross}
summ=${compstr}06_internal_b/pheno${p}/output/summary_hm3_cross${cross}_chr
estfile=/net/mulan/disk2/yasheng/comparisonProject-archive/06_internal_b/pheno${p}/PRScs/esteff_cross${cross}_chr
predfile=/net/mulan/disk2/yasheng/comparisonProject-archive/06_internal_b/pheno${p}/PRScs/pred_cross${cross}_chr
valpheno=${compstr}/03_subsample/${dat}/pheno${p}/02_pheno_b.txt
valgeno=${compstr}/03_subsample/${dat}/pheno${p}/val/impute_inter/chr${chr}
fi

esttime=${compstr}01_time_file/08_PRScs_hm3_${dat}_pheno${p}_cross${cross}_chr${chr}_thread${thread}.tm
time /usr/bin/time -v -o ${esttime} bash ${PRScsscript} -P ${PRScspath} -s ${summ} -r ${reference} \
         -v ${valgeno} -p ${valpheno} -o ${estfile} -f ${predfile} -h ${chr} -I ${phi}

fi
done
done
done
done
