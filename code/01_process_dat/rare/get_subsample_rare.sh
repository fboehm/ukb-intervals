#!/bin/bash
# rare ref merge sample
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
for p in `seq 13 25`
do
for dat in binary
do
compStr=/net/mulan/disk2/yasheng/comparisonProject/
# rare files
bfileRare=/net/mulan/home/yasheng/predictionProject/plink_file/rare/chr${chr}
# validation files
bfileValP=${compStr}03_subsample/${dat}/pheno${p}/val/impute_inter/chr${chr}
# out files
bfileSubRare=${compStr}03_subsample/${dat}/pheno${p}/val/rare/geno/chr${chr}_rare
bfileValRare=${compStr}03_subsample/${dat}/pheno${p}/val/rare/geno/chr${chr}
idxSub=${compStr}03_subsample/${dat}/pheno${p}/val/01_idx.txt

# first round merge
plink-1.9 --silent --bfile ${bfileRare} --keep ${idxSub} --make-bed --out ${bfileSubRare}
plink-1.9 --silent --bfile ${bfileSubRare} --maf 0.0000001 --bmerge ${bfileValP} --make-bed --out ${bfileValRare}

# # flip snp file
# missnp=${compStr}03_subsample/${dat}/pheno${p}/val/rare/geno/chr${chr}-merge.missnp

# # final merge
# if [ -f ${missnp} ]
# then
# plink-1.9 --bfile ${bfileSubRare} --exclude ${missnp} --make-bed --out ${bfileSubRare}_tmp
# plink-1.9 --bfile ${bfileSubRare}_tmp -bmerge ${bfileValP} --make-bed --out ${bfileValRare}
# ## remove tmp files
# rm -f ${bfileSubRare}_tmp*
# fi
# ## remove files
# rm -f ${bfileSubRare}*
# rm -f ${bfileRefRare}.log
# rm -f ${bfileRefRare}-merge.missnp

# impute
geno_impute=${compStr}code/01_process_dat/05_geno_imputation.R
input=${bfileValRare}
output=${compStr}03_subsample/${dat}/pheno${p}/val/rare/impute/chr${chr}
Rscript ${geno_impute} --plinkin ${input} --plinkout ${output}

done
done
} &
pid=$!
echo $pid
done

wait

exec 6>&-
exit 0