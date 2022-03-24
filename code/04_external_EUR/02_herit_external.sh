#!/bin/bash
SEND_THREAD_NUM=28
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

compStr=/net/mulan/disk2/yasheng/comparisonProject/
ldsc=/net/mulan/home/yasheng/comparisonProject/program/ldsc/ldsc.py
refhm3=${compStr}04_reference/hm3/ldsc/
phenoCode=${compStr}code/04_external/pheno.txt
datCode=${compStr}code/04_external/dat.txt

for iter in `seq 1 28`
do
read -u6
{

p=`tail -n+${iter} ${phenoCode} | head -1`
dat=`tail -n+${iter} ${datCode} | head -1`

cd /net/mulan/home/yasheng/comparisonProject/program/ldsc
conda activate ldsc
summ=${compStr}07_external_c/02_EUR/02_clean/pheno${p}_data${dat}_herit
h2hm3=${compStr}07_external_c/02_EUR/03_res/pheno${p}_data${dat}/herit
python2 ${ldsc} --h2 ${summ}.ldsc.gz --ref-ld-chr ${refhm3} --w-ld-chr ${refhm3} --out ${h2hm3}

} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0

