#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=3-00:00:00
#SBATCH --job-name=DBSLMM
#SBATCH --mem=12G
#SBATCH --cpus-per-task=5
#SBATCH --array=1-1750%60
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/06_DBSLMM_ukb_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/06_DBSLMM_ukb_%a.err


let k=0
let thread=${SLURM_CPUS_PER_TASK}

trait_types=( continuous binary )
type=t # tuning version of DBSLMM
plink=/usr/cluster/bin/plink-1.9
DBSLMM=06_DBSLMM_script.sh
DBSLMMpath=/net/mulan/home/yasheng/predictionProject/code/
blockf=~/research/ukb-intervals/LDblock_EUR/chr
nfolds=(5 10 20)

for nfold in ${nfolds[@]}; do
    fbstr=~/research/ukb-intervals/study_nfolds/${nfold}-fold/
    for trait_type in ${trait_types[@]}; do
        ref=~/research/ukb-intervals/04_reference/ukb/${trait_type}/geno/chr
        for p in `seq 1 25`; do
            for cross in `seq 1 ${nfold}`; do
                let k=${k}+1
                if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
                    # specify plink file prefix, "val"
                    #val=~/research/ukb-intervals/03_subsample/${trait_type}/pheno${p}/val/ukb/geno/chr
                    val=${fbstr}03_subsample/${trait_type}/pheno${p}/val/hm3/geno/chr
                    if [[ "${trait_type}" == "continuous" ]]; then
                        phenoVal=${fbstr}03_subsample/${trait_type}/pheno${p}/val/02_pheno_c.txt
                        index=r2
                    else
                        phenoVal=${fbstr}03_subsample/${trait_type}/pheno${p}/val/02_pheno_b.txt
                        index=auc
                    fi
                    ## input
                    if [[ "${trait_type}" == "continuous" ]]; then
                        herit=${fbstr}05_internal_c/pheno${p}/herit/h2_ukb_cross${cross}.log
                        summ=${fbstr}05_internal_c/pheno${p}/output/summary_ukb_cross${cross}_chr
                        outPath=${fbstr}05_internal_c/pheno${p}/DBSLMM/
                    fi
                    if [[ "${trait_type}" == "binary" ]]; then 
                        herit=${fbstr}06_internal_b/pheno${p}/herit/h2_ukb_cross${cross}.log
                        summ=${fbstr}06_internal_b/pheno${p}/output/summary_ukb_cross${cross}_chr
                        outPath=${fbstr}06_internal_b/pheno${p}/DBSLMM/
                        cov=${fbstr}03_subsample/${trait_type}/pheno${p}/val/03_cov_eff.txt
                    fi
                    mkdir -p ${outPath}

                    ## DBSLMM
                    esttime=~/research/ukb-intervals/cluster_outputs/06_DBSLMM_ukb_${trait_type}_pheno${p}_cross${cross}_thread${thread}.tm
                    if [[ "${trait_type}" == "continuous" ]]; then
                        time /usr/bin/time -v -o ${esttime} sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ} -m DBSLMM\
                                    -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
                                    -l 1 -T ${type} -i ${index} -t ${thread} -o ${outPath}              
                    fi 
                    if [[ "${trait_type}" == "binary" ]]; then 
                        time /usr/bin/time -v -o ${esttime} sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ}  -m DBSLMM\
                                    -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
                                    -l 1 -T ${type} -c ${cov} -i ${index} -t ${thread} -o ${outPath} 
                    fi
                fi
            done
        done
    done
done


