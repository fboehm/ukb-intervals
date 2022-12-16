#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=2-00:00:00
#SBATCH --job-name=toa
#SBATCH --mem=10G
#SBATCH --cpus-per-task=5
#SBATCH --array=4
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/toa_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/toa_%a.err


path=~/research/ukb-intervals/
let k=3


#for chr in `seq 4 6`;do
let chr=4
    let k=${k}+1
    if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
        sample=${path}plink_file/pheno_list/ukb_all_info.sample
        brIdx1=${path}plink_file/pheno_list/brIdx1.txt
        brIdx2=${path}plink_file/pheno_list/ukb_337129_ids.txt
        bgen=/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_imp_chr${chr}_v2.bgen
        snpList=${path}plink_file/removal_snp_list/chr${chr}.txt.gz
        bfile1=${path}plink_file/ukb/binary/xchr${chr}
        bfile2=${path}plink_file/ukb/binary/chr${chr}
        ## change to plink file
        plink2 --bgen ${bgen} ref-first --sample ${sample} --keep ${brIdx1} --exclude ${snpList} --hwe 1e-7 \
                --hard-call-threshold 0.1 --geno 0.05 --make-bed --out ${bfile1}
        ## change the allele order
        plink-1.9 --bfile ${bfile1} --keep ${brIdx2} --make-bed --out ${bfile2}
        rm ${bfile1}.bed
        rm ${bfile1}.fam
        rm ${bfile1}.bim
    fi
#done

