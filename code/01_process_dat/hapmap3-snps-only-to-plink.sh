#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=2-00:00:00
#SBATCH --job-name=small-plink
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-22
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/small-plink_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/small-plink_%a.err




let k=0


for chr in `seq 1 22`; do
    let k=${k}+1
    if [ ${k} -eq ${SLURM_ARRAY_TASK_IDplink_file/ukb-small_plink/binary ]; then
        big_plink=~/research/ukb-intervals/plink_file/ukb/binary/chr${chr}
        small_plink=~/research/ukb-intervals/hapmap3/chr${chr}
        snp_ids=~/research/ukb-intervals/hapmap3/CEU_snp_ids_chr${chr}
        plink-1.9 --bfile ${big_plink} --extract ${snp_ids} --make-bed --out ${small_plink}
    fi
done    
