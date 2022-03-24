#!/bin/bash

#SBATCH --partition=nomosix
#SBATCH --time=03:00:00
#SBATCH --job-name=sblup
#SBATCH --mem=8G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-2750%1000
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/05_sblup_hm3_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/05_sblup_hm3_%a.err

bash
let k=0
let ldr=1000
let thread=1

gcta=/net/mulan/home/yasheng/comparisonProject/program/gcta_1.93.1beta/gcta64
compstr=/net/mulan/disk2/yasheng/comparisonProject/
dat=binary

for p in `seq 1 25`; do
for cross in 1 2 3 4 5; do
for chr in `seq 1 22`; do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

ref=${compstr}04_reference/hm3_rare/geno/chr${chr}
if [[ "$dat" == "continuous" ]]
then
echo continuous
summ=${compstr}05_internal_c/pheno${p}/output/summary_hm3_cross${cross}_chr${chr}
esteff=${compstr}05_internal_c/pheno${p}/sblup/esteff_hm3_cross${cross}_chr${chr}
herit=${compstr}05_internal_c/pheno${p}/herit/h2_hm3_cross${cross}.log
fi

if [[ "$dat" == "binary" ]]
then
echo binary
summ=${compstr}06_internal_b/pheno${p}/output/summary_hm3_rare_cross${cross}_chr${chr}
esteff=${compstr}06_internal_b/pheno${p}/sblup/esteff_hm3_rare_cross${cross}_chr${chr}
herit=${compstr}06_internal_b/pheno${p}/herit/h2_hm3_rare_cross${cross}.log
fi

## heritability
hstr=`sed -n '26p' ${herit}`
hse=`echo ${hstr#*:}`
h2=`echo ${hse%(*}`

## snp number
m=`sed -n '24p' ${herit} | cut -d ',' -f 2 | cut -d ' ' -f 2`
cojo=$(echo "${m}*(1/${h2}-1)" | bc -l)

## sblup estimation
awk '{print $2,$6,$7,$8,$9,$10,$11,$5}' ${summ}.assoc.txt > ${summ}.ma
sed -i '1i\SNP A1 A2 freq b se p N' ${summ}.ma
# esttime=${compstr}01_time_file/05_sblup_hm3_${dat}_pheno${p}_cross${cross}_chr${chr}_thread${thread}.tm
# time /usr/bin/time -v -o ${esttime} 
${gcta} --bfile ${ref} --chr ${chr} --cojo-file ${summ}.ma --cojo-sblup ${cojo} --cojo-wind ${ldr} --thread-num ${thread} --out ${esteff} 

## remove file
rm ${esteff}.*badsnps
rm ${summ}.ma
rm ${esteff}.log
fi
done
done
done

