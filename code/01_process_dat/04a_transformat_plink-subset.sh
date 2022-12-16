#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=2:00:00
#SBATCH --job-name=toa
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=4-6
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/toa_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/toa_%a.err


path=~/research/ukb-intervals/
let k=3

ids_to_keep=${path}plink_file/pheno_list/ukb_337129_ids.txt
newdir=${path}plink_file/ukb/binary/redo/
mkdir -p ${newdir}
for chr in `seq 4 6`;do
    let k=${k}+1
    if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
        # move files to redo dir
        #mv ${path}plink_file/ukb/binary/chr${chr}.bed~ ${newdir}chr${chr}.bed
        #mv ${path}plink_file/ukb/binary/chr${chr}.bim~ ${newdir}chr${chr}.bim
        cp ${path}plink_file/ukb/binary/chr1.fam ${newdir}chr${chr}.fam
        bfile1=${newdir}chr${chr}
        bfile2=${path}plink_file/ukb/binary/chr${chr}
        #subset
        plink-1.9 --bfile ${bfile1} --keep ${ids_to_keep} --make-bed --out ${bfile2}
    fi
done

