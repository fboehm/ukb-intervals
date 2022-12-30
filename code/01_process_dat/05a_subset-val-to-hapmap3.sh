#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=12:00:00
#SBATCH --job-name=subset-to-hapmap3
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-1100%400
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/subset-to-hm3_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/subset-to-hm3_%a.err



trait_types=(continuous binary)
let k=0
fbstr=~/research/ukb-intervals/

for trait_type in ${trait_types[@]}; do
    for p in `seq 1 25`; do
        for chr in `seq 1 22`;do
            let k=${k}+1
            if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
                old_val_plink_prefix=${fbstr}study_nfolds/5-fold/03_subsample/${trait_type}/pheno${p}/val/ukb/geno/chr${chr}
                newdir=${fbstr}study_nfolds/5-fold/03_subsample/${trait_type}/pheno${p}/val/hm3/geno/
                mkdir -p ${newdir}
                new_val_plink_prefix=${newdir}chr${chr}
                snps_to_keep=${fbstr}hapmap3/CEU_snp_ids_chr${chr}
                plink-1.9 --bfile ${old_val_plink_prefix} --extract ${snps_to_keep} --make-bed --out ${new_val_plink_prefix}
            fi
        done
    done
done
