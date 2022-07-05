#!/bin/bash


#SBATCH --partition=mulan,nomosix
#SBATCH --time=5-00:00:00
#SBATCH --job-name=gemma-check
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-5
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/gemma-check/gemma_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/gemma-check/gemma_%a.err


bash
let k=0
#let pc_ctr=0
type=ukb
gemma=/net/mulan/home/yasheng/comparisonProject/program/gemma-0.98.1-linux-static

#for pc in 0.001 0.01 1 0.1 0.1; do
#  let pc_ctr=${pc_ctr}+1
#    hsq=0.2
#    if [ ${pc_ctr} -eq 4 ]; then
#      hsq=0.1
#    fi
#    if [ ${pc_ctr} -eq 5 ]; then
#      hsq=0.5
#    fi
pc=0.001
hsq=0.2
#for p in `seq 1 10`
for p in 1
do
for fold in 1 2 3 4 5
do 
for chr in 22
do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

bfile=~/research/ukb-intervals/dat/simulations-ding/gemma_hsq${hsq}_pcausal${pc}/chr${chr}
summ=summary_${type}_pheno${p}_fold${fold}_chr${chr}

let col=(${p}-1)*5+${fold}
echo ${col}
cd ~/research/ukb-intervals/dat/simulations-ding/gemma-check
#file=output/${summ}.assoc.txt
#if [ ! -f "$file" ]; then # check if file doesn't exist
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ}
#fi
fi

done 
done
done
