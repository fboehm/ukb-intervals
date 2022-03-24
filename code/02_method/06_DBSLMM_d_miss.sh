#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=24:00:00
#SBATCH --job-name=DBSLMM
#SBATCH --mem=12G
#SBATCH --cpus-per-task=5

#SBATCH --array=1-29
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/06_DBSLMM_ukb_thread1_c_m_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/06_DBSLMM_ukb_thread1_c_m_%a.err

bash 
let k=0

thread=1

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
DBSLMMpath=/net/mulan/home/yasheng/predictionProject/code/
DBSLMM=${DBSLMMpath}DBSLMM/software/DBSLMM.R
dbslmm=${DBSLMMpath}DBSLMM/scr/dbslmm
blockf=/net/mulan/disk2/yasheng/comparisonProject/LDblock_EUR/chr
ref=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/ukb/geno/chr

phenoMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_d_miss/pheno.txt
crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_d_miss/cross.txt
chrMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_d_miss/chr.txt


for iter in `seq 1 29`
do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
p=`tail -n+${iter} ${phenoMiss} | head -1`
cross=`tail -n+${iter} ${crossMiss} | head -1`
chr=`tail -n+${iter} ${chrMiss} | head -1`
## input
if [[ "$dat" == "c" ]]
then
herit=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/herit/h2_ukb_cross${cross}.log
summ=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/output/summary_ukb_cross${cross}_chr
outPath=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/DBSLMM/ukb/
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

# LDSC: heritability and number of SNP
nsnp=`sed -n '24p' ${herit} | cut -d ',' -f 2 | cut -d ' ' -f 2`
h2=`sed -n '26p' ${herit} | cut -d ":" -f 2 | cut -d '(' -f 1 | cut -d " " -f 2`

## DBSLMM default version
gunzip ${summ}${chr}.assoc.txt.gz

BLOCK=${blockf}${chr}
summchr=${summ}${chr}
val_geno=${ref}${chr}
summchr=${summ}${chr}
nobs=`sed -n "2p" ${summchr}.assoc.txt | awk '{print $5}'`
nmis=`sed -n "2p" ${summchr}.assoc.txt | awk '{print $4}'`
n=$(echo "${nobs}+${nmis}" | bc -l)
echo ${model}
Rscript ${DBSLMM} --summary ${summchr}.assoc.txt --outPath ${outPath} --plink ${plink} --model DBSLMM\
                  --dbslmm ${dbslmm} --ref ${val_geno} --n ${n} --nsnp ${nsnp} --block ${BLOCK}.bed\
                  --h2 ${h2} --thread ${thread}
summchr_prefix=`echo ${summchr##*/}`
rm ${outPath}${summchr_prefix}.dbslmm.badsnps

gzip ${summ}${chr}.assoc.txt

fi
done



