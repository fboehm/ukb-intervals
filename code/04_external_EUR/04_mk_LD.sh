#!/bin/bash

SEND_THREAD_NUM=19
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

mkLD=/net/mulan/disk2/yasheng/comparisonProject/code/04_external/13_mk_LD.R

for chr in `seq 3 21`;do
read -u6
{
Rscript ${mkLD} --chr ${chr}
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0