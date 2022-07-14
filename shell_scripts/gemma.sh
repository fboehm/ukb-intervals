#!/bin/bash


#SBATCH --partition=mulan,main
#SBATCH --time=2-00:00:00
#SBATCH --job-name=gemma
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-1100%200
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/gemma_hsq0.1_pcausal0.1/gemma_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/gemma_hsq0.1_pcausal0.1/gemma_%a.err


# parse command line args
# https://www.baeldung.com/linux/use-command-line-arguments-in-bash-script
# https://help.rc.ufl.edu/doc/Using_Variables_in_SLURM_Jobs
#while getopts h:p: flag
#do
#    case "${flag}" in
#        h) hsq=${OPTARG};;
#        p) pc=${OPTARG};;
#    esac
#done
# h and p are passed as command line args
hsq=${h}
pc=${p}


# 
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
#pc=0.001
#pc=0.1
#hsq=0.2
#hsq=0.5
for p in `seq 1 10`
do
for fold in 1 2 3 4 5
do 
for chr in `seq 1 22`
do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

bfile=~/research/ukb-intervals/dat/simulations-ding/gemma_hsq${hsq}_pcausal${pc}/chr${chr}
summ=summary_${type}_pheno${p}_fold${fold}_chr${chr}

let col=(${p}-1)\*5+${fold}
echo ${col}
cd ~/research/ukb-intervals/dat/simulations-ding/gemma_hsq${hsq}_pcausal${pc}
#file=output/${summ}.assoc.txt
#if [ ! -f "$file" ]; then # check if file doesn't exist
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ}
#fi
fi

done 
done
done
