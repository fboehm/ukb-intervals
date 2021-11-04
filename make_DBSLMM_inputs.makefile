SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .rds .R .sh

dat/04_pheno_c_adj.rds : Rscript/02_get_clean_pheno.R /net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData /net/mulan/disk2/yasheng/comparisonProject/02_pheno/02_pheno_c_raw.RData
  Rscript -e '$<'

