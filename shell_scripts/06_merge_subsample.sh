#!/bin/bash

## merge hm3 subsample
chr1=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/hm3/geno/chr1
mergelist=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/hm3/mergelist.txt
merge=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/hm3/geno/merge
plink-1.9 --bfile ${chr1} --merge-list ${mergelist} --make-bed --out ${merge}
rm ${merge}.log

## hm3 male subsample
idxmale=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/01_idx_male.txt
mergefile=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/hm3/geno/merge
mergemalefile=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/hm3/geno/merge_male
plink-1.9 --bfile ${mergefile} --keep ${idxmale} --make-bed --out ${mergemalefile}

## hm3 female subsample
idxfemale=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/01_idx_female.txt
mergefile=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/hm3/geno/merge
mergefemalefile=/net/mulan/disk2/yasheng/comparisonProject/03_subsample/hm3/geno/merge_female
plink-1.9 --bfile ${mergefile} --keep ${idxfemale} --make-bed --out ${mergefemalefile}
