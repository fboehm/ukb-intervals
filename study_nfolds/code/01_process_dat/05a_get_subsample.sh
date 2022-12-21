#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=10:00:00
#SBATCH --job-name=subset
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-3300%300
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/05a_subsample_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/05a_subsample_%a.err

olddir=~/research/ukb-intervals/
trait_types=(binary continuous)
nfolds=(5 10 20)

let k=0

for nfold in ${nfolds[@]}; do
    compStr=~/research/ukb-intervals/study_nfolds/${nfold}-fold/
    for trait_type in ${trait_types[@]}; do
        for chr in `seq 1 22`;do
            for p in `seq 1 25`; do
                let k=${k}+1
                if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
                    bfileAll=${olddir}plink_file/ukb/${trait_type}/chr${chr}
                    ## validation sample
                    mydir=${compStr}03_subsample/${trait_type}/pheno${p}/val/
                    bfileSub=${mydir}ukb/geno/allchr${chr}
                    bfileSubP=${mydir}ukb/geno/chr${chr}
                    mkdir -p ${mydir}ukb/geno
                    idxSub=${mydir}01_idx.txt
                    plink-1.9 --silent --bfile ${bfileAll} --keep ${idxSub} --make-bed --out ${bfileSub}
                    plink-1.9 --silent --bfile ${bfileSub} --maf 0.01 --make-bed --out ${bfileSubP}
                    rm ${bfileSub}.log
                    rm ${bfileSub}.bed
                    rm ${bfileSub}.bim
                    rm ${bfileSub}.fam
                    rm ${bfileSubP}.log
                    # impute
                    geno_impute=05_geno_imputation.R
                    input=${bfileSubP}
                    output=${mydir}impute/chr${chr}
                    mkdir -p ${mydir}impute
                    Rscript ${geno_impute} --plinkin ${input} --plinkout ${output}
                fi
            done
        done
    done
done