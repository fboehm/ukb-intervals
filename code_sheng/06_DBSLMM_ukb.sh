#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=4-00:00:00
#SBATCH --job-name=DBSLMM
#SBATCH --mem=16G
#SBATCH --cpus-per-task=5
#SBATCH --array=1-250%80
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/06_DBSLMM_ukb_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/06_DBSLMM_ukb_%a.err

let k=0
let thread=5

dats=(continuous binary)
type=t

fbstr=~/research/ukb-intervals/
compstr=/net/mulan/disk2/yasheng/comparisonProject/
plink=/usr/cluster/bin/plink-1.9
#DBSLMM=${compstr}code/02_method/06_DBSLMM_script.sh
DBSLMM=06_DBSLMM_script.sh
DBSLMMpath=/net/mulan/home/yasheng/predictionProject/code/
blockf=${compstr}LDblock_EUR/chr
ref=${compstr}04_reference/ukb/geno/chr

for dat in ${dats[@]}; do
for p in `seq 1 25`; do
for cross in 1 2 3 4 5; do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

# validation set genotypes, ie, plink file
#val=${compstr}03_subsample/${dat}/pheno${p}/val/ukb/impute_inter/chr
val=${fbstr}03_subsample/${dat}/pheno${p}/val/ukb/geno/chr

if [[ "$dat" == "continuous" ]]
then
# phenoVal=${compstr}03_subsample/${dat}/pheno${p}/02_pheno_c.txt
phenoVal=${fbstr}/03_subsample/${dat}/pheno${p}/val/ukb/02_pheno_c.txt
index=r2
else
phenoVal=${fbstr}03_subsample/${dat}/pheno${p}/val/ukb/02_pheno_b.txt
index=auc
fi

## input
if [[ "$dat" == "continuous" ]]
then
herit=${compstr}05_internal_c/pheno${p}/herit/h2_ukb_cross${cross}.log
summ=${compstr}05_internal_c/pheno${p}/output/summary_ukb_cross${cross}_chr
outPath=${fbstr}/05_internal_c/pheno${p}/DBSLMM/
else
herit=${fbstr}06_internal_b/pheno${p}/herit/h2_ukb_cross${cross}.log
summ=${fbstr}06_internal_b/pheno${p}/output/summary_ukb_cross${cross}_chr
outPath=${fbstr}/06_internal_b/pheno${p}/DBSLMM/
# covariates for validation set
cov=${fbstr}03_subsample/${dat}/pheno${p}/val/ukb/03_cov_eff.txt
fi

mkdir -p ${outPath}
## DBSLMM
# esttime=${compstr}01_time_file/06_DBSLMM_hm3_${dat}_pheno${p}_cross${cross}_thread${thread}.tm
if [[ "$dat" == "continuous" ]]
then
# time /usr/bin/time -v -o ${esttime} 
sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ} -m DBSLMM\
             -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
             -l 1 -T ${type} -i ${index} -t ${thread} -o ${outPath} #-C ${chr} -f ${h2f} -h ${pth}
else 
# time /usr/bin/time -v -o ${esttime} 
sh ${DBSLMM} -D ${DBSLMMpath} -p ${plink} -B ${blockf} -s ${summ}  -m DBSLMM\
             -H ${herit} -G ${val} -R ${ref} -P ${phenoVal}\
             -l 1 -T ${type} -c ${cov} -i ${index} -t ${thread} -o ${outPath} #-C ${chr} -f ${h2f} -h ${pth}
fi


# for chr in `seq 1 22`
# do 
# gzip ${summ}${chr}.assoc.txt
# done

fi
done
done
done


