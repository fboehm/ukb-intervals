#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=3-00:00:00
#SBATCH --job-name=mksum_m
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-1611
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/08_make_summary_m_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/08_make_summary_m_%a.err

bash
let k=0
gemma=/net/mulan/home/yasheng/comparisonProject/program/gemma-0.98.1-linux-static
compstr=/net/mulan/disk2/yasheng/comparisonProject/
dat=1
type=ukb

# for p in `seq 2 25`
# do
# for cross in 1 2 3 4 5
# do
# for chr in `seq 1 22`
# do

# let k=${k}+1
# if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
# then

phenoMiss=/net/mulan/disk2/yasheng/comparisonProject/code/01_process_dat/miss_sum/pheno.txt
crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/01_process_dat/miss_sum/cross.txt
chrMiss=/net/mulan/disk2/yasheng/comparisonProject/code/01_process_dat/miss_sum/chr.txt

for iter in `seq 1 1611`
do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

p=`head -n ${iter} ${phenoMiss} | tail -n 1`
cross=`head -n ${iter} ${crossMiss} | tail -n 1`
chr=`head -n ${iter} ${chrMiss} | tail -n 1`
echo pheno${p}_cross${cross}_chr${chr}

let col=(${p}-1)*5+${cross}

bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/${type}/chr${chr}
summ=summary_${type}_cross${cross}_chr${chr}

if [ ${dat} -eq 1 ]
then

echo continuous phenotype
cd ${compstr}05_internal_c/pheno${p}
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ}
sed -i '1d' ${compstr}05_internal_c/pheno${p}/output/${summ}.assoc.txt
rm ${compstr}05_internal_c/pheno${p}/output/${summ}.log.txt

else

echo binary phenotype
if ((${p}==1 || ${p}==6 || ${p}==21))
then
cov=${compstr}02_pheno/08_cov_nosex.txt
else
cov=${compstr}02_pheno/07_cov.txt
fi
cd ${compstr}06_internal_b/pheno${p}
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ} -c ${cov}
sed -i '1d' ${compstr}06_internal_b/pheno${p}/output/${summ}.assoc.txt
rm ${compstr}06_internal_b/pheno${p}/output/${summ}.log.txt

fi

fi

done
# done
# done

