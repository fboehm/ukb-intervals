#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=1-00:00:00
#SBATCH --job-name=allele-scoring-verif
#SBATCH --mem=2G
#SBATCH --array=1-220
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/allele-scoring-verification_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/allele-scoring-verification_%a.err

let k=0
dats=(continuous binary)

for dat in ${dats[@]}; do
  	for chr in `seq 1 22`;do
    	for p in `seq 1 25`; do
      		for cross in `seq 1 5`; do
				let k=${k}+1
				if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
					# bfile
					fbstr=~/research/ukb-intervals/
					#compstr=/net/mulan/home/yasheng/comparisonProject/
					bfile=${fbstr}plink_file/ukb/${dat}/chr${chr}
					if [ "$dat" == "continuous" ]; then
						#idxtest=${compstr1}02_pheno/01_test_idx_c/idx_pheno${p}_cross${cross}.txt
						idxverif=${fbstr}03_subsample/continuous/pheno${p}/verif/01_idx.txt
						esteffdbslmmt=${fbstr}05_internal_c/pheno${p}/DBSLMM/summary_ukb_cross${cross}_chr${chr}_best.dbslmm.txt
						# outfile defined here
						preddbslmmt=${fbstr}05_internal_c/pheno${p}/DBSLMM/verif_pred_ukb_best_cross${cross}_chr${chr}
						# aggdbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/agg_hm3_best_cross${cross}_chr${chr}
					else 
						#idxtest=${compstr1}02_pheno/04_test_idx_b/idx_pheno${p}_cross${cross}.txt
						idxverif=${fbstr}03_subsample/binary/pheno${p}/verif/01_idx.txt
						esteffdbslmmt=${fbstr}06_internal_b/pheno${p}/DBSLMM/summary_ukb_cross${cross}_chr${chr}_best.dbslmm.txt
						# outfile defined here
						preddbslmmt=${fbstr}06_internal_b/pheno${p}/DBSLMM/verif_pred_ukb_best_cross${cross}_chr${chr}
					fi
					#gunzip ${esteffdbslmmt}.gz
					plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --keep ${idxverif} --out ${preddbslmmt}
					# plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --keep ${idxagg} --out ${aggdbslmm
        		fi
      		done
    	done
  	done
done  
