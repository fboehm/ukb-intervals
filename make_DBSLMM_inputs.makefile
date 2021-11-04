SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .rds .txt



dat/04_pheno_c_adj.rds : Rscript/02_get_clean_pheno.R /net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData /net/mulan/disk2/yasheng/comparisonProject/02_pheno/02_pheno_c_raw.RData
  Rscript '$<'

dat/03_subsample/01_idx.txt : Rscript/03_get_cross_sample.R /net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData dat/04_pheno_c_adj.rds
  Rscript '$<'


dat/03_subsample/01_idx_female.txt : Rscript/03_get_cross_sample.R /net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData dat/04_pheno_c_adj.rds
  Rscript '$<'


dat/03_subsample/01_idx_male.txt : Rscript/03_get_cross_sample.R /net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData dat/04_pheno_c_adj.rds
  Rscript '$<'


dat/03_subsample/02_pheno_c.txt : Rscript/03_get_cross_sample.R /net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData dat/04_pheno_c_adj.rds
  Rscript '$<'


dat/02_pheno/01_test_idx_c/idx_pheno%.txt : Rscript/03_get_cross_sample.R /net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData dat/04_pheno_c_adj.rds
  Rscript '$<'


dat/02_pheno/02_train_c%.txt :  Rscript/03_get_cross_sample.R /net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData dat/04_pheno_c_adj.rds
  Rscript '$<'


dat/02_pheno/03_test_c%.txt :  Rscript/03_get_cross_sample.R /net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData dat/04_pheno_c_adj.rds
  Rscript '$<'



