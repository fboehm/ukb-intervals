#!/bin/bash


#SBATCH --partition=mulan,nomosix
#SBATCH --time=1-00:00:00
#SBATCH --job-name=gemma
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-1100%50
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/gemma_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/gemma_%a.err
#SBATCH --mail-user=fredboe@umich.edu  
#SBATCH --mail-type=ALL


bash
let k=0
type=ukb
gemma=/net/mulan/home/yasheng/comparisonProject/program/gemma-0.98.1-linux-static

for p in `seq 1 10`
do
for fold in `seq 1 5`
do 
for chr in `seq 1 22`
do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

bfile=~/research/ukb-intervals/dat/simulations-ding/gemma/chr${chr}
summ=summary_${type}_chr${chr}_pheno${p}_fold${fold}

col=(${p} - 1) * 5 + ${fold}
cd ~/research/ukb-intervals/dat/simulations-ding/gemma
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ}

fi

done 
done
done