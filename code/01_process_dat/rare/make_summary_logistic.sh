#!/bin/bash

#SBATCH --partition=nomosix,mulan
#SBATCH --time=1-00:00:00
#SBATCH --job-name=mksum
#SBATCH --mem=15G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-2640%880
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/08_make_summary_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/08_make_summary_%a.err

bash
let k=0
compstr=/net/mulan/disk2/yasheng/comparisonProject/
type=hm3

for p in `seq 2 25`
do
for cross in 1 2 3 4 5
do
for chr in `seq 1 22`
do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

bfile=/net/mulan/home/yasheng/predictionProject/plink_file/${type}/chr${chr}
pheno_dat=/net/mulan/home/yasheng/predictionProject/plink_file/hm3/plink_pheno${p}_cross${cross}.fam
summ=${compstr}06_internal_b/pheno${p}/output/summary_${type}_cross${cross}_chr${chr}

# cov
if ((${p}==1 || ${p}==6 || ${p}==21))
then
cov=${compstr}02_pheno/08_cov_nosex_plink.txt
else
cov=${compstr}02_pheno/07_cov_plink.txt
fi
# plink 
plink-1.9 --bfile ${bfile} --logistic hide-covar --covar ${cov} \
--pheno ${pheno_dat} --out ${summ}

rm ${summ}.log

sed -i '1d' ${summ}.assoc.logistic

# # paste Allele2

# A2=${bfile}_A2.txt
# if [ -f ${A2} ]
# then
# awk '{print $6}' ${bfile}.bim > ${A2}
# fi

# if ((`cat ${A2} | wc -l`==`cat ${summ}.assoc.logistic | wc -l`))
# then
# paste ${summ}_tmp.assoc.logistic ${A2} > ${summ}.assoc.logistic
# else
# echo "summ lines is not equal to bim!"
# fi


fi

done
done
done

