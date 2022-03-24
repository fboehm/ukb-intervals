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
qctool=/net/mulan/home/yasheng/comparisonProject/program/qctool_v2.0.6-Ubuntu16.04-x86_64/qctool
bgen=/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_imp_chr${chr}_v2
subbgen=/net/mulan/home/yasheng/predictionProject/plink_file/rare/chr${chr}
raresnp=/net/mulan/disk2/yasheng/predictionProject/plink_file/rare_snp_list/chr${chr}.txt
brIdx2=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/rareIdx.txt
sample=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/ukb_all_info.sample
# ${qctool} -g ${bgen}.bgen -s ${sample} -og ${subbgen}.bgen -incl-rsids ${raresnp} -incl-samples ${brIdx2}
subbgen=/net/mulan/home/yasheng/predictionProject/plink_file/rare/chr${chr}
bedfile=/net/mulan/home/yasheng/predictionProject/plink_file/rare/chr${chr}
subIdx=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/ukb_sub_info1.sample
sample_list=/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/sample_list.txt
plink2 --silent --bgen ${subbgen}.bgen ref-first --sample ${subIdx} --keep ${sample_list} \
--make-bed --rm-dup force-first --out ${bedfile}

} &
pid=$!
echo $pid
done
wait
exec 6>&-

exit 0