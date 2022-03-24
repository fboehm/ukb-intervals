#!/bin/bash

SEND_THREAD_NUM=24
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

val=/net/mulan/disk2/yasheng/comparisonProject/code/03_internal/11_summ_res_hm3_rare_b.R

for p in `seq 2 25`;do
read -u6
{
Rscript ${val} --pheno ${p}
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0

