#!/bin/bash

cd /net/mulan/disk2/yasheng/comparisonProject/02_pheno/02_train_c
rm ${tot}
paste pheno_pheno1.txt pheno_pheno2.txt pheno_pheno3.txt pheno_pheno4.txt pheno_pheno5.txt pheno_pheno6.txt pheno_pheno7.txt pheno_pheno8.txt pheno_pheno9.txt pheno_pheno10.txt pheno_pheno11.txt pheno_pheno12.txt pheno_pheno13.txt pheno_pheno14.txt pheno_pheno15.txt pheno_pheno16.txt pheno_pheno17.txt pheno_pheno18.txt pheno_pheno19.txt pheno_pheno20.txt pheno_pheno21.txt pheno_pheno22.txt pheno_pheno23.txt pheno_pheno24.txt pheno_pheno25.txt > pheno_tot.txt
tot=/net/mulan/disk2/yasheng/comparisonProject/02_pheno/02_train_c/pheno_tot.txt
for chr in `seq 1 21`
do
summ=/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/chr${chr}.fam
summtmp=/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/chr${chr}_tmp.fam
awk '{print $1,$2,$3,$4,$5}' ${summ} > ${summtmp}
paste ${summtmp} ${tot} > ${summ}
rm ${summtmp}
done
rm ${tot}