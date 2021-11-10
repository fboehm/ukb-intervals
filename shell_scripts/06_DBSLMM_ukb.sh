#!/bin/bash

# Modified from /net/mulan/home/fredboe/research/comparisonProject/code/02_method/06_DBSLMM_ukb.sh

#SBATCH --partition=mulan,nomosix
#SBATCH --time=24:00:00
#SBATCH --job-name=DBSLMM
#SBATCH --mem=12G
#SBATCH --cpus-per-task=5

#SBATCH --array=1
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/06_DBSLMM_ukb_thread5_c_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/06_DBSLMM_ukb_thread5_c_%a.err

bash
let k=0

thread=5

dat=c
type=t
if [[ "$dat" == "c" ]]
then
phenoVal=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/02_pheno_c.txt
index=r2
else
phenoVal=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/03_pheno_b.txt
index=auc
fi
plink=/usr/cluster/bin/plink-1.9
DBSLMM=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/06_DBSLMM_script.sh
DBSLMMpath=/net/mulan/home/yasheng/predictionProject/code/
blockf=/net/mulan/disk2/yasheng/comparisonProject/LDblock_EUR/chr
ref=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/ukb/geno/chr

phenoMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_miss/pheno.txt
crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_miss/cross.txt

for p in 23
do
for cross in 5
do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

## input
if [[ "$dat" == "c" ]]
then
herit=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/herit/h2_ukb_cross${cross}.log
#summ=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/output/summary_ukb_cross${cross}_chr
summ=~/research/ukb-intervals/dat/pheno${p}/output/summary_ukb_pheno${p}_cross${cross}_chr
outPath=~/research/ukb-intervals/dat/05_internal_c/pheno${p}/ukb/
else
herit=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/herit/h2_ukb_cross${cross}.log
summ=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/output/summary_ukb_cross${cross}_chr
outPath=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/DBSLMM/ukb/
if ((${p}==1 || ${p}==6 || ${p}==21))
then
cov=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/05_cov_nosex.txt
else
cov=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/04_cov.txt
fi
fi

#for chr in `seq 1 22`
#do
#gunzip ${summ}${chr}.assoc.txt.gz
#done

## DBSLMM
#esttime=/net/mulan/disk2/yasheng/comparisonProject/01_time_file/06_DBSLMM_ukb_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
esttime=~/research/ukb-intervals/dat/01_time_file/06_DBSLMM_ukb_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
if [[ "$dat" == "c" ]]
then

time /usr/bin/time -v -o ${esttime} 
sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ} -m DBSLMM\
             -H ${herit} -G ${ref} -P ${phenoVal}\
             -l ${p} -T ${type} -i ${index} -t ${thread} -o ${outPath}
else
time /usr/bin/time -v -o ${esttime} sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ} -m DBSLMM\
                                                 -H ${herit} -G ${ref} -P ${phenoVal}\
                                                 -l ${p} -T ${type} -c ${cov} -i ${index} -t ${thread} -o ${outPath}

fi

for chr in `seq 1 22`
do
gzip ${summ}${chr}.assoc.txt
done

fi
done
done
