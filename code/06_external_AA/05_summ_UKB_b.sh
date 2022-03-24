#!/bin/bash

SEND_THREAD_NUM=25
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

summRes=/net/mulan/disk2/yasheng/comparisonProject/code/06_external_AA/05_summ_UKB_b.R


for p in `seq 1 25`; do
read -u6
{
Rscript ${summRes} --pheno ${p} 

} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0