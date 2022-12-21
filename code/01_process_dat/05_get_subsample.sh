#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=1-00:00:00
#SBATCH --job-name=subset
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-44
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/05_subsample_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/05_subsample_%a.err


compStr=~/research/ukb-intervals/
trait_types=(binary continuous)
let k=0


for trait_type in ${trait_types[@]}; do
    output_dir=${compStr}04_reference/ukb/${trait_type}/geno/
    mkdir -p ${output_dir}
    for chr in `seq 1 22`;do
        let k=${k}+1
		if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
            # ## subsample
            bfileAll=${compStr}plink_file/ukb/${trait_type}/chr${chr}
            ## reference sample
            bfileRef=${output_dir}allchr${chr}
            bfileRefP=${output_dir}chr${chr}
            idxRef=${compStr}04_reference/01_idx.txt
            plink-1.9 --bfile ${bfileAll} --keep ${idxRef} --make-bed --out ${bfileRef}
            plink-1.9 --bfile ${bfileRef} --maf 0.01 --make-bed --out ${bfileRefP}
            ## remove files
            rm ${bfileRef}.log
            rm ${bfileRef}.bed
            rm ${bfileRef}.bim
            rm ${bfileRef}.fam
            rm ${bfileRefP}.log
        fi
    done
done

