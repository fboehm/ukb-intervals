#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=1-00:00:00
#SBATCH --job-name=to_plink
#SBATCH --mem=10G
#SBATCH --cpus-per-task=5
#SBATCH --mail-type=ARRAY_TASKS,ALL
#SBATCH --mail-user=fredboe@umich.edu  
#SBATCH --array=1-22

bash
let k=0

PLINK2=/net/mulan/home/yasheng/comparisonProject/program/plink2
sample=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/ukb_all_info.sample
brIdx1=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/brIdx1.txt
brIdx2=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/brIdx2.txt
#chr=20
for ((chr=1;chr<23;chr++));do
let k=${k}+1
if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
bgen=/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_imp_chr${chr}_v2.bgen
snpList=/net/mulan/disk2/yasheng/predictionProject/plink_file/removal_snp_list/chr${chr}.txt
bfile1=~/research/ukb-intervals/dat/plink_files/genotype/xchr${chr}
bfile2=~/research/ukb-intervals/dat/plink_files/genotype/chr${chr}
## change to plink file
${PLINK2} --bgen ${bgen} --sample ${sample} --keep ${brIdx1} --exclude ${snpList} --hwe 1e-7 \
          --hard-call-threshold 0.1 --geno 0.05 --make-bed --out ${bfile1}
## change the allele order
plink-1.9 --bfile ${bfile1} --keep ${brIdx2} --make-bed --out ${bfile2}
rm ${bfile1}.bed
rm ${bfile1}.fam
rm ${bfile1}.bim
 fi
 done

SEND_THREAD_NUM=21
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

for chr in `seq 1 22`;do
read -u6
{
bfile2=~/research/ukb-intervals/dat/plink_files/ukb/chr${chr}
bfile3=~/research/ukb-intervals/dat/plink_files/low/chr${chr}
plink-1.9 --bfile ${bfile2} --maf 0.001 --make-bed --out ${bfile3}
#rm ${bfile2}.log
#rm ${bfile3}.log
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0
