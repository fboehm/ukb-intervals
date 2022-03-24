####
#
cd /net/mulan/disk2/yasheng/predictionProject/plink_file/EAS/hm3/
# plink-1.9 --bfile chr1 --make-bed --merge-list merge_list.txt --out merge
#
dat=binary
gcta=/net/mulan/home/yasheng/comparisonProject/program/gcta_1.93.1beta/gcta64
${gcta} --bfile merge --autosome --maf 0.01 --make-grm --out merge_${dat} --thread-num 10

###########################################
#!/bin/bash
SEND_THREAD_NUM=25
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

for iter in `seq 13 37`;do
read -u6
{
compstr=/net/mulan/disk2/yasheng/comparisonProject/

gcta=/net/mulan/home/yasheng/comparisonProject/program/gcta_1.93.1beta/gcta64
# dat=continuous

pheno=${compstr}code/05_external_EAS/pheno.txt
# dat=${compstr}code/05_external_EAS/dat.txt
p=`tail -n+${iter} ${pheno} | head -1`
# d=`tail -n+${iter} ${dat} | head -1`

grm=/net/mulan/disk2/yasheng/predictionProject/plink_file/EAS/hm3/merge_${dat}
pheno_dat=${compstr}02_pheno/07_pheno_EAS/${dat}/pheno${p}.txt
herit_out=${compstr}07_external_c/03_EAS/herit/pheno${p}_hm3_${dat}
${gcta} --grm ${grm} --pheno ${pheno_dat} --reml --out ${herit_out} --thread-num 10

} &
pid=$!
echo $pid
done

wait

exec 6>&-

# exit 0
