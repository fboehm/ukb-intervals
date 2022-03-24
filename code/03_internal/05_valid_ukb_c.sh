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
bfile=${compstr}03_subsample/continuous/pheno${p}/val/ukb/impute_inter/chr${chr}

# # SBLUP
# esteffsblup=${compstr}05_internal_c/pheno${p}/sblup/esteff_ukb_cross${cross}_chr${chr}.sblup.cojo
# predsblup=${compstr}05_internal_c/pheno${p}/sblup/val_ukb_cross${cross}_chr${chr}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffsblup} 1 2 4 sum --out ${predsblup}
# gzip -f ${predsblup}.profile
# rm ${predsblup}.log
# rm ${predsblup}.nopred

# # lassosum
# estefflassosum=${compstr}05_internal_c/pheno${p}/lassosum/esteff_ukb_cross${cross}.txt
# predlassosum=${compstr}05_internal_c/pheno${p}/lassosum/val_ukb_cross${cross}_chr${chr}
# plink-1.9 --bfile ${bfile} --silent --score ${estefflassosum} 1 2 3 sum  --out ${predlassosum}
# gzip -f ${predlassosum}.profile
# rm ${predlassosum}.log
# rm ${predlassosum}.nopred

# CT and SCT
esteffCT=${compstr}05_internal_c/pheno${p}/CT/esteff_ukb_cross${cross}.txt
esteffSCT=${compstr}05_internal_c/pheno${p}/SCT/esteff_ukb_cross${cross}.txt
predCT=${compstr}05_internal_c/pheno${p}/CT/val_ukb_cross${cross}_chr${chr}
predSCT=${compstr}05_internal_c/pheno${p}/SCT/val_ukb_cross${cross}_chr${chr}
plink-1.9 --bfile ${bfile} --silent --score ${esteffCT} 1 2 3 sum  --out ${predCT}
plink-1.9 --bfile ${bfile} --silent --score ${esteffSCT} 1 2 3 sum --out ${predSCT}
gzip -f ${predCT}.profile
gzip -f ${predSCT}.profile
rm ${predCT}.log
rm ${predCT}.nopred
rm ${predSCT}.log
rm ${predSCT}.nopred

# LDpred2
esteffLDpred2=${compstr}05_internal_c/pheno${p}/LDpred2/esteff_ukb_cross${cross}_chr${chr}.txt
predLDpred2inf=${compstr}05_internal_c/pheno${p}/LDpred2/val_inf_ukb_cross${cross}_chr${chr}
predLDpred2sp=${compstr}05_internal_c/pheno${p}/LDpred2/val_sp_ukb_cross${cross}_chr${chr}
predLDpred2nosp=${compstr}05_internal_c/pheno${p}/LDpred2/val_nosp_ukb_cross${cross}_chr${chr}
predLDpred2auto=${compstr}05_internal_c/pheno${p}/LDpred2/val_auto_ukb_cross${cross}_chr${chr}
gunzip ${esteffLDpred2}.gz
plink-1.9 --bfile ${bfile} --silent --score ${esteffLDpred2} 1 2 3 sum  --out ${predLDpred2inf}
plink-1.9 --bfile ${bfile} --silent --score ${esteffLDpred2} 1 2 4 sum  --out ${predLDpred2sp}
plink-1.9 --bfile ${bfile} --silent --score ${esteffLDpred2} 1 2 5 sum --out ${predLDpred2nosp}
plink-1.9 --bfile ${bfile} --silent --score ${esteffLDpred2} 1 2 6 sum --out ${predLDpred2auto}
gzip ${esteffLDpred2}
gzip -f ${predLDpred2inf}.profile
gzip -f ${predLDpred2sp}.profile
gzip -f ${predLDpred2nosp}.profile
gzip -f ${predLDpred2auto}.profile
rm ${predLDpred2inf}.log
rm ${predLDpred2sp}.log
rm ${predLDpred2nosp}.log
rm ${predLDpred2auto}.log
rm ${predLDpred2inf}.nopred
rm ${predLDpred2sp}.nopred
rm ${predLDpred2nosp}.nopred
rm ${predLDpred2auto}.nopred


# # DBSLMM
# esteffbestdbslmm=${compstr}05_internal_c/pheno${p}/DBSLMM/summary_ukb_cross${cross}_chr${chr}_best.dbslmm.txt
# # esteffdbslmm=${compstr}05_internal_c/pheno${p}/DBSLMM/ukb/summary_ukb_cross${cross}_chr${chr}.dbslmm.txt
# predbestdbslmm=${compstr}05_internal_c/pheno${p}/DBSLMM/val_ukb_best_cross${cross}_chr${chr}
# # preddbslmm=${compstr}05_internal_c/pheno${p}/DBSLMM/ukb/val_ukb_cross${cross}_chr${chr}
# gunzip ${esteffbestdbslmm}.gz
# # gunzip ${esteffdbslmm}.gz
# # plink-1.9 --bfile ${bfile} --silent --score ${esteffdbslmm} 1 2 4 sum --out ${preddbslmm}
# plink-1.9 --bfile ${bfile} --silent --score ${esteffbestdbslmm} 1 2 4 sum  --out ${predbestdbslmm}
# # gzip -f ${preddbslmm}.profile
# gzip -f ${predbestdbslmm}.profile
# # rm ${preddbslmm}.log
# # rm ${preddbslmm}.nopred
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

# exit 0

