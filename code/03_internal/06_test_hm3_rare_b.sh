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
phenoMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_miss/pheno.txt
crossMiss=/net/mulan/disk2/yasheng/comparisonProject/code/02_method/DBSLMM_miss/cross.txt

for iter in `seq 1 41`;do

p=`head -n ${iter} ${phenoMiss} | tail -n 1`
cross=`head -n ${iter} ${crossMiss} | tail -n 1`

# bfile
compstr=/net/mulan/disk2/yasheng/comparisonProject/
bfile=/net/mulan/home/yasheng/predictionProject/plink_file/hm3_rare/chr${chr}

idxtest=${compstr}02_pheno/04_test_idx_b/idx_pheno${p}_cross${cross}.txt

# # sblup
# esteffsblup=${compstr}06_internal_b/pheno${p}/sblup/esteff_hm3_rare_cross${cross}_chr${chr}.sblup.cojo
# # predsblup=${compstr}06_internal_b/pheno${p}/sblup/pred_hm3_rare_cross${cross}_chr${chr}
# aggsblup=${compstr}06_internal_b/pheno${p}/sblup/agg_hm3_rare_cross${cross}_chr${chr}
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
# estefflassosum=${compstr}06_internal_b/pheno${p}/lassosum/esteff_hm3_rare_cross${cross}.txt
# predlassosum=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/lassosum/pred_hm3_rare_cross${cross}_chr${chr}
# # agglassosum=${compstr}06_internal_b/pheno${p}/lassosum/agg_hm3_rare_cross${cross}_chr${chr}
# plink-1.9 --silent --bfile ${bfile_hm3} --score ${estefflassosum} 1 2 3 sum --keep ${idxtest} --out ${predlassosum}_hm3
# plink-1.9 --silent --bfile ${bfile_rare} --score ${estefflassosum} 1 2 3 sum --keep ${idxtest} --out ${predlassosum}_rare
# # plink-1.9 --silent --bfile ${bfile_hm3} --score ${estefflassosum} 1 2 3 sum --keep ${idxagg} --out ${agglassosum}_hm3
# # plink-1.9 --silent --bfile ${bfile_rare} --score ${estefflassosum} 1 2 3 sum --keep ${idxagg} --out ${agglassosum}_rare

# gzip -f ${predlassosum}_hm3.profile
# gzip -f ${predlassosum}_rare.profile
# # gzip -f ${agglassosum}_hm3.profile
# # gzip -f ${agglassosum}_rare.profile

# rm ${predlassosum}_hm3.log
# rm ${predlassosum}_hm3.nopred
# rm ${predlassosum}_rare.log
# rm ${predlassosum}_rare.nopred
# # rm ${agglassosum}_hm3.log
# # rm ${agglassosum}_hm3.nopred
# # rm ${agglassosum}_rare.log
# # rm ${agglassosum}_rare.nopred

# DBSLMM-t
esteffdbslmmt=${compstr}06_internal_b/pheno${p}/DBSLMM/rare/summary_hm3_rare_cross${cross}_chr${chr}_best.dbslmm.txt
preddbslmmt=${compstr}06_internal_b/pheno${p}/DBSLMM/rare/pred_hm3_rare_best_cross${cross}_chr${chr}
# aggdbslmmt=${compstr}06_internal_b/pheno${p}/DBSLMM/rare/agg_hm3_rare_cross${cross}_chr${chr}_best
# gunzip ${esteffdbslmmt}.gz
plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --keep ${idxtest} --out ${preddbslmmt}
# plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --keep ${idxagg} --out ${aggdbslmmt}
# gzip -f ${esteffdbslmmt}
gzip -f ${preddbslmmt}.profile
# gzip -f ${aggdbslmmt}.profile

rm ${preddbslmmt}.log
rm ${preddbslmmt}.nopred
# rm ${aggdbslmmt}_hm3.log
# rm ${aggdbslmmt}_hm3.nopred
# rm ${aggdbslmmt}_rare.log
# rm ${aggdbslmmt}_rare.nopred

# # DBSLMM
# esteffdbslmm=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/DBSLMM/summary_hm3_rare_cross${cross}_chr${chr}_auto.dbslmm.txt
# preddbslmm=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/DBSLMM/pred_hm3_rare_cross${cross}_chr${chr}_auto
# plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmm} 1 2 4 sum --keep ${idxtest} --out ${preddbslmm}
# # gzip -f ${esteffdbslmm}
# gzip -f ${preddbslmm}.profile
# rm ${preddbslmm}.log
# rm ${preddbslmm}.nopred


# # CT and SCT
# esteffCT=${compstr}06_internal_b/pheno${p}/CT/esteff_hm3_rare_cross${cross}.txt
# esteffSCT=${compstr}06_internal_b/pheno${p}/SCT/esteff_hm3_rare_cross${cross}.txt
# predCT=${compstr}06_internal_b/pheno${p}/CT/pred_hm3_rare_cross${cross}_chr${chr}
# predSCT=${compstr}/06_internal_b/pheno${p}/SCT/pred_hm3_rare_cross${cross}_chr${chr}
# # aggCT=${compstr}06_internal_b/pheno${p}/CT/agg_hm3_rare_cross${cross}_chr${chr}
# # aggSCT=${compstr}06_internal_b/pheno${p}/SCT/agg_hm3_rare_cross${cross}_chr${chr}
# plink-1.9 --silent --bfile ${bfile_hm3} --score ${esteffCT} 1 2 3 sum --keep ${idxtest} --out ${predCT}_hm3
# plink-1.9 --silent --bfile ${bfile_rare} --score ${esteffCT} 1 2 3 sum --keep ${idxtest} --out ${predCT}_rare
# # plink-1.9 --silent --bfile ${bfile_hm3} --score ${esteffCT} 1 2 3 sum --keep ${idxagg} --out ${aggCT}_hm3
# # plink-1.9 --silent --bfile ${bfile_rare} --score ${esteffCT} 1 2 3 sum --keep ${idxagg} --out ${aggCT}_rare
# plink-1.9 --silent --bfile ${bfile_hm3} --score ${esteffSCT} 1 2 3 sum --keep ${idxtest} --out ${predSCT}_hm3
# plink-1.9 --silent --bfile ${bfile_rare} --score ${esteffSCT} 1 2 3 sum --keep ${idxtest} --out ${predSCT}_rare
# # plink-1.9 --silent --bfile ${bfile_hm3} --score ${esteffSCT} 1 2 3 sum --keep ${idxagg} --out ${aggSCT}_hm3
# # plink-1.9 --silent --bfile ${bfile_rare} --score ${esteffSCT} 1 2 3 sum --keep ${idxagg} --out ${aggSCT}_rare

# gzip -f ${predCT}_hm3.profile
# gzip -f ${predSCT}_hm3.profile
# gzip -f ${predCT}_rare.profile
# gzip -f ${predSCT}_rare.profile
# # gzip -f ${aggCT}_hm3.profile
# # gzip -f ${aggSCT}_hm3.profile
# # gzip -f ${aggCT}_rare.profile
# # gzip -f ${aggSCT}_rare.profile
# rm ${predCT}_hm3.log
# rm ${predCT}_hm3.nopred
# rm ${predCT}_rare.log
# rm ${predCT}_rare.nopred
# # rm ${aggCT}_hm3.log
# # rm ${aggCT}_hm3.nopred
# # rm ${aggCT}_rare.log
# # rm ${aggCT}_rare.nopred
# rm ${predSCT}_hm3.log
# rm ${predSCT}_hm3.nopred
# rm ${predSCT}_rare.log
# rm ${predSCT}_rare.nopred
# # rm ${aggSCT}_hm3.log
# # rm ${aggSCT}_hm3.nopred
# # rm ${aggSCT}_rare.log
# # rm ${aggSCT}_rare.nopred


# # # LDpred2
# esteffLDpred2=/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/pheno${p}/LDpred2/esteff_hm3_rare_cross${cross}_chr${chr}.txt
# predLDpred2inf=${compstr}06_internal_b/pheno${p}/LDpred2/pred_inf_hm3_rare_cross${cross}_chr${chr}
# predLDpred2sp=${compstr}06_internal_b/pheno${p}/LDpred2/pred_sp_hm3_rare_cross${cross}_chr${chr}
# predLDpred2nosp=${compstr}06_internal_b/pheno${p}/LDpred2/pred_nosp_hm3_rare_cross${cross}_chr${chr}
# predLDpred2auto=${compstr}06_internal_b/pheno${p}/LDpred2/pred_auto_hm3_rare_cross${cross}_chr${chr}
# # aggLDpred2inf=${compstr}06_internal_b/pheno${p}/LDpred2/agg_inf_hm3_rare_cross${cross}_chr${chr}
# # aggLDpred2sp=${compstr}06_internal_b/pheno${p}/LDpred2/agg_sp_hm3_rare_cross${cross}_chr${chr}
# # aggLDpred2nosp=${compstr}06_internal_b/pheno${p}/LDpred2/agg_nosp_hm3_rare_cross${cross}_chr${chr}
# # aggLDpred2auto=${compstr}06_internal_b/pheno${p}/LDpred2/agg_auto_hm3_rare_cross${cross}_chr${chr}
# # gunzip ${esteffLDpred2}.gz
# plink-1.9 --silent --bfile ${bfile_hm3} --score ${esteffLDpred2} 1 2 3 sum --keep ${idxtest} --out ${predLDpred2inf}_hm3
# plink-1.9 --silent --bfile ${bfile_rare} --score ${esteffLDpred2} 1 2 3 sum --keep ${idxtest} --out ${predLDpred2inf}_rare
# # plink-1.9 --silent --bfile ${bfile_hm3} --score ${esteffLDpred2} 1 2 3 sum --keep ${idxagg} --out ${aggLDpred2inf}_hm3
# # plink-1.9 --silent --bfile ${bfile_rare} --score ${esteffLDpred2} 1 2 3 sum --keep ${idxagg} --out ${aggLDpred2inf}_rare
# plink-1.9 --silent --bfile ${bfile_hm3} --score ${esteffLDpred2} 1 2 4 sum --keep ${idxtest} --out ${predLDpred2sp}_hm3
# plink-1.9 --silent --bfile ${bfile_rare} --score ${esteffLDpred2} 1 2 4 sum --keep ${idxtest} --out ${predLDpred2sp}_rare
# # plink-1.9 --silent --bfile ${bfile_hm3} --score ${esteffLDpred2} 1 2 4 sum --keep ${idxagg} --out ${aggLDpred2sp}_hm3
# # plink-1.9 --silent --bfile ${bfile_rare} --score ${esteffLDpred2} 1 2 4 sum --keep ${idxagg} --out ${aggLDpred2sp}_rare
# plink-1.9 --silent --bfile ${bfile_hm3} --score ${esteffLDpred2} 1 2 5 sum --keep ${idxtest} --out ${predLDpred2nosp}_hm3
# plink-1.9 --silent --bfile ${bfile_rare} --score ${esteffLDpred2} 1 2 5 sum --keep ${idxtest} --out ${predLDpred2nosp}_rare
# # plink-1.9 --silent --bfile ${bfile_hm3} --score ${esteffLDpred2} 1 2 5 sum --keep ${idxagg} --out ${aggLDpred2nosp}_hm3
# # plink-1.9 --silent --bfile ${bfile_rare} --score ${esteffLDpred2} 1 2 5 sum --keep ${idxagg} --out ${aggLDpred2nosp}_rare
# plink-1.9 --silent --bfile ${bfile_hm3} --score ${esteffLDpred2} 1 2 6 sum --keep ${idxtest} --out ${predLDpred2auto}_hm3
# plink-1.9 --silent --bfile ${bfile_rare} --score ${esteffLDpred2} 1 2 6 sum --keep ${idxtest} --out ${predLDpred2auto}_rare
# # plink-1.9 --silent --bfile ${bfile_hm3} --score ${esteffLDpred2} 1 2 6 sum --keep ${idxagg} --out ${aggLDpred2auto}_hm3
# # plink-1.9 --silent --bfile ${bfile_rare} --score ${esteffLDpred2} 1 2 6 sum --keep ${idxagg} --out ${aggLDpred2auto}_rare

# # gzip -f ${esteffLDpred2}
# gzip -f ${predLDpred2inf}_hm3.profile
# gzip -f ${predLDpred2inf}_rare.profile
# gzip -f ${predLDpred2sp}_hm3.profile
# gzip -f ${predLDpred2sp}_rare.profile
# gzip -f ${predLDpred2nosp}_hm3.profile
# gzip -f ${predLDpred2nosp}_rare.profile
# gzip -f ${predLDpred2auto}_hm3.profile
# gzip -f ${predLDpred2auto}_rare.profile
# # gzip -f ${aggLDpred2inf}_hm3.profile
# # gzip -f ${aggLDpred2inf}_rare.profile
# # gzip -f ${aggLDpred2sp}_hm3.profile
# # gzip -f ${aggLDpred2sp}_rare.profile
# # gzip -f ${aggLDpred2nosp}_hm3.profile
# # gzip -f ${aggLDpred2nosp}_rare.profile
# # gzip -f ${aggLDpred2auto}_hm3.profile
# # gzip -f ${aggLDpred2auto}_rare.profile

# rm ${predLDpred2inf}_hm3.log
# rm ${predLDpred2inf}_rare.log
# rm ${predLDpred2sp}_hm3.log
# rm ${predLDpred2sp}_rare.log
# rm ${predLDpred2nosp}_hm3.log
# rm ${predLDpred2nosp}_rare.log
# rm ${predLDpred2auto}_hm3.log
# rm ${predLDpred2auto}_rare.log
# # rm ${aggLDpred2inf}_hm3.log
# # rm ${aggLDpred2inf}_rare.log
# # rm ${aggLDpred2sp}_hm3.log
# # rm ${aggLDpred2sp}_rare.log
# # rm ${aggLDpred2nosp}_hm3.log
# # rm ${aggLDpred2nosp}_rare.log
# # rm ${aggLDpred2auto}_hm3.log
# # rm ${aggLDpred2auto}_rare.log
# rm ${predLDpred2inf}_hm3.nopred
# rm ${predLDpred2inf}_rare.nopred
# rm ${predLDpred2sp}_hm3.nopred
# rm ${predLDpred2sp}_rare.nopred
# rm ${predLDpred2nosp}_hm3.nopred
# rm ${predLDpred2nosp}_rare.nopred
# rm ${predLDpred2auto}_hm3.nopred
# rm ${predLDpred2auto}_rare.nopred
# # rm ${aggLDpred2inf}_hm3.nopred
# # rm ${aggLDpred2inf}_rare.nopred
# # rm ${aggLDpred2sp}_hm3.nopred
# # rm ${aggLDpred2sp}_rare.nopred
# # rm ${aggLDpred2nosp}_hm3.nopred
# # rm ${aggLDpred2nosp}_rare.nopred
# # rm ${aggLDpred2auto}_hm3.nopred
# # rm ${aggLDpred2auto}_rare.nopred


# done
done
} &
pid=$!
echo $pid
done

wait

exec 6>&-

exit 0
