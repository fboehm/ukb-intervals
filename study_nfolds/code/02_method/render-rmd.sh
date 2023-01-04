#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=10:00:00
#SBATCH --job-name=cvplus
#SBATCH --mem=4G
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/render-rmd_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/render-rmd_%a.err
#SBATCH --array=1-150




let k=0
dats=(continuous binary)
nfolds=(5 10 20)
for nfold in ${nfolds[@]}; do 
    for dat in ${dats[@]}; do
        for p in `seq 1 25`; do
            let k=${k}+1
            if [ "${dat}"=="continuous" ]; then
                output_dir=~/research/ukb-intervals/study_nfolds/${nfold}-fold/05_internal_c/pheno${p}/cvplus/
            else 
                output_dir=~/research/ukb-intervals/study_nfolds/${nfold}-fold/06_internal_b/pheno${p}/cvplus/
            fi
            if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
                R -e 'source("~/research/ukb-intervals/study_nfolds/code/02_method/call_Rmarkdown.R")' \
                    --args ${dat} ${nfold} ${p} ${output_dir}
            fi
        done
    done
done
