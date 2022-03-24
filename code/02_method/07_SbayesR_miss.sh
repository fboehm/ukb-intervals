#!/bin/bash

#SBATCH --partition=nomosix,mulan
#SBATCH --time=08:00:00
#SBATCH --job-name=SbayesR_m
#SBATCH --mem=32G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-37
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/07_SbayesR_miss_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/07_SbayesR_miss_%a.err

bash
let k=0
let thread=1

compstr=/net/mulan/disk2/yasheng/comparisonProject/
gctb=/net/mulan/home/yasheng/comparisonProject/program/gctb_2.0_Linux/gctb
dat=c


phenoMiss=${compstr}code/02_method/SbayesR_miss/pheno.txt
crossMiss=${compstr}code/02_method/SbayesR_miss/cross.txt
chrMiss=${compstr}code/02_method/SbayesR_miss/chr.txt

for iter in `seq 1 37`
do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

p=`head -n ${iter} ${phenoMiss} | tail -n 1`
cross=`head -n ${iter} ${crossMiss} | tail -n 1`
chr=`head -n ${iter} ${chrMiss} | tail -n 1`

refLD=/net/mulan/disk2/yasheng/comparisonProject/04_reference/hm3/ldm/chr${chr}
## SbayesR estimation
if [ "$dat" == "c" ]
then

summ=${compstr}05_internal_c/pheno${p}/output/summary_hm3_cross${cross}_chr${chr}
awk '{print $2,$6,$7,$8,$9,$10,$11,$5}' ${summ}.assoc.txt > ${summ}_SbayesR.ma
sed -i '1i\SNP A1 A2 freq b se p N' ${summ}_SbayesR.ma
esteff=${compstr}05_internal_c/pheno${p}/SbayesR/esteff_cross${cross}_chr${chr}

else 

summ=${compstr}06_internal_b/pheno${p}/output/summary_hm3_cross${cross}_chr${chr}
awk '{print $2,$6,$7,$8,$9,$10,$11,$5}' ${summ}.assoc.txt > ${summ}_SbayesR.ma
sed -i '1i\SNP A1 A2 freq b se p N' ${summ}_SbayesR.ma
esteff=${compstr}06_internal_b/pheno${p}/SbayesR/esteff_cross${cross}_chr${chr}

fi

# esttime=${compstr}01_time_file/07_SbayesR_hm3_${dat}_pheno${p}_cross${cross}_chr${chr}_thread${thread}.tm
# time /usr/bin/time -v -o ${esttime} 
${gctb} --sbayes R --ldm ${refLD}.ldm.shrunk --pi 0.95,0.02,0.02,0.01 --gamma 0.0,0.01,0.1,1 --gwas-summary ${summ}_SbayesR.ma --chain-length 10000 --burn-in 2000 --out-freq 5000 --out ${esteff}

## remove file
rm ${summ}_SbayesR.ma
rm ${esteff}.log
rm ${esteff}.parRes
rm ${esteff}.mcmcsamples.SnpEffects
rm ${esteff}.mcmcsamples.Par
rm ${esteff}.mcmcsamples.CovEffects
rm ${esteff}.covRes
fi
done

