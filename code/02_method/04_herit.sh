#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=20:00:00
#SBATCH --job-name=herit
#SBATCH --mem-per-cpu=10G
#SBATCH --array=1-1750%50
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/04_herit_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/04_herit_%a.err


trait_types=(binary_adj continuous)
compStr=~/research/ukb-intervals/
nfolds=(5 10 20)

let k=0

#ldsc=/usr/cluster/ldsc/ldsc.py
ldsc=~/ldsc/ldsc.py
mkldsc=${compStr}code/02_method/04_mk_ldsc_summ.R

for nfold in ${nfolds[@]}; do
    fbstr=~/research/ukb-intervals/study_nfolds/${nfold}-fold/
    for trait_type in ${trait_types[@]}; do
        for p in `seq 1 25`; do
            for cross in `seq 1 ${nfold}`; do
                let k=${k}+1
                if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
                    ref=${compStr}04_reference/ukb/${trait_type}/ldsc/
                    if [[ "${trait_type}" == "continuous" ]]; then
                        summ=${fbstr}05_internal_c/pheno${p}/output/summary_ukb_cross${cross}
                        h2path=${fbstr}05_internal_c/pheno${p}/herit/
                        h2=${h2path}h2_ukb_cross${cross}
                    fi
                    if [[ "${trait_type}" == "binary_adj" ]]; then
                        summ=${fbstr}06_internal_b/pheno${p}/output/summary_ukb_cross${cross}
                        h2path=${fbstr}06_internal_b/pheno${p}/herit/
                        h2=${h2path}h2_ukb_cross${cross}
                    fi
                    mkdir -p ${h2path}
                    ## summary data for ldsc
                    cat ${summ}_chr*.assoc.txt > ${summ}.assoc.txt
                    sed -i '/chr/d' ${summ}.assoc.txt
                    Rscript ${mkldsc} --summgemma ${summ}.assoc.txt --summldsc ${summ}.ldsc
                    ## heritability
                    conda activate ldsc2
                    python2 ${ldsc} --h2 ${summ}.ldsc.gz --ref-ld-chr ${ref} --w-ld-chr ${ref} --out ${h2}
                    rm ${summ}.ldsc.gz
                fi
            done
        done
    done
done