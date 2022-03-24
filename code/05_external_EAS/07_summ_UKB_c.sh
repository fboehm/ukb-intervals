#!/bin/bash

SEND_THREAD_NUM=24
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

summRes=/net/mulan/disk2/yasheng/comparisonProject/code/05_external_EAS/07_summ_UKB_c.R


for iter in `seq 14 37`; do
read -u6
{
Rscript ${summRes} --iter ${iter} 

} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0