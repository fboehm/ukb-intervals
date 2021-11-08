#!/bin/bash
compStr=/net/mulan/disk2/yasheng/comparisonProject/

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
bfileSub=~/research/ukb-intervals/dat/03_subsample/ukb/geno/allchr${chr}
bfileSubP=~/research/ukb-intervals/dat/03_subsample/ukb/geno/chr${chr}
idxSub=~/research/ukb-intervals/dat/03_subsample/01_idx.txt
plink-1.9 --bfile ${bfileAll} --keep ${idxSub} --make-bed --out ${bfileSub}
plink-1.9 --bfile ${bfileSub} --maf 0.01 --make-bed --out ${bfileSubP}
#rm ${bfileSub}.log
rm ${bfileSub}.bed
rm ${bfileSub}.bim
rm ${bfileSub}.fam
#rm ${bfileSubP}.log

## reference sample
bfileRef=~/research/ukb-intervals/dat/04_reference/ukb/geno/allchr${chr}
bfileRefP=~/research/ukb-intervals/dat/04_reference/ukb/geno/chr${chr}
idxRef=~/research/ukb-intervals/dat/04_reference/01_idx.txt
plink-1.9 --bfile ${bfileSubP} --keep ${idxRef} --make-bed --out ${bfileRef}
plink-1.9 --bfile ${bfileRef} --maf 0.01 --make-bed --out ${bfileRefP}

## remove files
rm ${bfileRef}.log
rm ${bfileRef}.bed
rm ${bfileRef}.bim
rm ${bfileRef}.fam
rm ${bfileRefP}.log

} &
pid=$!
echo $pid
done

wait

exec 6>&-

