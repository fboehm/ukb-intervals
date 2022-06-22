# README.md

Here, we document the tasks achieved by each file in the directory.

## 01_get_raw_pheno.R

Inputs: 

"/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_sqc_v2.txt"
"/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_sqc_v2_head.txt"
"/net/mulan/data/UKB/ukb30186_baf_chr9_v2_s488363.fam"
"/net/mulan/disk2/yasheng/comparisonProject/w30186_20200820.csv"
"/net/mulan/data/UKB/ukb10683.csv"
"/net/mulan/Biobank/rawdata/ukb42224.tab"



Outputs: 

"/net/mulan/disk2/yasheng/comparisonProject/w30186_idx.txt"
"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/02_pheno_c_raw.RData"
"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/03_pheno_b_raw.RData"


## 02_get_clean_pheno.R


Inputs: 

"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData"
"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/02_pheno_c_raw.RData"
"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/03_pheno_b_raw.RData"

Outputs:

"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/04_pheno_c_adj.RData"
"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/05_pheno_b_clean.RData"
"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/07_cov.txt"
"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/08_cov_nosex.txt"


## 03_get_cross_sample.R

Inputs:

"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData"
"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/04_pheno_c_adj.RData"
"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/05_pheno_b_clean.RData"



Outputs:

"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/sample_size_c.txt"
"/net/mulan/disk2/yasheng/comparisonProject/02_pheno/xsample_size_b.txt"


## 04_transformat_plink.sh

Inputs:

/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/brIdx1.txt
/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/brIdx2.txt
/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/ukb_all_info.sample
/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_imp_chr${chr}_v2.bgen
/net/mulan/disk2/yasheng/predictionProject/plink_file/removal_snp_list/chr${chr}.txt
/net/mulan/disk2/yasheng/predictionProject/plink_file/genotype/xchr${chr}
/net/mulan/disk2/yasheng/predictionProject/plink_file/genotype/chr${chr}




Outputs:



## 05_get_subsample.sh

Inputs:

/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/chr${chr}
/net/mulan/disk2/yasheng/comparisonProject/04_reference/01_idx.txt


Outputs:

/net/mulan/disk2/yasheng/comparisonProject/04_reference/ukb/geno/allchr${chr}
/net/mulan/disk2/yasheng/comparisonProject/04_reference/ukb/geno/chr${chr}
/net/mulan/disk2/yasheng/comparisonProject/03_subsample/${dat}/pheno${p}/val_ukb/impute/chr${chr}


## 06_merge_subsample.sh






