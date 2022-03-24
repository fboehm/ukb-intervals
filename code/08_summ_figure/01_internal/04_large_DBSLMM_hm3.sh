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
for p in `seq 1 25`; do
for cross in 1 2 3 4 5; do

type=2
comp_str=/net/mulan/disk2/yasheng/comparisonProject/
bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/hm3/chr${chr}
idx=/net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_test_idx_c/idx_pheno${p}_cross${cross}.txt

if [ ${type} -eq 1 ]
then
DBSLMM_str=${comp_str}05_internal_c/pheno${p}/DBSLMM/
else
DBSLMM_str=${comp_str}06_internal_b/pheno${p}/DBSLMM/
fi

summ=${DBSLMM_str}summary_hm3_cross${cross}_chr${chr}_best.dbslmm.txt
lsumm=${DBSLMM_str}l_summary_hm3_cross${cross}_chr${chr}_best.dbslmm.txt
zcat ${summ}.gz | grep "1$" > ${lsumm}
lpreddbslmmt=${DBSLMM_str}l_pred_best_hm3_cross${cross}_chr${chr}
plink-1.9 --silent --bfile ${bfile} --score ${lsumm} 1 2 4 sum --keep ${idx} --out ${lpreddbslmmt}
gzip -f ${lpreddbslmmt}.profile

rm ${lsumm}
rm ${lpreddbslmmt}.log
rm ${lpreddbslmmt}.nopred
done
done

} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0
