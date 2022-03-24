#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=1-00:00:00
#SBATCH --job-name=mksum_rare_b
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-2750
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/08_make_summary_rare_b%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/08_make_summary_rare_b%a.err

bash
let k=0
gemma=/net/mulan/home/yasheng/comparisonProject/program/gemma-0.98.1-linux-static
compstr=/net/mulan/disk2/yasheng/comparisonProject/
dat=2

for p in `seq 1 25`
do
for cross in 1 2 3 4 5
do
for chr in `seq 1 22`
do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then
let col=(${p}-1)*5+${cross}

bfile=/net/mulan/home/yasheng/predictionProject/plink_file/rare/chr${chr}
summ_hm3_rare=summary_hm3_rare_cross${cross}_chr${chr}
summ_hm3=summary_hm3_cross${cross}_chr${chr}

if [ ${dat} -eq 1 ]
then

echo continuous phenotype
cd ${compstr}05_internal_c/pheno${p}
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ_hm3_rare} -maf 0
sed -i '1d' ${compstr}05_internal_c/pheno${p}/output/${summ_hm3_rare}.assoc.txt
rm ${compstr}05_internal_c/pheno${p}/output/${summ_hm3_rare}.log.txt

else

echo binary phenotype
if ((${p}==1 || ${p}==6 || ${p}==21))
then
cov=${compstr}02_pheno/08_cov_nosex.txt
else
cov=${compstr}02_pheno/07_cov.txt
fi
cd ${compstr}06_internal_b/pheno${p}
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ_hm3_rare} -c ${cov}  -maf 0
sed -i '1d' ${compstr}06_internal_b/pheno${p}/output/${summ_hm3_rare}.assoc.txt
rm ${compstr}06_internal_b/pheno${p}/output/${summ_hm3_rare}.log.txt

fi

cat ./output/${summ_hm3}.assoc.txt >> ./output/${summ_hm3_rare}.assoc.txt
fi

done
done
done

