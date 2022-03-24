#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=3-00:00:00
#SBATCH --job-name=EUR
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-140
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/10_ext_EUR_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/10_ext_EUR_%a.err

bash 
let k=0

compstr=/net/mulan/disk2/yasheng/comparisonProject/
EXT=/net/mulan/home/yasheng/predictionProject/code/DBSLMM/software/EXTERNAL.R
data=${compstr}code/04_external_EUR/dat.txt
pheno=${compstr}code/04_external_EUR/pheno.txt
LDpath=${compstr}09_external_LD/EUR/LD_mat
MAF=/net/mulan/disk2/yasheng/predictionProject/plink_file/hm3/merge.frq


for iter in `seq 1 28`
# for iter in 2
do
for m in bagging
do
for cross in 1 2 3 4 5
do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

p=`head -n ${iter} ${pheno} | tail -n 1`
d=`head -n ${iter} ${data} | tail -n 1`
summ=${compstr}07_external_c/02_EUR/02_clean/pheno${p}_data${d}_herit.ldsc.gz

if [ $m == "nps" ]
then
esteff=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/${m}/esteff_cross${cross}.txt
esteffchr=${compstr}05_internal_c/pheno${p}/${m}/est/esteff_cross${cross}_chr
zcat ${esteffchr}*.txt.gz > $esteff
out=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/${m}/r2_cross${cross}.txt
Rscript ${EXT} --extsumm ${summ} --esteff ${esteff},1,2,3 --maf ${MAF} --LDpath ${LDpath} --outfile ${out}
rm ${esteff}
fi

if [ $m == "PRScs" ]
then
esteff=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/${m}/esteff_cross${cross}.txt
esteffchr=${compstr}05_internal_c/pheno${p}/${m}/esteff_cross${cross}_chr
cat ${esteffchr}*_best.txt > $esteff
out=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/${m}/r2_cross${cross}.txt
Rscript ${EXT} --extsumm ${summ} --esteff ${esteff},2,4,6 --maf ${MAF} --LDpath ${LDpath} --outfile ${out}
rm ${esteff}
fi

if [ $m == "lassosum" ] || [ $m == "SCT" ] || [ $m == "CT" ]
then
esteff=${compstr}05_internal_c/pheno${p}/${m}/esteff_hm3_cross${cross}.txt
out=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/${m}/r2_cross${cross}.txt
Rscript ${EXT} --extsumm ${summ} --esteff ${esteff},1,2,3 --maf ${MAF} --LDpath ${LDpath} --outfile ${out}
fi

if [ $m == "bagging" ]
then
esteff=${compstr}05_internal_c/pheno${p}/${m}/esteff_cross${cross}.txt.gz
out=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/${m}/r2_cross${cross}.txt
Rscript ${EXT} --extsumm ${summ} --esteff ${esteff},1,2,3  --maf ${MAF} --LDpath ${LDpath} --outfile ${out}
fi

if [ $m == "SbayesR" ]
then
esteff=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/${m}/esteff_cross${cross}.txt
esteffchr=${compstr}05_internal_c/pheno${p}/${m}/esteff_cross${cross}_chr
zcat ${esteffchr}*.snpRes.gz > $esteff
sed -i '/Chrom/d' $esteff
out=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/${m}/r2_cross${cross}.txt
Rscript ${EXT} --extsumm ${summ} --esteff ${esteff},2,5,8 --maf ${MAF} --LDpath ${LDpath} --outfile ${out}
rm ${esteff}
fi

if [ $m == "sblup" ]
then
esteff=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/${m}/esteff_cross${cross}.txt
esteffchr=${compstr}05_internal_c/pheno${p}/${m}/esteff_hm3_cross${cross}_chr
zcat ${esteffchr}*.sblup.cojo.gz > $esteff
out=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/${m}/r2_cross${cross}.txt
Rscript ${EXT} --extsumm ${summ} --esteff ${esteff},1,2,3 --LDpath ${LDpath} --outfile ${out}
rm ${esteff}
fi

if [ $m == "DBSLMM" ]
then
esteff=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/${m}/esteff_hm3_cross${cross}.txt.gz
esteffchr=${compstr}05_internal_c/pheno${p}/${m}/summary_hm3_cross${cross}_chr
zcat ${esteffchr}*_best.dbslmm.txt.gz > $esteff
out=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/${m}/r2_cross${cross}.txt
Rscript ${EXT} --extsumm ${summ} --esteff ${esteff},1,2,4 --maf ${MAF} --LDpath ${LDpath} --outfile ${out}
rm ${esteff}
fi

if [ $m == "inf" ] 
then
esteff=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/LDpred2/inf_esteff_hm3_cross${cross}.txt
esteffchr=${compstr}05_internal_c/pheno${p}/LDpred2/esteff_hm3_cross${cross}_chr
cat ${esteffchr}*.txt > $esteff
out=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/LDpred2/inf_r2_cross${cross}.txt
Rscript ${EXT} --extsumm ${summ} --esteff ${esteff},1,2,3 --maf ${MAF} --LDpath ${LDpath} --outfile ${out}
rm ${esteff}
fi

if [ $m == "sp" ] 
then
esteff=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/LDpred2/sp_esteff_hm3_cross${cross}.txt
esteffchr=${compstr}05_internal_c/pheno${p}/LDpred2/esteff_hm3_cross${cross}_chr
cat ${esteffchr}*.txt > $esteff
out=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/LDpred2/sp_r2_cross${cross}.txt
Rscript ${EXT} --extsumm ${summ} --esteff ${esteff},1,2,4 --maf ${MAF} --LDpath ${LDpath} --outfile ${out}
rm ${esteff}
fi

if [ $m == "nosp" ] 
then
esteff=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/LDpred2/nosp_esteff_hm3_cross${cross}.txt
esteffchr=${compstr}05_internal_c/pheno${p}/LDpred2/esteff_hm3_cross${cross}_chr
cat ${esteffchr}*.txt > $esteff
out=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/LDpred2/nosp_r2_cross${cross}.txt
Rscript ${EXT} --extsumm ${summ} --esteff ${esteff},1,2,5 --maf ${MAF} --LDpath ${LDpath} --outfile ${out}
rm ${esteff}
fi

if [ $m == "auto" ] 
then
esteff=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/LDpred2/auto_esteff_hm3_cross${cross}.txt
esteffchr=${compstr}05_internal_c/pheno${p}/LDpred2/esteff_hm3_cross${cross}_chr
cat ${esteffchr}*.txt > $esteff
out=${compstr}07_external_c/02_EUR/03_res/pheno${p}_data${d}/LDpred2/auto_r2_cross${cross}.txt
Rscript ${EXT} --extsumm ${summ} --esteff ${esteff},1,2,6 --maf ${MAF} --LDpath ${LDpath} --outfile ${out}
rm ${esteff}
fi

fi
done
done
done
