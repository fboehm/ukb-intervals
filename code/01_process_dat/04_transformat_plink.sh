#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=1-00:00:00
#SBATCH --job-name=toplink
#SBATCH --mem=10G
#SBATCH --cpus-per-task=5

#SBATCH --array=1-21
#SBATCH --output=/net/mulan/disk2/yasheng/out/toplink_%a.out
#SBATCH --error=/net/mulan/disk2/yasheng/err/toplink_%a.err

bash
let k=0

PLINK2=/net/mulan/home/yasheng/comparisonProject/program/plink2
sample=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/ukb_all_info.sample
brIdx1=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/brIdx1.txt
brIdx2=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/brIdx2.txt
#chr=20
 for ((chr=1;chr<22;chr++));do
 let k=${k}+1
 if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
bgen=/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_imp_chr${chr}_v2.bgen
snpList=/net/mulan/disk2/yasheng/predictionProject/plink_file/removal_snp_list/chr${chr}.txt
bfile1=/net/mulan/disk2/yasheng/predictionProject/plink_file/genotype/xchr${chr}
bfile2=/net/mulan/disk2/yasheng/predictionProject/plink_file/genotype/chr${chr}
## change to plink file
${PLINK2} --bgen ${bgen} --sample ${sample} --keep ${brIdx1} --exclude ${snpList} --hwe 1e-7 \
          --hard-call-threshold 0.1 --geno 0.05 --make-bed --out ${bfile1}
## change the allele order
plink-1.9 --bfile ${bfile1} --keep ${brIdx2} --make-bed --out ${bfile2}
#rm ${bfile1}.bed
#rm ${bfile1}.fam
#rm ${bfile1}.bim
 fi
 done


SEND_THREAD_NUM=7
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

for chr in `seq 16 22`;do
read -u6
{
qctool=/net/mulan/home/yasheng/comparisonProject/program/qctool_v2.0.6-Ubuntu16.04-x86_64/qctool
bgen=/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_imp_chr${chr}_v2
subbgen=/net/mulan/home/yasheng/predictionProject/plink_file/rare/chr${chr}
raresnp=/net/mulan/disk2/yasheng/predictionProject/plink_file/rare_snp_list/chr${chr}.txt
brIdx2=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/rareIdx.txt
sample=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/ukb_all_info.sample
${qctool} -g ${bgen}.bgen -s ${sample} -og ${subbgen}.bgen -incl-rsids ${raresnp} -incl-samples ${brIdx2}
} &
pid=$!
echo $pid
done
wait
exec 6>&-
