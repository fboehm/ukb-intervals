#! /usr/bin/env Rscript
rm(list=ls())
library(parallel)
library(bigreadr)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
pred_str <- "/net/mulan/home/yasheng/predictionProject/"
## output to fam file for cross validation 
pheno_num <- 25
pheno <- matrix(NA, nrow = 337129, ncol = pheno_num*5)
for (p in 1: pheno_num){
  begin <- (p-1)*5+1
  end <- (p-1)*5+5
  pheno_str <- paste0(comp_str, "02_pheno/02_train_c/pheno_pheno", p, ".txt")
  # pheno_str <- paste0(comp_str, "02_pheno/05_train_b/pheno_pheno", p, ".txt")
  pheno[, c(begin:end)] <- as.matrix(fread2(pheno_str))
}
fam <- fread2(paste0(pred_str, "plink_file/ukb/chr22.fam"))
# example
####### return 1
# fam_pheno <- cbind(fam[, c(1:5)], -9)
#######
fam_pheno <- cbind(fam[, c(1:5)], pheno) # pheno
fam_output <- mclapply(c(1:22), function(chr){
  write.table(fam_pheno, file = paste0(pred_str, "plink_file/ukb/chr", chr, ".fam"),
              col.names = F, row.names = F, quote = F)
  # write.table(fam_pheno, file = paste0(pred_str, "plink_file/hm3/chr", chr, ".fam"),
  #             col.names = F, row.names = F, quote = F)
  # write.table(fam_pheno, file = paste0(pred_str, "plink_file/rare/chr", chr, ".fam"),
  #             col.names = F, row.names = F, quote = F)
  return(chr)
},  mc.cores=22)
