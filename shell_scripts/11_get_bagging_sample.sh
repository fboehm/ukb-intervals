sub_str=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/
val_idx=${sub_str}bagging/01_val_idx.txt
test_idx=${sub_str}bagging/02_test_idx.txt

# merge
all_bfile=${sub_str}hm3/geno/merge
val_bfile=${sub_str}/bagging/val_hm3/geno/merge
test_bfile=${sub_str}/bagging/test_hm3/geno/merge

plink-1.9 --bfile ${all_bfile} --keep ${val_idx} --make-bed --out ${val_bfile}
plink-1.9 --bfile ${all_bfile} --keep ${test_idx} --make-bed --out ${test_bfile}

rm ${val_bfile}.log
rm ${test_bfile}.log

for chr in `seq 1 22`
do
all_bfile=${sub_str}hm3/geno/chr${chr}_imp
val_bfile=${sub_str}/bagging/val_hm3/geno/chr${chr}
test_bfile=${sub_str}/bagging/test_hm3/geno/chr${chr}

plink-1.9 --bfile ${all_bfile} --keep ${val_idx} --make-bed --out ${val_bfile}
plink-1.9 --bfile ${all_bfile} --keep ${test_idx} --make-bed --out ${test_bfile}

rm ${val_bfile}.log
rm ${test_bfile}.log

done
