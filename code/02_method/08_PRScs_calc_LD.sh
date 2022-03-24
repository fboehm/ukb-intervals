#!/bin/bash

MKLDM=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/08_PRScs_calc_LD.R

for chr in `seq 1 21`; do
Rscript ${MKLDM} --chr ${chr}
done

