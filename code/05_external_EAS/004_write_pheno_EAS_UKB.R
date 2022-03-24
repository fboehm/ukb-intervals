#! /usr/bin/env Rscript
rm(list=ls())
library(parallel)
library(bigreadr)

load("/net/mulan/disk2/yasheng/comparisonProject/02_pheno/07_pheno_EAS/04_pheno_c_adj.RData")
## output to fam file for cross validation 
fam <- fread2("/net/mulan/disk2/yasheng/predictionProject/plink_file/EAS/hm3/chr22.fam")
#######
fam_pheno <- cbind(fam[, c(1:5)], pheno_c_adj_EAS) # pheno
fam_output <- mclapply(c(1:22), function(chr){
 write.table(fam_pheno, file = paste0("/net/mulan/disk2/yasheng/predictionProject/plink_file/EAS/hm3/chr", chr, ".fam"), 
              col.names = F, row.names = F, quote = F)
  return(chr)
},  mc.cores=10)
