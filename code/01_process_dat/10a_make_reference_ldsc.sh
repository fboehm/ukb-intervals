#!/bin/bash


CONDA_BASE=$(conda info --base) 
source $CONDA_BASE/etc/profile.d/conda.sh

trait_types=(binary continuous)
fbstr=~/research/ukb-intervals/
#ldsc=/usr/cluster/ldsc/ldsc.py
ldsc=~/ldsc/ldsc.py


for trait_type in ${trait_types[@]}; do
	outpath=${fbstr}04_reference/ukb/${trait_type}/ldsc/
	mkdir -p ${outpath}
	for chr in `seq 2 22`;do
			conda activate ldsc2
			python2 ${ldsc} --out ${outpath}${chr} \
					--bfile ${fbstr}04_reference/ukb/${trait_type}/geno/chr${chr} \
					--l2 \
					--ld-wind-kb 1000.0 
	done
done
