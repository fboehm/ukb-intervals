#!/bin/bash
compStr=/net/mulan/disk2/yasheng/comparisonProject/

# ukb subsample
SEND_THREAD_NUM=8
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"

for ((i=0;i<$SEND_THREAD_NUM;i++));do
echo
done >&6

for chr in `seq 15 22`;do
read -u6
{

# ## subsample
bfileAll=/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/chr${chr}
## reference sample
bfileRef=${compStr}04_reference/ukb/geno/allchr${chr}
bfileRefP=${compStr}04_reference/ukb/geno/chr${chr}
idxRef=${compStr}04_reference/01_idx.txt
plink-1.9 --bfile ${bfileAll} --keep ${idxRef} --make-bed --out ${bfileRef}
plink-1.9 --bfile ${bfileRef} --maf 0.01 --make-bed --out ${bfileRefP}

## remove files
rm ${bfileRef}.log
rm ${bfileRef}.bed
rm ${bfileRef}.bim
rm ${bfileRef}.fam
rm ${bfileRefP}.log

## validation sample
for p in `seq 1 25`
do
for dat in continuous
do
bfileSub=${compStr}03_subsample/${dat}/pheno${p}/val_ukb/geno/allchr${chr}
bfileSubP=${compStr}03_subsample/${dat}/pheno${p}/val_ukb/geno/chr${chr}
idxSub=${compStr}03_subsample/${dat}/pheno${p}/val_ukb/01_idx.txt
plink-1.9 --silent --bfile ${bfileAll} --keep ${idxSub} --make-bed --out ${bfileSub}
plink-1.9 --silent --bfile ${bfileSub} --maf 0.01 --make-bed --out ${bfileSubP}
rm ${bfileSub}.log
rm ${bfileSub}.bed
rm ${bfileSub}.bim
rm ${bfileSub}.fam
rm ${bfileSubP}.log

# impute
geno_impute=${compStr}code/01_process_dat/05_geno_imputation.R
input=${bfileSubP}
output=${compStr}03_subsample/${dat}/pheno${p}/val_ukb/impute/chr${chr}
Rscript ${geno_impute} --plinkin ${input} --plinkout ${output}

done

done


} &
pid=$!
echo $pid
done

wait

exec 6>&-

