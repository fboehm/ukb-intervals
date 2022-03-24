#!/bin/bash

#SBATCH --partition=nomosix,mulan
#SBATCH --time=06:00:00
#SBATCH --job-name=DB_EAS_b
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4

#SBATCH --array=1-120
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/03_DBSLMMb_eas_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/03_DBSLMMb_eas_%a.err

bash 
let k=0
let thread=4

dat=binary
type=t
compstr=/net/mulan/disk2/yasheng/comparisonProject/
plink=/usr/cluster/bin/plink-1.9
DBSLMM=${compstr}code/02_method/06_DBSLMM_script.sh
DBSLMMpath=/net/mulan/home/yasheng/predictionProject/code/
blockf=${compstr}LDblock_EUR/chr
ref=${compstr}04_reference/hm3/geno/chr

for p in `seq 2 25`; do

for cross in 1 2 3 4 5; do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

## input
if [[ "$dat" == "continuous" ]]
then
val=${compstr}03_subsample/${dat}/pheno${p}/val/hm3/impute_inter/chr
phenoVal=${compstr}/03_subsample/${dat}/pheno${p}/val/hm3/02_pheno_c.txt
herit=${compstr}05_internal_c/pheno${p}/herit/h2_hm3_cross${cross}.log
summ=${compstr}07_external_c/03_EAS/03_res/continuous/pheno${p}_data1/output/summary_hm3_cross${cross}_chr
outPath=${compstr}07_external_c/03_EAS/03_res/continuous/pheno${p}_data1/DBSLMM/
index=r2
else
val=${compstr}03_subsample/${dat}/pheno${p}/val/impute_inter/chr
phenoVal=${compstr}03_subsample/${dat}/pheno${p}/val/02_pheno_b.txt
herit=${compstr}06_internal_b/pheno${p}/herit/h2_hm3_cross${cross}.log
summ=${compstr}07_external_c/03_EAS/03_res/binary/pheno${p}_data1/output/summary_hm3_cross${cross}_chr
outPath=${compstr}07_external_c/03_EAS/03_res/binary/pheno${p}_data1/DBSLMM/
cov=${compstr}03_subsample/${dat}/pheno${p}/val/03_cov_eff.txt
index=auc
fi

## DBSLMM
esttime=${compstr}01_time_file/06_DBSLMM_hm3_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
if [[ "$dat" == "continuous" ]]
then
# time /usr/bin/time -v -o ${esttime} 
sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ} -m DBSLMM \
             -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
             -l 1 -T ${type} -i ${index} -t ${thread} -o ${outPath} #-C ${chr}
else 
# time /usr/bin/time -v -o ${esttime} 
sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ}  -m DBSLMM \
             -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
             -l 1 -T ${type} -c ${cov} -i ${index} -t ${thread} -o ${outPath} #-C ${chr}
fi

fi
done
done