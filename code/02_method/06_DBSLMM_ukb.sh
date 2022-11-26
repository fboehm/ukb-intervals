#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=3-00:00:00
#SBATCH --job-name=DBSLMM
#SBATCH --mem=12G
#SBATCH --cpus-per-task=5
#SBATCH --array=1-10
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/06_DBSLMM_ukb_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/06_DBSLMM_ukb_%a.err

bash 
let k=0
let thread=${SLURM_CPUS_PER_TASK}

dats=( continuous binary )
type=t
fbstr=~/research/ukb-intervals/
compstr=/net/mulan/disk2/yasheng/comparisonProject/
plink=/usr/cluster/bin/plink-1.9
DBSLMM=06_DBSLMM_script.sh
DBSLMMpath=/net/mulan/home/yasheng/predictionProject/code/
blockf=${compstr}LDblock_EUR/chr


for dat in ${dats[@]}; do
    ref=${fbstr}04_reference/ukb/${dat}/geno/chr
    #for p in `seq 1 25`; do
    for p in 1; do
        for cross in `seq 1 5`; do
            let k=${k}+1
            if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
                val=${fbstr}03_subsample/${dat}/pheno${p}/val/ukb/geno/chr
                if [[ "$dat" == "continuous" ]]; then
                    phenoVal=${fbstr}/03_subsample/${dat}/pheno${p}/val/ukb/02_pheno_c.txt
                    index=r2
                else
                    phenoVal=${fbstr}03_subsample/${dat}/pheno${p}/val/ukb/02_pheno_b.txt
                    index=auc
                fi
                ## input
                if [[ "$dat" == "continuous" ]]; then
                    herit=${fbstr}05_internal_c/pheno${p}/herit/h2_ukb_cross${cross}.log
                    summ=${fbstr}05_internal_c/pheno${p}/output/summary_ukb_cross${cross}_chr
                    outPath=${fbstr}05_internal_c/pheno${p}/DBSLMM/
                else
                    herit=${fbstr}06_internal_b/pheno${p}/herit/h2_ukb_cross${cross}.log
                    summ=${fbstr}06_internal_b/pheno${p}/output/summary_ukb_cross${cross}_chr
                    outPath=${fbstr}06_internal_b/pheno${p}/DBSLMM/
                    cov=${fbstr}03_subsample/${dat}/pheno${p}/val/ukb/03_cov_eff.txt
                fi
                mkdir -p ${outPath}

                ## DBSLMM
                esttime=~/research/ukb-intervals/cluster_outputs/06_DBSLMM_ukb_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
                if [[ "$dat" == "continuous" ]]; then
                    time /usr/bin/time -v -o ${esttime} sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ} -m DBSLMM\
                                -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
                                -l 1 -T ${type} -i ${index} -t ${thread} -o ${outPath}              
                else 
                    time /usr/bin/time -v -o ${esttime} sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ}  -m DBSLMM\
                                -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
                                -l 1 -T ${type} -c ${cov} -i ${index} -t ${thread} -o ${outPath} 
                fi
            fi
        done
    done
done


