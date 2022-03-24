mkld=/net/mulan/disk2/yasheng/comparisonProject/code/09_code_to_github/MAKELD.R

chr=22
bfile=/net/mulan/disk2/yasheng/comparisonProject/09_external_LD/EUR/geno/chr${chr}
blockfile=/net/mulan/disk2/yasheng/comparisonProject/LDblock_EUR/chr${chr}.bed
plink=/usr/cluster/bin/plink-1.9
outpath=/net/mulan/disk2/yasheng/comparisonProject/code/09_code_to_github/

Rscript ${mkld} --bfile ${bfile} --blockfile ${blockfile} --plink ${plink} --outpath ${outpath} --chr ${chr}


external=/net/mulan/disk2/yasheng/comparisonProject/code/09_code_to_github/EXTERNAL.R
extsumm=/net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno1_data2_herit.ldsc.gz
esteff=/net/mulan/disk2/yasheng/comparisonProject/code/09_code_to_github/esteff.txt
LDpath=/net/mulan/disk2/yasheng/comparisonProject/09_external_LD/EUR/LDmat/
outpath=/net/mulan/disk2/yasheng/comparisonProject/code/09_code_to_github/
Rscript ${external} --extsumm ${extsumm} --esteff ${esteff},1,2,3 --LDpath ${LDpath} --outpath ${outpath}

