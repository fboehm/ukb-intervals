#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=1:00:00
#SBATCH --job-name=cvplus
#SBATCH --mem=16G
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/rmd1all_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/rmd1all_%a.err
#SBATCH --array=1




let k=0
dats=(continuous binary)
nfolds=(5 10 20)
for nfold in ${nfolds[@]}; do 
    for dat in ${dats[@]}; do
        let k=${k}+1
        if [[ "${dat}" == "continuous" ]]; then
            output_dir=~/research/ukb-intervals/study_nfolds/${nfold}-fold/05_internal_c/pheno25/cvplus/
        else 
            output_dir=~/research/ukb-intervals/study_nfolds/${nfold}-fold/06_internal_b/pheno25/cvplus/
        fi
        
        #if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
            echo "output directory is ${output_dir}"
            R -e 'source("~/research/ukb-intervals/study_nfolds/code/02_method/call_Rmarkdown2.R")' \
                --args ${dat} ${nfold} ${output_dir}
        #fi
    done
done
