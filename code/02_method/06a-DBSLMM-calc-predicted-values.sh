
for chr in `seq 1 22`;do
{
#for p in `seq 14 25`; do
for p in 1; do
#for cross in 1 2 3 4 5; do
for cross in 1; do
#bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/hm3/chr${chr}
bfile=/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/chr${chr}
#idxtest=${compstr1}02_pheno/01_test_idx_c/idx_pheno${p}_cross${cross}.txt
idxtest=~/research/ukb-intervals/test_index_files/test_indices_pheno_1_cross_1_ntest1000.txt
#esteffdbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/summary_hm3_cross${cross}_chr${chr}_best.dbslmm.txt
esteffdbslmmt=~/research/ukb-intervals/results/pheno1/summary_ukb_cross${cross}_chr${chr}_auto.dbslmm.txt
#preddbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/pred_hm3_best_cross${cross}_chr${chr}
preddbslmmt=~/research/ukb-intervals/results/pheno1/predicted_ukb_cross${cross}_chr${chr}_auto.dbslmm.txt
# aggdbslmmt=${compstr}05_internal_c/pheno${p}/DBSLMM/agg_hm3_best_cross${cross}_chr${chr}
#gunzip ${esteffdbslmmt}.gz
plink-1.9 --silent --bfile ${bfile} --score ${esteffdbslmmt} 1 2 4 sum --keep ${idxtest} --out ${preddbslmmt}
done
done
} 
pid=$!
echo $pid
done
