#!/bin/bash

## merge hm3 subsample
chr1=~/research/ukb-intervals/dat/03_subsample/hm3/geno/chr1
mergelist=~/research/ukb-intervals/dat/03_subsample/hm3/mergelist.txt
merge=~/research/ukb-intervals/dat/03_subsample/03_subsample/hm3/geno/merge
plink-1.9 --bfile ${chr1} --merge-list ${mergelist} --make-bed --out ${merge}
#rm ${merge}.log

## hm3 male subsample
idxmale=~/research/ukb-intervals/dat/03_subsample/01_idx_male.txt
mergefile=~/research/ukb-intervals/dat/03_subsample/hm3/geno/merge
mergemalefile=~/research/ukb-intervals/dat/03_subsample/hm3/geno/merge_male
plink-1.9 --bfile ${mergefile} --keep ${idxmale} --make-bed --out ${mergemalefile}

## hm3 female subsample
idxfemale=~/research/ukb-intervals/dat/03_subsample/01_idx_female.txt
mergefile=~/research/ukb-intervals/dat/03_subsample/hm3/geno/merge
mergefemalefile=~/research/ukb-intervals/dat/03_subsample/hm3/geno/merge_female
plink-1.9 --bfile ${mergefile} --keep ${idxfemale} --make-bed --out ${mergefemalefile}
