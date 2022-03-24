#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=3-00:00:00
#SBATCH --job-name=GC_EASb
#SBATCH --mem=6G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-50
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/GC_est_EASb_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/GC_est_EASb_%a.err

bash
let k=0
gemma=/net/mulan/home/yasheng/comparisonProject/program/gemma-0.98.1-linux-static
compstr=/net/mulan/disk2/yasheng/comparisonProject/
dat=binary
type=EAS

for p in `seq 1 25`
do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then

let col=${p}

bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/${type}/hm3/merge
summ=summary_${type}_pheno${p}

if [[ "$dat" == "continuous" ]]
then

echo continuous phenotype
cd ${compstr}07_external_c/03_EAS/herit/
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ}
rm ${compstr}07_external_c/03_EAS/herit/output/${summ}.log.txt

else

echo binary phenotype
if ((${p}==1 || ${p}==6 || ${p}==21))
then
cov=${compstr}02_pheno/07_pheno_EAS/binary/cov_EAS_nosex.txt
else
cov=${compstr}02_pheno/07_pheno_EAS/binary/cov_EAS.txt
fi
cd ${compstr}07_external_c/03_EAS/herit/
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ} -c ${cov}
rm ${compstr}07_external_c/03_EAS/herit/output/${summ}.log.txt

fi

GC_est=/net/mulan/disk2/yasheng/comparisonProject/code/05_external_EAS/GC_est.R
summ_GC=${compstr}07_external_c/03_EAS/herit/output/${summ}.assoc.txt
out_GC=${compstr}07_external_c/03_EAS/herit/pheno${p}_hm3_${dat}_GC.txt
Rscript ${GC_est} --summ ${summ_GC} --out ${out_GC}

if [ -f ${summ_GC} ]
then
rm -f ${summ_GC}
fi

fi

done

