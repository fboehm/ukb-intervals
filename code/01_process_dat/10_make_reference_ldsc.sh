#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=1-00:00:00
#SBATCH --job-name=ldsc_ref
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-44
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/10_ldsc_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/10_ldsc_%a.err

trait_types=(binary continuous)
fbstr=~/research/ukb-intervals/
ldsc=/usr/cluster/ldsc/ldsc.py
let k=0

for trait_type in ${trait_types[@]}; do
	outpath=${fbstr}04_reference/ukb/${trait_type}/ldsc/
	mkdir -p ${outpath}
	for chr in `seq 1 22`;do
		let k=${k}+1
		if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
			source activate ldsc
			python ${ldsc} --out ${outpath}${chr} \
					--bfile ${fbstr}04_reference/ukb/${trait_type}/geno/chr${chr} \
					--l2 \
					--ld-wind-kb 1000.0 
		fi
	done
done
