#!/bin/bash
# rare ref merge sample
SEND_THREAD_NUM=20
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

for chr in `seq 1 20`;do
read -u6
{
compStr=/net/mulan/disk2/yasheng/comparisonProject/
# subset rare files
bfileRare=/net/mulan/home/yasheng/predictionProject/plink_file/rare/chr${chr}
bfileSubRare=${compStr}04_reference/hm3_rare/geno/allchr${chr}
idxRef=${compStr}04_reference/01_idx.txt
plink-1.9 --silent --bfile ${bfileRare} --keep ${idxRef} --make-bed --out ${bfileSubRare}

# reference files
bfileRefP=${compStr}04_reference/hm3/geno/chr${chr}
# first round merge
bfileRefRare=${compStr}04_reference/hm3_rare/geno/chr${chr}
plink-1.9 --silent --bfile ${bfileSubRare} --maf 0.00001 --bmerge ${bfileRefP} --make-bed --out ${bfileRefRare}

# flip snp file and second round merge
missnp=${bfileRefRare}-merge.missnp

if [ -f ${missnp} ]
then
plink-1.9 --bfile ${bfileSubRare} --exclude ${missnp} --make-bed --out ${bfileSubRare}_tmp
plink-1.9 --bfile ${bfileSubRare}_tmp -bmerge ${bfileRefP} --make-bed --out ${bfileRefRare}
## remove tmp files
rm -f ${bfileSubRare}_tmp*
fi
## remove files
rm -f ${bfileSubRare}*
rm -f ${bfileRefRare}.log
rm -f ${bfileRefRare}-merge.missnp
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0