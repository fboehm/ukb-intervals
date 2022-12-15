#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=2-00:00:00
#SBATCH --job-name=toa
#SBATCH --mem=10G
#SBATCH --cpus-per-task=5
#SBATCH --array=1-22
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/toa_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/toa_%a.err


path=~/research/ukb-intervals/
let k=0


for chr in `seq 1 22`;do
    let k=${k}+1
    if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
        ids_to_keep=${path}plink_file/pheno_list/ukb_337129_ids.txt
        bfile1=${path}plink_file/ukb/binary/chr${chr}
        bfile2=${path}plink_file/ukb/binary/chr${chr}
        #subset
        plink-1.9 --bfile ${bfile1} --keep ${ids_to_keep} --make-bed --out ${bfile2}
    fi
done

