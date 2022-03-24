#!/bin/bash

echo ${1}
echo ${2}
echo ${3}
echo ${4}
echo ${5}
echo ${6}
echo ${7}
echo ${8}
echo ${9}
echo ${10}

compStr=/net/mulan/disk2/yasheng/comparisonProject/
cd /net/mulan/home/yasheng/comparisonProject/program/nps-master/
npsSumm=${compStr}code/02_method/09_nps_mk_summ.R
# cat ${1}_chr*.assoc.txt > ${1}.assoc.txt
Rscript ${npsSumm} --summ ${1} --info ${10}

Rscript npsR/nps_init.R --gwas ${1}.nps --train-dir ${2} --train-dataset ${3} --window-size ${4} --out ${5} --p ${6}

# # Set up a special partition for GWAS-significant SNPs
# # echo step1
# # ./run_all_chroms.sh sge/nps_gwassig.job ${5}

# # Set up the decorrelated "eigenlocus" space
# # echo step2
# # ./run_all_chroms.sh sge/nps_decor_prune.job ${5} 0
# # ./run_all_chroms.sh sge/nps_decor_prune.job ${5} ${7}
# # ./run_all_chroms.sh sge/nps_decor_prune.job ${5} ${8}
# # ./run_all_chroms.sh sge/nps_decor_prune.job ${5} ${9}

# # Partition the rest of genome
# # echo step3
# # Rscript npsR/nps_prep_part.R ${5} 10 10
# # ./run_all_chroms.sh sge/nps_part.job ${5} 0
# # ./run_all_chroms.sh sge/nps_part.job ${5} ${7}
# # ./run_all_chroms.sh sge/nps_part.job ${5} ${8}
# # ./run_all_chroms.sh sge/nps_part.job ${5} ${9}

# # Estimate shrinkage weights for each partition
# # echo step4
# # Rscript npsR/nps_reweight.R ${5} ${6}
