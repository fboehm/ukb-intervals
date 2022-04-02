#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=2-00:00:00
#SBATCH --job-name=DBSLMM
#SBATCH --mem=12G
#SBATCH --cpus-per-task=5

#SBATCH --array=1-5
#SBATCH --output=06_DBSLMM_ukb_c_%a.out
#SBATCH --error=06_DBSLMM_ukb_c_%a.err

bash 
let k=0
let thread=5

dat=continuous
type=t

compstr=/net/mulan/disk2/yasheng/comparisonProject/
plink=/usr/cluster/bin/plink-1.9
DBSLMM=06_DBSLMM_script.sh
DBSLMMpath=~/research/
blockf=${compstr}LDblock_EUR/chr
ref=${compstr}04_reference/ukb/geno/chr

for p in 1; do
for cross in 1 2 3 4 5; do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

# phenoMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_miss/pheno.txt
# crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_miss/cross.txt
# chrMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_miss/chr.txt
# h2fMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_miss/h2f.txt
# pthMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_miss/pth.txt
# for iter in `seq 1 5`
# do
# let k=${k}+1
# if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
# then
# p=`head -n ${iter} ${phenoMiss} | tail -n 1`
# cross=`head -n ${iter} ${crossMiss} | tail -n 1`
# chr=`head -n ${iter} ${chrMiss} | tail -n 1`
# h2f=`head -n ${iter} ${h2fMiss} | tail -n 1`
# pth=`head -n ${iter} ${pthMiss} | tail -n 1`
# echo pheno${p}_cross${cross}_chr${chr}_h2f${h2f}_pth${pth}

# 
val=${compstr}03_subsample/${dat}/pheno${p}/val/ukb/impute_inter/chr

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
herit=${compstr}05_internal_c/pheno${p}/herit/h2_ukb_cross${cross}.log
summ=${compstr}05_internal_c/pheno${p}/output/summary_ukb_cross${cross}_chr
outPath=~/research/ukb-intervals/results/pheno${p}/
else
herit=${compstr}06_internal_b/pheno${p}/herit/h2_ukb_cross${cross}.log
summ=${compstr}06_internal_b/pheno${p}/output/summary_ukb_cross${cross}_chr
outPath=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/DBSLMM/
cov=${compstr}03_subsample/${dat}/pheno${p}/val/ukb/03_cov_eff.txt
fi


## DBSLMM
# esttime=${compstr}01_time_file/06_DBSLMM_hm3_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
if [[ "$dat" == "continuous" ]]
then
# time /usr/bin/time -v -o ${esttime} 
sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ} -m DBSLMM\
             -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
             -l 1 -T ${type} -i ${index} -t ${thread} -o ${outPath} \
             --test_indices_file ${/net/mulan/disk2/yasheng/comparisonProject/02_pheno/idx_pheno1_cross1.txt} \
             --dat_str ${/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/chr22.bed} \
             --indicator_file ${}
             
else 
# time /usr/bin/time -v -o ${esttime} 
sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ}  -m DBSLMM\
             -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
             -l 1 -T ${type} -c ${cov} -i ${index} -t ${thread} -o ${outPath} #-C ${chr} -f ${h2f} -h ${pth}
fi


# for chr in `seq 1 22`
# do 
# gzip ${summ}${chr}.assoc.txt
# done

fi
done
done



