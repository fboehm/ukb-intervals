#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=5-00:00:00
#SBATCH --job-name=nps_m2
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-69
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/09_nps_miss2_c_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/09_nps_miss2_c_%a.err

bash
let k=0

thread=1
compStr=/net/mulan/disk2/yasheng/comparisonProject/
valID=val
npsSumm=${compStr}code/02_method/09_nps_mk_summ.R
dat=b
windowsize=4000
w1=`echo "${windowsize}/4"|bc`
w2=`echo "${windowsize}/2"|bc`
w3=`echo "${windowsize}/4*3"|bc`


phenoMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/nps_miss_c/pheno.txt
crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/nps_miss_c/cross.txt
stepMisss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/nps_miss_c/step.txt
chrMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/nps_miss_c/chr.txt

for iter in `seq 1 69`
do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

p=`head -n ${iter} ${phenoMiss} | tail -n 1`
cross=`head -n ${iter} ${crossMiss} | tail -n 1`
st=`head -n ${iter} ${stepMisss} | tail -n 1`
chr=`head -n ${iter} ${chrMiss} | tail -n 1`

## Configure an NPS run
if [[ "$dat" == "c" ]]
then
summstats=${compStr}05_internal_c/pheno${p}/output/summary_hm3_cross${cross}
snpinfo=${compStr}03_subsample/continuous/pheno${p}/val/dosage/merge.${valID}.snpinfo
outpath=${compStr}05_internal_c/pheno${p}/nps/tmp${cross}
valpath=${compStr}03_subsample/continuous/pheno${p}/val/dosage
else
summstats=${compStr}06_internal_b/pheno${p}/output/summary_hm3_cross${cross}
snpinfo=${compStr}03_subsample/binary/pheno${p}/val/dosage/merge.${valID}.snpinfo
outpath=${compStr}06_internal_b/pheno${p}/nps/tmp${cross}
valpath=${compStr}03_subsample/binary/pheno${p}/val/dosage
fi
nps_script=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/09_nps_script_r.sh
# esttime=${compStr}01_time_file/09_nps_hm3_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
# time /usr/bin/time -v -o ${esttime} 
sh ${nps_script} ${summstats} ${valpath} ${valID} ${windowsize} ${outpath} 1 ${w1} ${w2} ${w3} ${snpinfo} ${chr} ${st}


## validate
# ./run_all_chroms.sh sge/nps_score.dosage.job ${outpath} ${valpath} ${valID} 0
# ./run_all_chroms.sh sge/nps_score.dosage.job ${outpath} ${valpath} ${valID} ${w1}
# ./run_all_chroms.sh sge/nps_score.dosage.job ${outpath} ${valpath} ${valID} ${w2}
# ./run_all_chroms.sh sge/nps_score.dosage.job ${outpath} ${valpath} ${valID} ${w3}

## sum the effect
# ss=`tail -n+${cross} ${nn} | head -1`
# Rscript npsR/nps_val.R --out ${outpath} --val ${valID} --n ${ss}

fi
done
