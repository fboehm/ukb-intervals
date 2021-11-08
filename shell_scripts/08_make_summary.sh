#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=1-00:00:00
#SBATCH --job-name=mksum
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-110%50
#SBATCH --output=~/research/ukb-intervals/cluster_outputs/08_make_summary_%a.out
#SBATCH --error=~/research/ukb-intervals/cluster_outputs/08_make_summary_%a.err
#SBATCH --mail-type=ARRAY_TASKS,ALL
#SBATCH --mail-user=fredboe@umich.edu  


bash
let k=0
gemma=/net/mulan/home/yasheng/comparisonProject/program/gemma-0.98.1-linux-static
#compstr=/net/mulan/disk2/yasheng/comparisonProject/
compstr=~/research/ukb-intervals/dat/
dat=1
type=ukb



#for p in 9
for p in `seq 1 25`
do
for cross in 1 2 3 4 5
do
for chr in `seq 1 22`
do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]
then
let col=(${p}-1)*5+${cross}

#bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/${type}/chr${chr}

bfile=~/research/ukb-intervals/dat/plink_files/${type}/chr${chr}
summ=summary_${type}_cross${cross}_chr${chr}

if [ ${dat} -eq 1 ]
then

echo continuous phenotype
#cd ~/research/ukb-intervals/dat/05_internal_c/pheno${p}
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ}
#sed -i '1d' ${compstr}05_internal_c/pheno${p}/output/${summ}.assoc.txt
sed -i '1d' ~/research/ukb-intervals/dat/05_internal_c/pheno${p}/${summ}.assoc.txt
#rm ${compstr}05_internal_c/pheno${p}/output/${summ}.log.txt

else

echo binary phenotype
if ((${p}==1 || ${p}==6 || ${p}==21))
then
cov=${compstr}02_pheno/08_cov_nosex.txt
else
cov=${compstr}02_pheno/07_cov.txt
fi
cd ${compstr}06_internal_b/pheno${p}
${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ} -c ${cov}
sed -i '1d' ${compstr}06_internal_b/pheno${p}/output/${summ}.assoc.txt
rm ${compstr}06_internal_b/pheno${p}/output/${summ}.log.txt

fi

fi

done
done
done

