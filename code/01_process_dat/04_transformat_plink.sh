#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=1-00:00:00
#SBATCH --job-name=toplink
#SBATCH --mem=10G
#SBATCH --cpus-per-task=5

#SBATCH --array=1-22
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/toplink_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/toplink_%a.err

let k=0

for chr in `seq 1 22`;do
    let k=${k}+1
    if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
        sample=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/ukb_all_info.sample
        brIdx1=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/brIdx1.txt
        brIdx2=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/brIdx2.txt
        bgen=/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_imp_chr${chr}_v2.bgen
        snpList=/net/mulan/disk2/yasheng/predictionProject/plink_file/removal_snp_list/chr${chr}.txt
        bfile1=/net/mulan/disk2/yasheng/predictionProject/plink_file/genotype/xchr${chr}
        bfile2=/net/mulan/disk2/yasheng/predictionProject/plink_file/genotype/chr${chr}
        ## change to plink file
        ${PLINK2} --bgen ${bgen} --sample ${sample} --keep ${brIdx1} --exclude ${snpList} --hwe 1e-7 \
                --hard-call-threshold 0.1 --geno 0.05 --make-bed --out ${bfile1}
        ## change the allele order
        plink-1.9 --bfile ${bfile1} --keep ${brIdx2} --make-bed --out ${bfile2}
        #rm ${bfile1}.bed
        #rm ${bfile1}.fam
        #rm ${bfile1}.bim
    fi
done

