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
for p in 25; do
# for p in 25; do
for cross in 5; do
# bfile
compstr=/net/mulan/disk2/yasheng/comparisonProject/
bfile=${compstr}03_subsample/continuous/pheno${p}/val/impute_inter/chr${chr}

# # lassosum
# estefflassosum=${compstr}05_internal_c/pheno${p}/lassosum/esteff_hm3_cross${cross}.txt
# predlassosum=${compstr}05_internal_c/pheno${p}/lassosum/val_hm3_cross${cross}_chr${chr}
# plink-1.9 --silent --bfile ${bfile} --score ${estefflassosum} 1 2 3 sum --out ${predlassosum}
# gzip -f ${predlassosum}.profile
# rm ${predlassosum}.log
# rm ${predlassosum}.nopred

# # CT and SCT
# esteffCT=${compstr}05_internal_c/pheno${p}/CT/esteff_hm3_cross${cross}.txt
# esteffSCT=${compstr}05_internal_c/pheno${p}/SCT/esteff_hm3_cross${cross}.txt
# predCT=${compstr}05_internal_c/pheno${p}/CT/val_hm3_cross${cross}_chr${chr}
# predSCT=${compstr}05_internal_c/pheno${p}/SCT/val_hm3_cross${cross}_chr${chr}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffCT} 1 2 3 sum --out ${predCT}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffSCT} 1 2 3 sum --out ${predSCT}
# gzip -f ${predCT}.profile
# gzip -f ${predSCT}.profile
# rm ${predCT}.log
# rm ${predCT}.nopred
# rm ${predSCT}.log
# rm ${predSCT}.nopred

# # DBSLMM-t
# esteffdbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/summary_hm3_cross${cross}_chr${chr}_best.dbslmm.txt
# preddbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/val_hm3_best_cross${cross}_chr${chr}
# # gunzip ${esteffdbslmmt}.gz
# plink-1.9 -silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --out ${preddbslmmt}
# gzip -f ${preddbslmmt}.profile
# rm ${preddbslmmt}.log
# rm ${preddbslmmt}.nopred

# DBSLMM
esteffdbslmm=${compstr}05_internal_c/pheno${p}/DBSLMM/summary_hm3_cross${cross}_chr${chr}_auto.dbslmm.txt
preddbslmm=${compstr}05_internal_c/pheno${p}/DBSLMM/val_hm3_cross${cross}_chr${chr}_auto
# gunzip ${esteffdbslmm}.gz
plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmm} 1 2 4 sum --out ${preddbslmm}
gzip -f ${preddbslmm}.profile
# gzip ${esteffdbslmm}
rm ${preddbslmm}.log
rm ${preddbslmm}.nopred

# # LDpred2
# esteffLDpred2=${compstr}05_internal_c/pheno${p}/LDpred2/esteff_hm3_cross${cross}_chr${chr}.txt
# predLDpred2inf=${compstr}05_internal_c/pheno${p}/LDpred2/val_inf_hm3_cross${cross}_chr${chr}
# predLDpred2sp=${compstr}05_internal_c/pheno${p}/LDpred2/val_sp_hm3_cross${cross}_chr${chr}
# predLDpred2nosp=${compstr}05_internal_c/pheno${p}/LDpred2/val_nosp_hm3_cross${cross}_chr${chr}
# predLDpred2auto=${compstr}05_internal_c/pheno${p}/LDpred2/val_auto_hm3_cross${cross}_chr${chr}
# # # gunzip ${esteffLDpred2}.gz
# plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 3 sum --out ${predLDpred2inf}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 4 sum --out ${predLDpred2sp}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 5 sum --out ${predLDpred2nosp}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 6 sum --out ${predLDpred2auto}
# # gzip -f ${esteffLDpred2}
# gzip -f ${predLDpred2inf}.profile
# gzip -f ${predLDpred2sp}.profile
# gzip -f ${predLDpred2nosp}.profile
# gzip -f ${predLDpred2auto}.profile
# rm ${predLDpred2inf}.log
# rm ${predLDpred2sp}.log
# rm ${predLDpred2nosp}.log
# rm ${predLDpred2auto}.log

# # SBLUP
# esteffsblup=${compstr}05_internal_c/pheno${p}/sblup/esteff_hm3_cross${cross}_chr${chr}.sblup.cojo
# predsblup=${compstr}05_internal_c/pheno${p}/sblup/val_hm3_cross${cross}_chr${chr}
# plink-1.9 -silent --bfile ${bfile} --score ${esteffsblup} 1 2 4 sum --out ${predsblup}
# gzip -f ${predsblup}.profile
# rm ${predsblup}.log
# rm ${predsblup}.nopred

# # SbayesR
# esteffsbayesr=${compstr}05_internal_c/pheno${p}/SbayesR/esteff_cross${cross}_chr${chr}
# predsbayesr=${compstr}05_internal_c/pheno${p}/SbayesR/val_cross${cross}_chr${chr}
# gunzip ${esteffsbayesr}.snpRes.gz
# plink-1.9 --silent --bfile ${bfile} --score ${esteffsbayesr}.snpRes 2 5 8 sum header --out ${predsbayesr}
# gzip -f ${predsbayesr}.profile
# # gzip -f ${aggsbayesr}.profile
# rm ${predsbayesr}.log
# rm ${predsbayesr}.nopred
# # rm ${aggsbayesr}.log
# # rm ${aggsbayesr}.nopred


# # PRScs-t
# esteffprscs=${compstr}05_internal_c/pheno${p}/PRScs/esteff_cross${cross}_chr${chr}_best.txt
# predprscs=${compstr}05_internal_c/pheno${p}/PRScs/val_cross${cross}_chr${chr}_best
# gunzip ${esteffprscs}.gz
# plink-1.9 --silent --bfile ${bfile} --score ${esteffprscs} 2 4 6 sum --out ${predprscs}
# gzip -f ${esteffprscs}
# gzip -f ${predprscs}.profile
# rm ${predprscs}.log
# rm ${predprscs}.nopred

# PRScs-auto
esteffprscs=${compstr}05_internal_c/pheno${p}/PRScs/esteff_cross${cross}_chr${chr}_auto.txt
predprscs=${compstr}05_internal_c/pheno${p}/PRScs/val_cross${cross}_chr${chr}_auto
# gunzip ${esteffprscs}.gz
plink-1.9 --silent --bfile ${bfile} --score ${esteffprscs} 2 4 6 sum --out ${predprscs}
# gzip -f ${esteffprscs}
gzip -f ${predprscs}.profile
rm ${predprscs}.log
rm ${predprscs}.nopred

# NPS
esteffnps=${compstr}05_internal_c/pheno${p}/nps/est/esteff_cross${cross}_chr${chr}.txt
prednps=${compstr}05_internal_c/pheno${p}/nps/est/val_cross${cross}_chr${chr}
plink-1.9 --silent --bfile ${bfile} --score ${esteffnps} 1 2 3 sum --out ${prednps}
# gzip -f ${esteffnps}
gzip -f ${prednps}.profile
rm ${prednps}.log
rm ${prednps}.nopred

done
done
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0




