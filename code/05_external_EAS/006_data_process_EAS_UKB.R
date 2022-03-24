rm(list=ls())
library(bigreadr)
setwd("/net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/")

dat <- fread2("/net/mulan/disk2/yasheng/comparisonProject/code/05_external_EAS/dat.txt")[-c(1:17), 1]
for (p in 1: 25){
  summ <- fread2(paste0("./01_raw/output/pheno", p, ".assoc.txt"))
  summ_herit <- data.frame(SNP = summ[,2],
                           N = summ[,4]+summ[,5],
                           Z = summ[,9]/summ[,10],
                           A1 = summ[,6],
                           A2 = summ[,7])
  summ_val <- data.frame(SNP = summ[, 2], 
                         A1 = summ[, 6], 
                         beta = summ[, 9] * sqrt(2*summ[, 8]*(1-summ[,8])))
  write.table(summ_val, file = paste0("./02_clean/pheno", p, "_data", dat[p], "_val.txt"), 
              row.names = F, quote = F)
  write.table(summ_herit, file = paste0("./02_clean/pheno", p, "_data", dat[p], "_herit.ldsc"), 
              row.names = F, quote = F)
  system(paste0("gzip /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno", p, "_data", dat[p], "_val.txt"))
  system(paste0("gzip /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno", p, "_data", dat[p], "_herit.ldsc"))
}

