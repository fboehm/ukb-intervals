#!/bin/bash

# download 1000 GP index of EUR
cd /net/mulan/disk2/yasheng/comparisonProject/09_external_LD
grep EUR integrated_call_samples_v3.20130502.ALL.panel | cut -f1 > EUR_id.txt

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

mkLD=/net/mulan/disk2/yasheng/comparisonProject/code/04_external/02_mk_LD.R

for chr in `seq 1 22`;do
read -u6
{
VCFFILE=/net/fantasia/home/xzhousph/data/SummaryData/1000GP_Phase3/raw/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
OUTFILE1=/net/mulan/disk2/yasheng/comparisonProject/09_external_LD/1000GP/chr${chr}
plink-1.9 --vcf ${VCFFILE} --double-id --make-bed --keep-allele-order --out ${OUTFILE1}
rm ${OUTFILE1}.log
rm ${OUTFILE1}.nosex

IDFILE=/net/mulan/disk2/yasheng/comparisonProject/09_external_LD/EUR_id.txt
SNPFILE=/net/mulan/disk2/yasheng/predictionProject/plink_file/snplist.txt
OUTFILE2=/net/mulan/disk2/yasheng/comparisonProject/09_external_LD/EUR/geno/chr${chr}
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