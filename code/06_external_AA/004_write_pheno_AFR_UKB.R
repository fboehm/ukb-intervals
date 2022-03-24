#! /usr/bin/env Rscript
rm(list=ls())
library(parallel)
library(bigreadr)

load("/net/mulan/disk2/yasheng/comparisonProject/02_pheno/08_pheno_AA/04_pheno_c_adj.RData")
## output to fam file for cross validation 
fam <- fread2("/net/mulan/disk2/yasheng/predictionProject/plink_file/AA/hm3/chr22.fam")
#######
AA_idx2 <- fread2("/net/mulan/disk2/yasheng/comparisonProject/02_pheno/08_pheno_AA/03_idx_AA1.txt")
pheno_c_adj_AA_sub <- pheno_c_adj_AA[-which(AA_idx2 == 2e+05), ]
fam_pheno <- cbind(fam[, c(1:5)], pheno_c_adj_AA_sub) # pheno

fam_output <- mclapply(c(1:22), function(chr){
 write.table(fam_pheno, file = paste0("/net/mulan/disk2/yasheng/predictionProject/plink_file/AA/hm3/chr", chr, ".fam"), 
              col.names = F, row.names = F, quote = F)
  return(chr)
},  mc.cores=10)
