#!/bin/bash

# download 1000 GP index of EAS
cd /net/mulan/disk2/yasheng/comparisonProject/09_external_LD
wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel
grep EAS integrated_call_samples_v3.20130502.ALL.panel | cut -f1 > EAS_id.txt

SEND_THREAD_NUM=21
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

mkLD=/net/mulan/disk2/yasheng/comparisonProject/code/06_external_AA/07_mk_LD.R

for chr in `seq 1 21`;do
read -u6
{
VCFFILE=/net/fantasia/home/xzhousph/data/SummaryData/1000GP_Phase3/raw/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
OUTFILE1=/net/mulan/disk2/yasheng/comparisonProject/09_external_LD/1000GP/chr${chr}
# plink-1.9 --vcf ${VCFFILE} --double-id --make-bed --keep-allele-order --out ${OUTFILE1}
# rm ${OUTFILE1}.log
# rm ${OUTFILE1}.nosex

IDFILE=/net/mulan/disk2/yasheng/comparisonProject/09_external_LD/AFR_id.txt
SNPFILE=/net/mulan/disk2/yasheng/predictionProject/plink_file/snplist.txt
OUTFILE2=/net/mulan/disk2/yasheng/comparisonProject/09_external_LD/AA/geno/chr${chr}
plink-1.9 --bfile ${OUTFILE1} --extract ${SNPFILE} --keep ${IDFILE} --maf 0.01 --hwe 0.001 --geno 0 --make-bed --out ${OUTFILE2}
rm ${OUTFILE2}.log
rm ${OUTFILE2}.nosex

Rscript ${mkLD} --chr ${chr}
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0