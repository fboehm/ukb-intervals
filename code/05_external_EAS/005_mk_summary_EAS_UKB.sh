#!/bin/bash

#SBATCH --partition=nomosix
#SBATCH --time=00:30:00
#SBATCH --job-name=mksum
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-23
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/05_make_summary_EAS_UKB_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/05_make_summary_EAS_UKB_%a.err

bash
let k=0
gemma=/net/mulan/home/yasheng/comparisonProject/program/gemma-0.98.1-linux-static
compstr=/net/mulan/disk2/yasheng/comparisonProject/

for p in `seq 3 25`
do
let k=${k}+1

if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

for chr in `seq 1 22`
do

bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/EAS/hm3/chr${chr}
summ=pheno${p}_chr${chr}

echo continuous phenotype
cd ${compstr}07_external_c/03_EAS/01_raw
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${p} -o ${summ}
sed -i '1d' ${compstr}07_external_c/03_EAS/01_raw/output/${summ}.assoc.txt
rm ${compstr}07_external_c/03_EAS/01_raw/output/${summ}.log.txt

done

cat ${compstr}07_external_c/03_EAS/01_raw/output/pheno${p}_chr*.assoc.txt > ${compstr}07_external_c/03_EAS/01_raw/output/pheno${p}.assoc.txt
rm ${compstr}07_external_c/03_EAS/01_raw/output/pheno${p}_chr*.assoc.txt
fi

done



