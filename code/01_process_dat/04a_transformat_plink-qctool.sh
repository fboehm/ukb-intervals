#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=1-00:00:00
#SBATCH --job-name=toplink-qctool
#SBATCH --mem=10G
#SBATCH --cpus-per-task=5

#SBATCH --array=1-22
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/toplink-qctool_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/toplink-qctool_%a.err

let k=0
qctool=/net/mulan/home/yasheng/comparisonProject/program/qctool_v2.0.6-Ubuntu16.04-x86_64/qctool
brIdx2=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/rareIdx.txt
sample=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/ukb_all_info.sample

for chr in `seq 1 22`;do
    let k=${k}+1
    if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
        bgen=/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_imp_chr${chr}_v2
        subbgen=/net/mulan/home/yasheng/predictionProject/plink_file/rare/chr${chr}
        raresnp=/net/mulan/disk2/yasheng/predictionProject/plink_file/rare_snp_list/chr${chr}.txt
        ${qctool} -g ${bgen}.bgen -s ${sample} -og ${subbgen}.bgen -incl-rsids ${raresnp} -incl-samples ${brIdx2}
    fi
done

