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
for p in `seq 1 25`; do
for cross in 1 2 3 4 5; do
# bfile
compstr=/net/mulan/disk2/yasheng/comparisonProject/
bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/AA/hm3/chr${chr}

# bagging
esteffbagging=${compstr}06_internal_b/pheno${p}/bagging/esteff_cross${cross}.txt
predbagging=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/bagging/pred_cross${cross}_chr${chr}
plink-1.9 --silent --bfile ${bfile} --score ${esteffbagging} 1 2 3 sum --out ${predbagging}
gzip -f ${predbagging}.profile
rm ${predbagging}.log
rm ${predbagging}.nopred

# SBLUP
esteffsblup=${compstr}06_internal_b/pheno${p}/sblup/esteff_hm3_cross${cross}_chr${chr}.sblup.cojo
predsblup=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/sblup/pred_hm3_cross${cross}_chr${chr}
gunzip -f ${esteffsblup}
plink-1.9 --silent --bfile ${bfile} --score ${esteffsblup} 1 2 4 sum --out ${predsblup}
gzip -f ${esteffsblup}
gzip -f ${predsblup}.profile
rm ${predsblup}.log
rm ${predsblup}.nopred

# lassosum
estefflassosum=${compstr}06_internal_b/pheno${p}/lassosum/esteff_hm3_cross${cross}.txt
predlassosum=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/lassosum/pred_hm3_cross${cross}_chr${chr}
plink-1.9 --silent --bfile ${bfile} --score ${estefflassosum} 1 2 3 sum --out ${predlassosum}
gzip -f ${predlassosum}.profile
rm ${predlassosum}.log
rm ${predlassosum}.nopred

# CT and SCT
esteffCT=${compstr}06_internal_b/pheno${p}/CT/esteff_hm3_cross${cross}.txt
esteffSCT=${compstr}06_internal_b/pheno${p}/SCT/esteff_hm3_cross${cross}.txt
predCT=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/CT/pred_hm3_cross${cross}_chr${chr}
predSCT=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/SCT/pred_hm3_cross${cross}_chr${chr}
plink-1.9 --silent --bfile ${bfile} --score ${esteffCT} 1 2 3 sum --out ${predCT}
plink-1.9 --silent --bfile ${bfile} --score ${esteffSCT} 1 2 3 sum --out ${predSCT}
gzip -f ${predCT}.profile
gzip -f ${predSCT}.profile
rm ${predCT}.log
rm ${predCT}.nopred
rm ${predSCT}.log
rm ${predSCT}.nopred

# LDpred2
esteffLDpred2=${compstr}06_internal_b/pheno${p}/LDpred2/esteff_hm3_cross${cross}_chr${chr}.txt
predLDpred2inf=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/LDpred2/pred_inf_hm3_cross${cross}_chr${chr}
predLDpred2sp=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/LDpred2/pred_sp_hm3_cross${cross}_chr${chr}
predLDpred2nosp=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/LDpred2/pred_nosp_hm3_cross${cross}_chr${chr}
predLDpred2auto=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/LDpred2/pred_auto_hm3_cross${cross}_chr${chr}
gunzip -f ${esteffLDpred2}.gz
plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 3 sum --out ${predLDpred2inf}
plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 4 sum --out ${predLDpred2sp}
plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 5 sum --out ${predLDpred2nosp}
plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 6 sum --out ${predLDpred2auto}
gzip -f ${esteffLDpred2}
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

# NPS
esteffnps=${compstr}06_internal_b/pheno${p}/nps/est/esteff_cross${cross}_chr${chr}.txt
prednps=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/nps/pred_cross${cross}_chr${chr}
gunzip -f ${esteffnps}.gz
plink-1.9 --silent --bfile ${bfile} --score ${esteffnps} 1 2 3 sum --out ${prednps}
gzip ${esteffnps}
gzip -f ${prednps}.profile
rm ${prednps}.log
rm ${prednps}.nopred

# DBSLMM-t
esteffdbslmmt=${compstr}06_internal_b/pheno${p}/DBSLMM/summary_hm3_cross${cross}_chr${chr}_best.dbslmm.txt
preddbslmmt=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/DBSLMM/pred_hm3_best_cross${cross}_chr${chr}
gunzip -f ${esteffdbslmmt}.gz
plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --out ${preddbslmmt}
gzip -f ${esteffdbslmmt}.gz
gzip -f ${preddbslmmt}.profile
rm ${preddbslmmt}.log
rm ${preddbslmmt}.nopred

# PRScs
esteffprscs=${compstr}06_internal_b/pheno${p}/PRScs/esteff_cross${cross}_chr${chr}_best.txt
predprscs=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/PRScs/pred_cross${cross}_chr${chr}_best
gunzip -f ${esteffprscs}.gz
plink-1.9 --silent --bfile ${bfile} --score ${esteffprscs} 2 4 6 sum --out ${predprscs}
gzip -f ${esteffprscs}.gz
gzip -f ${predprscs}.profile
rm ${predprscs}.log
rm ${predprscs}.nopred

# SbayesR
esteffsbayesr=${compstr}06_internal_b/pheno${p}/SbayesR/esteff_cross${cross}_chr${chr}.snpRes
predsbayesr=${compstr}07_external_c/01_AFR/03_res/binary/pheno${p}_data1/SbayesR/pred_cross${cross}_chr${chr}
gunzip -f ${esteffsbayesr}.gz
plink-1.9 --silent --bfile ${bfile} --score ${esteffsbayesr} 2 5 8 sum header --out ${predsbayesr}
gunzip -f ${esteffsbayesr}.gz
gzip -f ${predsbayesr}.profile
rm ${predsbayesr}.log
rm ${predsbayesr}.nopred

done
done
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0
