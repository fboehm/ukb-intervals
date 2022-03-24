#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=24:00:00
#SBATCH --job-name=nps
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1

#SBATCH --array=1-24
#SBATCH --output=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/09_nps_dosage_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/comparisonProject/00_cluster_file/09_nps_dosage_%a.err

bash
let k=0

## Make dosage
dataID=val
qctool=/net/mulan/home/yasheng/comparisonProject/program/qctool_v2.0.6-Ubuntu16.04-x86_64/qctool
compstr=/net/mulan/disk2/yasheng/comparisonProject/
for p in `seq 2 25`
do

let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

for chr in `seq 1 22`
do 
bfile=${compstr}03_subsample/binary/pheno${p}/val/impute_inter/chr${chr}
selidx=${compstr}03_subsample/binary/pheno${p}/val/dosage/val_idx.txt
dosage=${compstr}03_subsample/binary/pheno${p}/val/dosage/chrom${chr}.${dataID}.dosage
plink-1.9 --silent --bfile ${bfile} --keep ${selidx} --recode vcf --out ${bfile}
${qctool} -g ${bfile}.vcf -filetype vcf -ofiletype dosage -og ${dosage}
gzip -f ${dosage}
rm ${bfile}.vcf
done

## Standardize genotypes
refpath=${compstr}03_subsample/binary/pheno${p}/val/dosage
cd /net/mulan/home/yasheng/comparisonProject/program/nps-master/
./run_all_chroms.sh sge/nps_stdgt.job ${refpath} ${dataID}
cd ${compstr}03_subsample/binary/pheno${p}/val/dosage/
cat chrom*.${dataID}.snpinfo > merge.${dataID}.snpinfo
sed -i '/alleleA/d' merge.${dataID}.snpinfo
sed -i '1i\chromosome\tSNPID\trsid\tposition\talleleA\talleleB' merge.${dataID}.snpinfo
fi
done

