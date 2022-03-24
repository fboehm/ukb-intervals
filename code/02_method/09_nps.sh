#!/bin/bash

#SBATCH --partition=nomosix
#SBATCH --time=3-00:00:00
#SBATCH --job-name=nps_c
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-50
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/09_nps_c3_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/09_nps_c3_%a.err

bash
let k=0

thread=1
compStr=/net/mulan/disk2/yasheng/comparisonProject/
compStr2=/net/mulan/disk2/yasheng/comparisonProject/
valID=val
npsSumm=${compStr}code/02_method/09_nps_mk_summ.R
dat=c
windowsize=1000
w1=`echo "${windowsize}/4"|bc`
w2=`echo "${windowsize}/2"|bc`
w3=`echo "${windowsize}/4*3"|bc`

for p in `seq 16 25`
do
for cross in `seq 1 5`
do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

## Configure an NPS run
if [[ "$dat" == "c" ]]
then
summstats=${compStr}05_internal_c/pheno${p}/output/summary_hm3_cross${cross}
snpinfo=${compStr2}03_subsample/continuous/pheno${p}/val/hm3/dosage/merge.${valID}.snpinfo
outpath=${compStr2}05_internal_c/pheno${p}/nps/tmp${cross}
valpath=${compStr2}03_subsample/continuous/pheno${p}/val/hm3/dosage
else
summstats=${compStr}06_internal_b/pheno${p}/output/summary_hm3_cross${cross}
snpinfo=${compStr2}03_subsample/binary/pheno${p}/val/dosage/merge.${valID}.snpinfo
outpath=${compStr2}06_internal_b/pheno${p}/nps/tmp${cross}
valpath=${compStr2}03_subsample/binary/pheno${p}/val/dosage
fi
nps_script=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/09_nps_script.sh
esttime=${compStr}01_time_file/09_nps_hm3_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
time /usr/bin/time -v -o ${esttime} sh ${nps_script} ${summstats} ${valpath} ${valID} ${windowsize} ${outpath} 1 ${w1} ${w2} ${w3} ${snpinfo}


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
done
