#!/bin/bash

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
for p in `seq 21 25`; do
for cross in 1 2 3 4 5;do

# bfile
compstr=/net/mulan/disk2/yasheng/comparisonProject/
bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/chr${chr}
idxtest=${compstr}02_pheno/01_test_idx_c/idx_pheno${p}_cross${cross}.txt
# # SBLUP
# esteffsblup=${compstr}05_internal_c/pheno${p}/sblup/esteff_ukb_cross${cross}_chr${chr}.sblup.cojo
# predsblup=${compstr}05_internal_c/pheno${p}/sblup/pred_ukb_cross${cross}_chr${chr}
# gunzip ${esteffsblup}.gz
# plink-1.9 --bfile ${bfile} --score ${esteffsblup} 1 2 4 sum --keep ${idxtest} --out ${predsblup}
# gzip -f ${predsblup}.profile
# rm ${predsblup}.log
# rm ${predsblup}.nopred

# # lassosum
# estefflassosum=${compstr}05_internal_c/pheno${p}/lassosum/esteff_ukb_cross${cross}.txt
# predlassosum=${compstr}05_internal_c/pheno${p}/lassosum/pred_ukb_cross${cross}_chr${chr}
# plink-1.9 --silent --bfile ${bfile} --score ${estefflassosum} 1 2 3 sum --keep ${idxtest} --out ${predlassosum}
# gzip -f ${predlassosum}.profile
# rm ${predlassosum}.log
# rm ${predlassosum}.nopred

# # CT and SCT
# esteffCT=${compstr}05_internal_c/pheno${p}/CT/esteff_ukb_cross${cross}.txt
# esteffSCT=${compstr}05_internal_c/pheno${p}/SCT/esteff_ukb_cross${cross}.txt
# predCT=${compstr}05_internal_c/pheno${p}/CT/pred_ukb_cross${cross}_chr${chr}
# predSCT=${compstr}05_internal_c/pheno${p}/SCT/pred_ukb_cross${cross}_chr${chr}
# plink-1.9 --bfile ${bfile} --silent --score ${esteffCT} 1 2 3 sum --keep ${idxtest} --out ${predCT}
# plink-1.9 --bfile ${bfile} --silent --score ${esteffSCT} 1 2 3 sum --keep ${idxtest} --out ${predSCT}
# gzip -f ${predCT}.profile
# gzip -f ${predSCT}.profile
# rm ${predCT}.log
# rm ${predCT}.nopred
# rm ${predSCT}.log
# rm ${predSCT}.nopred

# LDpred2
esteffLDpred2=${compstr}05_internal_c/pheno${p}/LDpred2/esteff_ukb_cross${cross}_chr${chr}.txt
predLDpred2inf=${compstr}05_internal_c/pheno${p}/LDpred2/pred_inf_ukb_cross${cross}_chr${chr}
predLDpred2sp=${compstr}05_internal_c/pheno${p}/LDpred2/pred_sp_ukb_cross${cross}_chr${chr}
predLDpred2nosp=${compstr}05_internal_c/pheno${p}/LDpred2/pred_nosp_ukb_cross${cross}_chr${chr}
predLDpred2auto=${compstr}05_internal_c/pheno${p}/LDpred2/pred_auto_ukb_cross${cross}_chr${chr}
# gunzip ${esteffLDpred2}.gz
plink-1.9 --bfile ${bfile} --silent --score ${esteffLDpred2} 1 2 3 sum --keep ${idxtest} --out ${predLDpred2inf}
plink-1.9 --bfile ${bfile} --silent --score ${esteffLDpred2} 1 2 4 sum --keep ${idxtest} --out ${predLDpred2sp}
plink-1.9 --bfile ${bfile} --silent --score ${esteffLDpred2} 1 2 5 sum --keep ${idxtest} --out ${predLDpred2nosp}
plink-1.9 --bfile ${bfile} --silent --score ${esteffLDpred2} 1 2 6 sum --keep ${idxtest} --out ${predLDpred2auto}
gzip -f ${esteffLDpred2}
gzip -f ${predLDpred2inf}.profile
gzip -f ${predLDpred2sp}.profile
gzip -f ${predLDpred2nosp}.profile
gzip -f ${predLDpred2auto}.profile
rm ${predLDpred2inf}.log
rm ${predLDpred2sp}.log
rm ${predLDpred2nosp}.log
rm ${predLDpred2auto}.log

# # DBSLMM
# esteffdbslmm=${compstr}05_internal_c/pheno${p}/DBSLMM/ukb/summary_ukb_cross${cross}_chr${chr}.dbslmm.txt
# preddbslmm=${compstr}05_internal_c/pheno${p}/DBSLMM/pred_ukb_cross${cross}_chr${chr}
# gunzip ${esteffdbslmm}.gz
# plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmm} 1 2 4 sum --keep ${idxtest} --out ${preddbslmm}
# # gzip ${esteffdbslmm}
# gzip -f ${preddbslmm}.profile
# rm ${preddbslmm}.log
# rm ${preddbslmm}.nopred

# # DBSLMM
# esteffbestdbslmm=${compstr}05_internal_c/pheno${p}/DBSLMM/summary_ukb_cross${cross}_chr${chr}_best.dbslmm.txt
# predbestdbslmm=${compstr}05_internal_c/pheno${p}/DBSLMM/pred_ukb_best_cross${cross}_chr${chr}
# gunzip ${esteffbestdbslmm}.gz
# plink-1.9 --bfile ${bfile} --score ${esteffbestdbslmm} 1 2 4 sum --keep ${idxtest} --out ${predbestdbslmm}
# gzip -f ${esteffbestdbslmm}
# gzip -f ${predbestdbslmm}.profile
# rm ${predbestdbslmm}.log
# rm ${predbestdbslmm}.nopred

done
done
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0

