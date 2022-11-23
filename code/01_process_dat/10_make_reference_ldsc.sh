#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=1-00:00:00
#SBATCH --job-name=ldsc
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-22
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/10_ldsc_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/10_ldsc_%a.err



fbstr=~/research/ukb-intervals/
outpath=${fbstr}04_reference/ukb/ldsc/

mkdir -p ${outpath}
let k=0
for chr in `seq 1 22`;do
    let k=${k}+1
    if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
		ldsc --out ${outpath}${chr} \
				--bfile ${fbstr}plink_file/ukb/continuous/chr${chr} \
				--l2  --ld-wind-kb 1000.0 \
				--keep ${fbstr}04_reference/01_idx.txt
	fi
done

