#!/bin/bash

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
ldsc=/usr/cluster/ldsc/ldsc.py
#cd ~/ldsc
#source activate ldsc

${ldsc} --out ~/research/ukb-intervals/dat/04_reference/ukb/ldsc/${chr} \
		--bfile ~/research/ukb-intervals/dat/03_subsample/ukb/geno/chr${chr} \
		--l2  --ld-wind-kb 1000.0 
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0