#!/bin/bash

SEND_THREAD_NUM=9
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

for p in 4 5 6 13 14 17 20 21 25;do
read -u6
{
compstr=/net/mulan/disk2/yasheng/comparisonProject/
PRSCSSEL=/net/mulan/home/yasheng/comparisonProject/program/PRScs-master/selectPHI.R
dat=continuous
for cross in 3
do
if [[ "$dat" == "continuous" ]]
then
echo continuous
esteff=${compstr}05_internal_c/pheno${p}/PRScs/esteff_cross${cross}_chr
predfile=${compstr}05_internal_c/pheno${p}/PRScs/val_cross${cross}_chr
valgeno=${compstr}03_subsample/continuous/pheno${p}/val/impute_inter/chr
valpheno=${compstr}/03_subsample/continuous/pheno${p}/val/02_pheno_c.txt
# cov=${compstr}03_subsample/continuous/pheno${p}/val/03_cov_eff.txt
outfile=${compstr}05_internal_c/pheno${p}/PRScs/res_cross${cross}.txt
Rscript ${PRSCSSEL} --esteff ${esteff} --predfile ${predfile} --valgeno ${valgeno} \
                    --valpheno ${valpheno} --outfile ${outfile}
fi 
if [[ "$dat" == "binary" ]]
then
echo binary
esteff=${compstr}06_internal_b/pheno${p}/PRScs/esteff_cross${cross}_chr
predfile=/net/mulan/home/yasheng/comparisonProject/06_internal_b/pheno${p}/PRScs/val_cross${cross}_chr
valgeno=${compstr}03_subsample/binary/pheno${p}/val/impute_inter/chr
valpheno=${compstr}/03_subsample/binary/pheno${p}/val/02_pheno_b.txt
cov=${compstr}03_subsample/binary/pheno${p}/val/03_cov_eff.txt
outfile=${compstr}06_internal_b/pheno${p}/PRScs/res_cross${cross}.txt
Rscript ${PRSCSSEL} --esteff ${esteff} --predfile ${predfile} --valgeno ${valgeno} \
                    --valpheno ${valpheno} --cov ${cov} --outfile ${outfile}
fi 
done

} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0
