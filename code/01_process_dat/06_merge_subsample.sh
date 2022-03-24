#!/bin/bash
comp_str=/net/mulan/disk2/yasheng/comparisonProject/
for p in `seq 1 25`
do
for dat in continuous binary
do
## merge hm3 subsample
chr1=${comp_str}03_subsample/${dat}/pheno${p}/val/impute/chr1
mergelist=${comp_str}03_subsample/${dat}/pheno${p}/val/merge_list.txt
merge=${comp_str}03_subsample/${dat}/pheno${p}/val/impute/merge
plink-1.9 --silent --bfile ${chr1} --merge-list ${mergelist} --make-bed --out ${merge}
rm ${merge}.log

## hm3 male subsample
idxmale=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/${dat}/pheno${p}/01_idx_male.txt
mergefile=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/${dat}/pheno${p}/hm3/impute/merge
mergemalefile=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/${dat}/pheno${p}/hm3/impute/merge_male
plink-1.9 --bfile ${mergefile} --keep ${idxmale} --make-bed --out ${mergemalefile}

## hm3 female subsample
idxfemale=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/${dat}/pheno${p}/01_idx_female.txt
mergefile=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/${dat}/pheno${p}/hm3/impute/merge
mergefemalefile=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/${dat}/pheno${p}/hm3/impute/merge_female
plink-1.9 --bfile ${mergefile} --keep ${idxfemale} --make-bed --out ${mergefemalefile}

done
done
