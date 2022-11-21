#! /usr/bin/env Rscript
rm(list=ls())
library(parallel)
library(bigreadr)
trait_type <- "binary"
comp_str <- "~/research/ukb-intervals/"
pred_str <- "/net/mulan/disk2/yasheng/predictionProject/"
## output to fam file for cross validation 
pheno_num <- 25
pheno <- matrix(NA, nrow = 337129, ncol = pheno_num*5)
for (p in 1: pheno_num){
  begin <- (p-1)*5+1
  end <- (p-1)*5+5
  if (trait_type == "continuous") {
    pheno_str <- paste0(comp_str, "02_pheno/02_train_c/pheno_pheno", p, ".txt")
  } else {
    pheno_str <- paste0(comp_str, "02_pheno/05_train_b/pheno_pheno", p, ".txt")
  }
  pheno[, c(begin:end)] <- as.matrix(fread2(pheno_str))
}
fam <- readr::read_table(paste0(pred_str, "plink_file/ukb/chr22.fam"), col_names = FALSE)
# example
####### return 1
# fam_pheno <- cbind(fam[, c(1:5)], -9)
#######
fam_pheno <- cbind(fam[, c(1:5)], pheno) # pheno
write.table(fam_pheno, 
              file = paste0(comp_str, 
                            "plink_file/ukb/", 
                            trait_type, 
                            "/chr", 
                            1, 
                            ".fam"),
              col.names = F, 
              row.names = F, 
              quote = F
              )
