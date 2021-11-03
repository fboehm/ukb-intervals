#!/bin/bash

SEND_THREAD_NUM=21
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

for chr in `seq 1 21`;do
read -u6
{
ldsc=/net/mulan/home/yasheng/comparisonProject/program/ldsc/ldsc.py
cd /net/mulan/home/yasheng/comparisonProject/program/ldsc
source activate ldsc

${ldsc} --out /net/mulan/disk2/yasheng/comparisonProject/03_subsample/ukb/ldsc/${chr} \
		--bfile /net/mulan/disk2/yasheng/comparisonProject/03_subsample/ukb/geno/chr${chr} \
		--l2  --ld-wind-kb 1000.0 
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0