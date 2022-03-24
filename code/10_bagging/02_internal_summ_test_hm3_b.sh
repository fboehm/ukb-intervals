#!/bin/bash

SEND_THREAD_NUM=25
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

bagging=/net/mulan/disk2/yasheng/comparisonProject/code/10_bagging/02_internal_summ_test_hm3_b.R
for p in `seq 1 25`;do
read -u6
{
Rscript ${bagging} --pheno ${p}
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0
