#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=3:00:00
#SBATCH --job-name=mksum
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1

#SBATCH --array=1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fredboe@umich.edu  


bash
let k=0
gemma=/net/mulan/home/yasheng/comparisonProject/program/gemma-0.98.1-linux-static
#compstr=/net/mulan/disk2/yasheng/comparisonProject/
compstr=~/research/ukb-intervals/dat/
dat=1
type=ukb


#npheno=24
#for p in 9
#for p in `seq 2 25`
for p in 1
do
for chr in 1
do




let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then
let col=1

bfile=~/research/ukb-intervals/dat/plink_files/ukb-gemma-training/pheno${p}/chr${chr}
#summ=summary_${type}_pheno${p}_cross${cross}_chr${chr}
summ=summary_${type}_pheno${p}_training_chr${chr}


echo continuous phenotype
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ}
#sed -i '1d' ${compstr}05_internal_c/pheno${p}/output/${summ}.assoc.txt
sed -i '1d' ~/research/ukb-intervals/shell_scripts/output/${summ}.assoc.txt
#rm ${compstr}05_internal_c/pheno${p}/output/${summ}.log.txt


fi

done
done
#done

