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
# for p in `seq 13 25`; do
# for cross in 1 2 3 4 5; do

phenoMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_miss/pheno_ok.txt
crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_miss/cross_ok.txt

for iter in `seq 57 84`;do

p=`head -n ${iter} ${phenoMiss} | tail -n 1`
cross=`head -n ${iter} ${crossMiss} | tail -n 1`

compstr=/net/mulan/disk2/yasheng/comparisonProject/
# bfile
bfile=${compstr}03_subsample/binary/pheno${p}/val/rare/impute_inter/chr${chr}

# # lassosum
# estefflassosum=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/lassosum/esteff_hm3_rare_cross${cross}.txt
# predlassosum=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/lassosum/val_hm3_rare_cross${cross}_chr${chr}
# plink-1.9 --silent --bfile ${bfile} --score ${estefflassosum} 1 2 3 sum --out ${predlassosum}
# gzip -f ${predlassosum}_rare.profile
# rm ${predlassosum}_rare.log
# rm ${predlassosum}_rare.nopred

# # CT and SCT
# esteffCT=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/CT/esteff_hm3_rare_cross${cross}.txt
# esteffSCT=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/SCT/esteff_hm3_rare_cross${cross}.txt
# predCT=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/CT/val_hm3_rare_cross${cross}_chr${chr}
# predSCT=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/SCT/val_hm3_rare_cross${cross}_chr${chr}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffCT} 1 2 3 sum --out ${predCT}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffSCT} 1 2 3 sum --out ${predSCT}
# gzip -f ${predCT}.profile
# gzip -f ${predSCT}.profile
# rm ${predCT}.log
# rm ${predCT}.nopred
# rm ${predSCT}.log
# rm ${predSCT}.nopred

# DBSLMM-t
esteffdbslmmt=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/DBSLMM/rare/summary_hm3_rare_cross${cross}_chr${chr}_best.dbslmm.txt
preddbslmmt=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/DBSLMM/rare/val_hm3_rare_best_cross${cross}_chr${chr}
gunzip ${esteffdbslmmt}.gz
plink-1.9 -silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --out ${preddbslmmt}
gzip -f ${preddbslmmt}.profile
# gzip -f ${esteffdbslmmt}
rm ${preddbslmmt}.log
rm ${preddbslmmt}.nopred

# # DBSLMM
# esteffdbslmm=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/DBSLMM/summary_hm3_rare_cross${cross}_chr${chr}_auto.dbslmm.txt
# preddbslmm=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/DBSLMM/val_hm3_rare_cross${cross}_chr${chr}_auto
# # gunzip ${esteffdbslmm}.gz
# plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmm} 1 2 4 sum --out ${preddbslmm}
# gzip -f ${preddbslmm}.profile
# # gzip ${esteffdbslmm}
# rm ${preddbslmm}.log
# rm ${preddbslmm}.nopred

# # LDpred2
# esteffLDpred2=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/LDpred2/esteff_hm3_rare_cross${cross}_chr${chr}.txt
# predLDpred2inf=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/LDpred2/val_inf_hm3_rare_cross${cross}_chr${chr}
# predLDpred2sp=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/LDpred2/val_sp_hm3_rare_cross${cross}_chr${chr}
# predLDpred2nosp=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/LDpred2/val_nosp_hm3_rare_cross${cross}_chr${chr}
# predLDpred2auto=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/LDpred2/val_auto_hm3_rare_cross${cross}_chr${chr}
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
# esteffsblup=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/sblup/esteff_hm3_rare_cross${cross}_chr${chr}.sblup.cojo
# predsblup=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/sblup/val_hm3_rare_cross${cross}_chr${chr}
# plink-1.9 -silent --bfile ${bfile} --score ${esteffsblup} 1 2 4 sum --out ${predsblup}
# gzip -f ${predsblup}.profile
# rm ${predsblup}.log
# rm ${predsblup}.nopred

# # SbayesR
# esteffsbayesr=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/SbayesR/esteff_cross${cross}_chr${chr}
# predsbayesr=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/SbayesR/val_cross${cross}_chr${chr}
# plink-1.9 --bfile ${bfile} --score ${esteffsbayesr}.snpRes 2 5 8 sum header --out ${predsbayesr}
# # gzip -f ${esteffsbayesr}.snpRes
# gzip -f ${predsbayesr}.profile
# rm ${predsbayesr}.log
# rm ${predsbayesr}.nopred

# # PRScs-t
# esteffprscs=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/PRScs/esteff_cross${cross}_chr${chr}_best.txt
# predprscs=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/PRScs/val_cross${cross}_chr${chr}_best
# gunzip ${esteffprscs}.gz
# plink-1.9 --silent --bfile ${bfile} --score ${esteffprscs} 2 4 6 sum --out ${predprscs}
# gzip -f ${esteffprscs}
# gzip -f ${predprscs}.profile
# rm ${predprscs}.log
# rm ${predprscs}.nopred

# # PRScs-auto
# esteffprscs=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/PRScs/esteff_cross${cross}_chr${chr}_auto.txt
# predprscs=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/PRScs/val_cross${cross}_chr${chr}_auto
# # gunzip ${esteffprscs}.gz
# plink-1.9 --silent --bfile ${bfile} --score ${esteffprscs} 2 4 6 sum --out ${predprscs}
# # gzip -f ${esteffprscs}
# gzip -f ${predprscs}.profile
# rm ${predprscs}.log
# rm ${predprscs}.nopred


# # NPS
# esteffnps=${compstr}06_internal_b/pheno${p}/nps/est/esteff_cross${cross}_chr${chr}.txt
# prednps=${compstr}06_internal_b/pheno${p}/nps/est/val_cross${cross}_chr${chr}
# plink-1.9 --bfile ${bfile} --score ${esteffnps} 1 2 3 sum --out ${prednps}
# # gzip -f ${esteffnps}
# gzip -f ${prednps}.profile
# rm ${prednps}.log
# rm ${prednps}.nopred
done
# done
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0

