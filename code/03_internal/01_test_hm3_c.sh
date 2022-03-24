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
for p in `seq 14 25`; do
for cross in 1 2 3 4 5; do

# bfile
compstr1=/net/mulan/disk2/yasheng/comparisonProject/
compstr=/net/mulan/home/yasheng/comparisonProject/
bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/hm3/chr${chr}
idxtest=${compstr1}02_pheno/01_test_idx_c/idx_pheno${p}_cross${cross}.txt
# idxagg=${compstr}03_subsample/continuous/pheno${p}/agg/01_idx.txt

# # sblup
# esteffsblup=${compstr}05_internal_c/pheno${p}/sblup/esteff_hm3_cross${cross}_chr${chr}.sblup.cojo
# # predsblup=${compstr}05_internal_c/pheno${p}/sblup/pred_hm3_cross${cross}_chr${chr}
# aggsblup=${compstr}05_internal_c/pheno${p}/sblup/agg_hm3_cross${cross}_chr${chr}
# gunzip -f ${esteffsblup}.gz
# # plink-1.9 --silent --bfile ${bfile} --score ${esteffsblup} 1 2 4 sum --keep ${idxtest} --out ${predsblup}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffsblup} 1 2 4 sum --keep ${idxagg} --out ${aggsblup}
# gzip -f ${esteffsblup}
# # gzip -f ${predsblup}.profile
# gzip -f ${aggsblup}.profile
# # rm ${predsblup}.log
# # rm ${predsblup}.nopred
# rm ${aggsblup}.log
# rm ${aggsblup}.nopred

# # lassosum
# estefflassosum=${compstr}05_internal_c/pheno${p}/lassosum/esteff_hm3_cross${cross}.txt
# # predlassosum=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/lassosum/pred_hm3_cross${cross}_chr${chr}
# agglassosum=${compstr}05_internal_c/pheno${p}/lassosum/agg_hm3_cross${cross}_chr${chr}
# # plink-1.9 --silent --bfile ${bfile} --score ${estefflassosum} 1 2 3 sum --keep ${idxtest} --out ${predlassosum}
# plink-1.9 --silent --bfile ${bfile} --score ${estefflassosum} 1 2 3 sum --keep ${idxagg} --out ${agglassosum}
# # gzip -f ${predlassosum}.profile
# gzip -f ${agglassosum}.profile
# # rm ${predlassosum}.log
# # rm ${predlassosum}.nopred
# rm ${agglassosum}.log
# rm ${agglassosum}.nopred

# DBSLMM-t
esteffdbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/summary_hm3_cross${cross}_chr${chr}_best.dbslmm.txt
preddbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/pred_hm3_best_cross${cross}_chr${chr}
# aggdbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/agg_hm3_best_cross${cross}_chr${chr}
gunzip ${esteffdbslmmt}.gz
plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --keep ${idxtest} --out ${preddbslmmt}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --keep ${idxagg} --out ${aggdbslmmt}
gzip -f ${esteffdbslmmt}
gzip -f ${preddbslmmt}.profile
# gzip -f ${aggdbslmmt}.profile
rm ${preddbslmmt}.log
rm ${preddbslmmt}.nopred
# rm ${aggdbslmmt}.log
# rm ${aggdbslmmt}.nopred

# # SbayesR
# esteffsbayesr=${compstr}05_internal_c/pheno${p}/SbayesR/esteff_cross${cross}_chr${chr}
# # predsbayesr=${compstr}05_internal_c/pheno${p}/SbayesR/pred_cross${cross}_chr${chr}
# aggsbayesr=${compstr}05_internal_c/pheno${p}/SbayesR/agg_cross${cross}_chr${chr}
# gunzip ${esteffsbayesr}.snpRes.gz
# # plink-1.9 --silent --bfile ${bfile} --score ${esteffsbayesr}.snpRes 2 5 8 sum header --keep ${idxtest} --out ${predsbayesr}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffsbayesr}.snpRes 2 5 8 sum header --keep ${idxagg} --out ${aggsbayesr}
# gzip -f ${esteffsbayesr}.snpRes
# # gzip -f ${predsbayesr}.profile
# gzip -f ${aggsbayesr}.profile
# # rm ${predsbayesr}.log
# # rm ${predsbayesr}.nopred
# rm ${aggsbayesr}.log
# rm ${aggsbayesr}.nopred

# # CT and SCT
# esteffCT=${compstr}05_internal_c/pheno${p}/CT/esteff_hm3_cross${cross}.txt
# esteffSCT=${compstr}05_internal_c/pheno${p}/SCT/esteff_hm3_cross${cross}.txt
# # predCT=${compstr}05_internal_c/pheno${p}/CT/pred_hm3_cross${cross}_chr${chr}
# # predSCT=${compstr}/05_internal_c/pheno${p}/SCT/pred_hm3_cross${cross}_chr${chr}
# aggCT=${compstr}05_internal_c/pheno${p}/CT/agg_hm3_cross${cross}_chr${chr}
# aggSCT=${compstr}05_internal_c/pheno${p}/SCT/agg_hm3_cross${cross}_chr${chr}
# # plink-1.9 --silent --bfile ${bfile} --score ${esteffCT} 1 2 3 sum --keep ${idxtest} --out ${predCT}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffCT} 1 2 3 sum --keep ${idxagg} --out ${aggCT}
# # plink-1.9 --silent --bfile ${bfile} --score ${esteffSCT} 1 2 3 sum --keep ${idxtest} --out ${predSCT}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffSCT} 1 2 3 sum --keep ${idxagg} --out ${aggSCT}
# # gzip -f ${predCT}.profile
# # gzip -f ${predSCT}.profile
# gzip -f ${aggCT}.profile
# gzip -f ${aggSCT}.profile
# # rm ${predCT}.log
# # rm ${predCT}.nopred
# rm ${aggCT}.log
# rm ${aggCT}.nopred
# # rm ${predSCT}.log
# # rm ${predSCT}.nopred
# rm ${aggSCT}.log
# rm ${aggSCT}.nopred

# # PRScs-t
# esteffprscs=${compstr}05_internal_c/pheno${p}/PRScs/esteff_cross${cross}_chr${chr}_best.txt
# # predprscs=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/PRScs/pred_cross${cross}_chr${chr}_best
# aggprscs=${compstr}05_internal_c/pheno${p}/PRScs/agg_cross${cross}_chr${chr}_best
# gunzip ${esteffprscs}.gz
# # plink-1.9 --silent --bfile ${bfile} --score ${esteffprscs} 2 4 6 sum --keep ${idxtest} --out ${predprscs}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffprscs} 2 4 6 sum --keep ${idxagg} --out ${aggprscs}
# gzip -f ${esteffprscs}
# # gzip -f ${predprscs}.profile
# gzip -f ${aggprscs}.profile
# # rm ${predprscs}.log
# # rm ${predprscs}.nopred
# rm ${aggprscs}.log
# rm ${aggprscs}.nopred

# # LDpred2
# esteffLDpred2=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/LDpred2/esteff_hm3_cross${cross}_chr${chr}.txt
# # predLDpred2inf=${compstr1}05_internal_c/pheno${p}/LDpred2/pred_inf_hm3_cross${cross}_chr${chr}
# # predLDpred2sp=${compstr1}05_internal_c/pheno${p}/LDpred2/pred_sp_hm3_cross${cross}_chr${chr}
# # predLDpred2nosp=${compstr1}05_internal_c/pheno${p}/LDpred2/pred_nosp_hm3_cross${cross}_chr${chr}
# # predLDpred2auto=${compstr1}05_internal_c/pheno${p}/LDpred2/pred_auto_hm3_cross${cross}_chr${chr}
# aggLDpred2inf=${compstr}05_internal_c/pheno${p}/LDpred2/agg_inf_hm3_cross${cross}_chr${chr}
# aggLDpred2sp=${compstr}05_internal_c/pheno${p}/LDpred2/agg_sp_hm3_cross${cross}_chr${chr}
# aggLDpred2nosp=${compstr}05_internal_c/pheno${p}/LDpred2/agg_nosp_hm3_cross${cross}_chr${chr}
# aggLDpred2auto=${compstr}05_internal_c/pheno${p}/LDpred2/agg_auto_hm3_cross${cross}_chr${chr}
# gunzip ${esteffLDpred2}.gz
# # plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 3 sum --keep ${idxtest} --out ${predLDpred2inf}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 3 sum --keep ${idxagg} --out ${aggLDpred2inf}
# # plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 4 sum --keep ${idxtest} --out ${predLDpred2sp}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 4 sum --keep ${idxagg} --out ${aggLDpred2sp}
# # plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 5 sum --keep ${idxtest} --out ${predLDpred2nosp}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 5 sum --keep ${idxagg} --out ${aggLDpred2nosp}
# # plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 6 sum --keep ${idxtest} --out ${predLDpred2auto}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffLDpred2} 1 2 6 sum --keep ${idxagg} --out ${aggLDpred2auto}
# gzip -f ${esteffLDpred2}
# # gzip -f ${predLDpred2inf}.profile
# # gzip -f ${predLDpred2sp}.profile
# # gzip -f ${predLDpred2nosp}.profile
# # gzip -f ${predLDpred2auto}.profile
# gzip -f ${aggLDpred2inf}.profile
# gzip -f ${aggLDpred2sp}.profile
# gzip -f ${aggLDpred2nosp}.profile
# gzip -f ${aggLDpred2auto}.profile
# # rm ${predLDpred2inf}.log
# # rm ${predLDpred2sp}.log
# # rm ${predLDpred2nosp}.log
# # rm ${predLDpred2auto}.log
# rm ${aggLDpred2inf}.log
# rm ${aggLDpred2sp}.log
# rm ${aggLDpred2nosp}.log
# rm ${aggLDpred2auto}.log

# # DBSLMM
# esteffdbslmm=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/DBSLMM/summary_hm3_cross${cross}_chr${chr}_auto.dbslmm.txt
# preddbslmm=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/DBSLMM/pred_hm3_cross${cross}_chr${chr}_auto
# plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmm} 1 2 4 sum --keep ${idxtest} --out ${preddbslmm}
# # gzip -f ${esteffdbslmm}
# gzip -f ${preddbslmm}.profile
# rm ${preddbslmm}.log
# rm ${preddbslmm}.nopred


# # # PRScs
# # esteffprscs=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/PRScs/esteff_cross${cross}_chr${chr}.txt
# # predprscs=/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/pheno${p}/PRScs/pred_cross${cross}_chr${chr}
# # # plink-1.9 --bfile ${bfile} --score ${esteffprscs} 2 4 6 sum --keep ${idx} --out ${predprscs}
# # # rm ${predprscs}.log

# # NPS
# esteffnps=${compstr}05_internal_c/pheno${p}/nps/est/esteff_cross${cross}_chr${chr}.txt
# prednps=${compstr}05_internal_c/pheno${p}/nps/est/pred_cross${cross}_chr${chr}
# aggnps=${compstr}05_internal_c/pheno${p}/nps/est/agg_cross${cross}_chr${chr}
# # gunzip -f ${esteffnps}.gz
# plink-1.9 -silent --bfile ${bfile} --score ${esteffnps} 1 2 3 sum --keep ${idxtest} --out ${prednps}
# plink-1.9 -silent --bfile ${bfile} --score ${esteffnps} 1 2 3 sum --keep ${idxagg} --out ${aggnps}
# # gzip -f ${esteffnps}
# gzip -f ${prednps}.profile
# rm ${prednps}.log
# rm ${prednps}.nopred
# gzip -f ${aggnps}.profile
# rm ${aggnps}.log
# rm ${aggnps}.nopred
done
done
} &
pid=$!
echo $pid
done

wait

exec 6>&-

# exit 0

