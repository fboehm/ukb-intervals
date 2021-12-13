#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=4:00:00
#SBATCH --job-name=DBSLMM
#SBATCH --mem=10G
#SBATCH --cpus-per-task=22
#SBATCH --array=1
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/partition-subjects_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/partition-subjects_%a.err
#SBATCH --mail-user=fredboe@umich.edu  
#SBATCH --mail-type=ALL


bash 

## GOAL: Create new plink files for test and training sets.

#compStr=/net/mulan/disk2/yasheng/comparisonProject/

# ukb subsample
SEND_THREAD_NUM=22
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

for chr in `seq 1 22`;do
read -u6
{

## subsample
bfileAll=~/research/ukb-intervals/dat/plink_files/ukb/chr${chr}
bfileSub=~/research/ukb-intervals/dat/subsetted_plink_files/allchr${chr}
bfileSubP=~/research/ukb-intervals/dat/subsetted_plink_files/test-chr${chr}
idxSub=~/research/ukb-intervals/dat/test-subjects-ids.txt
plink-1.9 --bfile ${bfileAll} --keep-fam ${idxSub} --make-bed --out ${bfileSub}
plink-1.9 --bfile ${bfileSub} --maf 0.01 --make-bed --out ${bfileSubP}
#rm ${bfileSub}.log
rm ${bfileSub}.bed
rm ${bfileSub}.bim
rm ${bfileSub}.fam
#rm ${bfileSubP}.log
bfileAll=~/research/ukb-intervals/dat/plink_files/ukb/chr${chr}
bfileSub=~/research/ukb-intervals/dat/subsetted_plink_files/allchr${chr}
bfileSubP=~/research/ukb-intervals/dat/subsetted_plink_files/training-chr${chr}
idxSub=~/research/ukb-intervals/dat/test-subjects-ids.txt
plink-1.9 --bfile ${bfileAll} --remove-fam ${idxSub} --make-bed --out ${bfileSub}
plink-1.9 --bfile ${bfileSub} --maf 0.01 --make-bed --out ${bfileSubP}
#rm ${bfileSub}.log
rm ${bfileSub}.bed
rm ${bfileSub}.bim
rm ${bfileSub}.fam
#rm ${bfileSubP}.log



} &
pid=$!
echo $pid
done

wait

exec 6>&-

