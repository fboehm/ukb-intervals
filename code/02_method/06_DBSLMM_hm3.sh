#!/bin/bash

#SBATCH --partition=nomosix,mulan
#SBATCH --time=06:00:00
#SBATCH --job-name=DBSLMMc_eas
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4

#SBATCH --array=1-125
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/06_DBSLMMb_eas_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/06_DBSLMMb_eas_%a.err

bash 
let k=0
let thread=4

dat=continuous
type=t
compstr=/net/mulan/disk2/yasheng/comparisonProject/
plink=/usr/cluster/bin/plink-1.9
DBSLMM=${compstr}code/02_method/06_DBSLMM_script.sh
DBSLMMpath=/net/mulan/home/yasheng/predictionProject/code/
blockf=${compstr}LDblock_EUR/chr
ref=${compstr}04_reference/hm3/geno/chr

for p in `seq 1 25`; do
for cross in 1 2 3 4 5; do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

# phenoMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DB_miss/pheno.txt
# crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DB_miss/cross.txt
# chrMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DB_miss/chr.txt
# for iter in `seq 1 400`
# do
# let k=${k}+1
# if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
# then
# p=`head -n ${iter} ${phenoMiss} | tail -n 1`
# cross=`head -n ${iter} ${crossMiss} | tail -n 1`
# chr=`head -n ${iter} ${chrMiss} | tail -n 1`
# echo pheno${p}_cross${cross}_chr${chr}

# 
val=${compstr}03_subsample/${dat}/pheno${p}/val/hm3/impute_inter/chr

if [[ "$dat" == "continuous" ]]
then
# phenoVal=${compstr}03_subsample/${dat}/pheno${p}/02_pheno_c.txt
phenoVal=${compstr}/03_subsample/${dat}/pheno${p}/val/ukb/02_pheno_c.txt
index=r2
else
phenoVal=${compstr}03_subsample/${dat}/pheno${p}/val/ukb/02_pheno_b.txt
index=auc
fi

## input
if [[ "$dat" == "continuous" ]]
then
herit=${compstr}05_internal_c/pheno${p}/herit/h2_hm3_cross${cross}.log
summ=${compstr}05_internal_c/pheno${p}/output/sub_sum/summary_hm3_cross${cross}_chr
outPath=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/DBSLMM/EAS_sub/
else
herit=${compstr}06_internal_b/pheno${p}/herit/h2_hm3_cross${cross}.log
summ=${compstr}06_internal_b/pheno${p}/output/summary_hm3_cross${cross}_chr
outPath=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/DBSLMM/
cov=${compstr}03_subsample/${dat}/pheno${p}/val/03_cov_eff.txt
fi


## DBSLMM
esttime=${compstr}01_time_file/06_DBSLMM_hm3_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
if [[ "$dat" == "continuous" ]]
then
# time /usr/bin/time -v -o ${esttime} 
sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ} -m DBSLMM\
             -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
             -l 1 -T ${type} -i ${index} -t ${thread} -o ${outPath} #-C ${chr}
else 
# time /usr/bin/time -v -o ${esttime} 
sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ}  -m DBSLMM\
             -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
             -l 1 -T ${type} -c ${cov} -i ${index} -t ${thread} -o ${outPath} #-C ${chr}
fi

fi
done
done