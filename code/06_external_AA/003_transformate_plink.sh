
SEND_THREAD_NUM=21
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

qctool=/net/mulan/home/yasheng/comparisonProject/program/qctool_v2.0.6-Ubuntu16.04-x86_64/qctool
sample=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/ukb_all_info.sample
AFRidx=/net/mulan/disk2/yasheng/comparisonProject/02_pheno/08_pheno_AFR/idx_AFR1.txt
AFRsample=/net/mulan/disk2/yasheng/comparisonProject/02_pheno/08_pheno_AFR/ukb_AFR_info.sample
snplist=/net/mulan/disk2/yasheng/predictionProject/plink_file/snplist.txt

for chr in `seq 1 21`;do
read -u6
{
all=/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_imp_chr${chr}_v2
sub=/net/mulan/disk2/yasheng/predictionProject/plink_file/AA/hm3/chr${chr}
${qctool} -g ${all}.bgen -s ${sample} -og ${sub}.bgen -incl-rsids ${snplist} -incl-samples ${AFRidx}
plink2 --bgen ${sub}.bgen ref-first --sample ${AFRsample} \
--rm-dup force-first --make-bed --out ${sub} --silent --maf 0.01 --hwe 1e-7
rm ${sub}.log
} &
pid=$!
echo $pid
done
wait

exec 6>&-


cd /net/mulan/disk2/yasheng/predictionProject/plink_file/AA/hm3
plink-1.9 --bfile chr1 --merge-list merge_list.txt --make-bed --out merge


SEND_THREAD_NUM=21
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

for chr in `seq 1 21`;do
read -u6
{
AFRidx=/net/mulan/disk2/yasheng/comparisonProject/02_pheno/08_pheno_AFR/idx_AFR2.txt
sub1=/net/mulan/disk2/yasheng/predictionProject/plink_file/AA/hm3/chr${chr}
sub2=/net/mulan/disk2/yasheng/predictionProject/plink_file/AA/hm3/sub_chr${chr}
plink-1.9 --bfile ${sub1} --keep ${AFRidx} --make-bed --out ${sub2}
rm ${sub2}.log
} &
pid=$!
echo $pid
done
wait

exec 6>&-