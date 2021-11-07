SHELL = /bin/sh

BED_FILES := dat/plink_files/genotype/$(wildcard *.bed)


.SUFFIXES:
.SUFFIXES: .rds .txt .bed .fam .bim

.PHONY : all
all : dat/03_subsample/01_idx.txt $(BED_FILES) dat/04_pheno_c_adj.rds 

dat/04_pheno_c_adj.rds : Rscript/02_get_clean_pheno.R /net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData /net/mulan/disk2/yasheng/comparisonProject/02_pheno/02_pheno_c_raw.RData
	Rscript '$<'

dat/03_subsample/01_idx.txt \
dat/03_subsample/01_idx_female.txt \
dat/03_subsample/01_idx_male.txt \
dat/03_subsample/02_pheno_c.txt \
dat/02_pheno/01_test_idx_c/idx_pheno$(wildcard *.txt) \
dat/02_pheno/$(wildcard 02_train_c*.txt) \
dat/02_pheno/$(wildcard 03_test_c*.txt) &: Rscript/03_get_cross_sample.R \
/net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData \
dat/04_pheno_c_adj.rds
	Rscript '$<'


dat/plink_files/genotype/$(wildcard chr*.bed) \
dat/plink_files/genotype/$(wildcard chr*.bim) \
dat/plink_files/genotype/$(wildcard chr*.fam) &: shell_scripts/04_transformat_plink.sh \
/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/ukb_all_info.sample \
/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/brIdx1.txt \
/net/mulan/disk2/yasheng/predictionProject/plink_file/pheno_list/brIdx2.txt 
	sbatch $<



