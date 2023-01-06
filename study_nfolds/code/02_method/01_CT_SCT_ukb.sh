#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=6-00:00:00
#SBATCH --job-name=SCT_u
#SBATCH --mem=60G
#SBATCH --cpus-per-task=5
#SBATCH --array=1-
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/01_CT_ukb_b_thread5_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/01_CT_ukb_b_thread5_%a.err


let k=0

fbstr=~/research/ukb-intervals/study_nfolds/
CT=${fbstr}code/02_method/01_CT_SCT.R
ref=ukb
dat=continuous
thread=5
trait_types=( continuous binary )
nfolds=(5 10 20)

for nfold in ${nfolds[@]}; do
    foldstr=${fbstr}${nfold}-fold/
    for dat in ${trait_types[@]}; do
        for p in `seq 1 25`;do
            for cross in `seq 1 ${nfold}`; do
                let k=${k}+1
                if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

                    if [[ "$dat" == "continuous" ]]; then
                        echo continuous
                        summ=${foldstr}05_internal_c/pheno${p}/output/summary_ukb_cross${cross}
                        path=${foldstr}05_internal_c/pheno${p}/
                    else
                        echo binary
                        summ=${foldstr}06_internal_b/pheno${p}/output/summary_ukb_cross${cross}
                        path=${foldstr}06_internal_b/pheno${p}/
                    fi

                    # cat ${summ}_chr*.assoc.txt > ${summ}.assoc.txt
                    # sed -i '/chr/d' ${summ}.assoc.txt

                    #esttime=${compstr}01_time_file/01_SCT_CT_ukb_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
                    #time /usr/bin/time -v -o ${esttime} 
                    Rscript ${CT} --summ ${summ}.assoc.txt \
                    --path ${path} --pheno ${p} --cross ${cross} \
                    --reftype ${ref} --dat ${dat} --thread ${thread} \
                    

                    # rm ${path}CT/summary_cross${cross}.bk
                    # rm ${path}CT/summary_cross${cross}.rds

                fi
            done
        done
    done
done
