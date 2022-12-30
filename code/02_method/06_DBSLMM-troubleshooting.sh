#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=1-00:00:00
#SBATCH --job-name=DBSLMM
#SBATCH --mem=12G
#SBATCH --cpus-per-task=5
#SBATCH --array=1
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/06_DBSLMM_ukb_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/06_DBSLMM_ukb_%a.err


type=t # tuning version of DBSLMM
plink=/usr/cluster/bin/plink-1.9
DBSLMM=06_DBSLMM_script.sh
DBSLMMpath=/net/mulan/home/yasheng/predictionProject/code/
blockf=~/research/ukb-intervals/LDblock_EUR/chr

let thread=${SLURM_CPUS_PER_TASK}

let nfold=5
fbstr=~/research/ukb-intervals/study_nfolds/${nfold}-fold/
trait_type=continuous
ref=~/research/ukb-intervals/04_reference/hm3/${trait_type}/geno/chr
let p=1
let cross=1
# specify plink file prefix, "val"
val=~/research/ukb-intervals/03_subsample/${trait_type}/pheno${p}/val/hm3/geno/chr
phenoVal=${fbstr}03_subsample/${trait_type}/pheno${p}/val/02_pheno_c.txt
if [ ! -f ${phenoVal} ]; then
    echo "phenoVal file missing"
fi
index=r2
## input
herit=${fbstr}05_internal_c/pheno${p}/herit/h2_ukb_cross${cross}.log
summ=${fbstr}05_internal_c/pheno${p}/output/summary_ukb_cross${cross}_chr
if [ ! -f ${herit} ]; then  
    echo "herit file missing"
fi

outPath=${fbstr}05_internal_c/pheno${p}/DBSLMM/
mkdir -p ${outPath}

## DBSLMM
sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ} -m DBSLMM\
            -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
            -l 1 -T ${type} -i ${index} -t ${thread} -o ${outPath}              
