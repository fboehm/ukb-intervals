#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=03:00:00
#SBATCH --job-name=herit
#SBATCH --mem-per-cpu=10G

#SBATCH --array=1-125
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/04_herit_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/04_herit_%a.err

bash
let k=0

ldsc=/net/mulan/home/yasheng/comparisonProject/program/ldsc/ldsc.py
mkldsc=/net/mulan/home/yasheng/comparisonProject/code/02_method/04_mk_ldsc_summ.R
compstr=/net/mulan/disk2/yasheng/comparisonProject/
dat=c
reftype=ukb

for p in `seq 1 25`; do
for cross in 1 2 3 4 5; do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

ref=/net/mulan/disk2/yasheng/comparisonProject/04_reference/${reftype}/ldsc/

if [[ "$dat" == "c" ]]
then
summ=${compstr}05_internal_c/pheno${p}/output/summary_${reftype}_cross${cross}
h2=${compstr}05_internal_c/pheno${p}/herit/h2_${reftype}_cross${cross}
else
summ=${compstr}06_internal_b/pheno${p}/output/summary_hm3_cross${cross}
h2=${compstr}06_internal_b/pheno${p}/herit/h2_${reftype}_cross${cross}
fi

## summary data for ldsc
cat ${summ}_chr*.assoc.txt > ${summ}.assoc.txt
sed -i '/chr/d' ${summ}.assoc.txt
Rscript ${mkldsc} --summgemma ${summ}.assoc.txt --summldsc ${summ}.ldsc

## heritability
source activate /net/mulan/home/yasheng/py3/envs/ldsc
python2 ${ldsc} --h2 ${summ}.ldsc.gz --ref-ld-chr ${ref} --w-ld-chr ${ref} --out ${h2}
rm ${summ}.ldsc.gz
fi
done
done
