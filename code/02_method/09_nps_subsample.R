
library(bigreadr)
library(tidyverse)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"

for (p in 1: 25){
  idx <- fread2(paste0(comp_str, "03_subsample/continuous/pheno", p, 
                       "/val/01_idx.txt"))
  pheno <- fread2(paste0(comp_str, "03_subsample/continuous/pheno", p, 
                         "/val/02_pheno_c.txt"))
  fam <- fread2(paste0(comp_str, "03_subsample/continuous/pheno", p, 
                       "/val/impute_inter/chr1.fam"))
  set.seed(2000+p)
  subsample_idx <- sample(c(1: nrow(pheno)), size = 1000, replace = F) %>% sort
  
  write.table(idx[subsample_idx, ], row.names = F, col.names = F, quote = F, 
              file = paste0(comp_str, "03_subsample/continuous/pheno", p, 
                            "/val/dosage/val_idx.txt"))
  write.table(cbind(fam[subsample_idx, c(1:5)], pheno[subsample_idx, 1]), 
              row.names = F, col.names = F, quote = F, 
              file = paste0(comp_str, "03_subsample/continuous/pheno", p, 
                            "/val/dosage/val.fam"))
}

library(bigreadr)
library(tidyverse)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"

for (p in 1: 25){
  idx <- fread2(paste0(comp_str, "03_subsample/binary/pheno", p, 
                       "/val/01_idx.txt"))
  pheno <- fread2(paste0(comp_str, "03_subsample/binary/pheno", p, 
                         "/val/02_pheno_b.txt"))[, 1]
  prev <- sum(pheno) / length(pheno) 
  idx_case <- idx[pheno == 1, 1]
  idx_control <- idx[pheno == 0, 1]
  fam <- fread2(paste0(comp_str, "03_subsample/binary/pheno", p, 
                       "/val/impute_inter/chr1.fam"))
  set.seed(2000+p)
  idx_subcase <- sample(idx_case, size = ceiling(prev*1000), replace = F) 
  idx_subcontrol <- sample(idx_control, size = floor((1-prev)*1000), replace = F) 
  
  
  
  subsample_idx <- c(idx_subcase, idx_subcontrol)%>% sort
  
  write.table(cbind(subsample_idx, subsample_idx), row.names = F, col.names = F, quote = F, 
              file = paste0(comp_str, "03_subsample/binary/pheno", p, 
                            "/val/dosage/val_idx.txt"))
  write.table(cbind(fam[idx[, 1] %in% subsample_idx, c(1:5)], pheno[idx[, 1] %in% subsample_idx]), 
              row.names = F, col.names = F, quote = F, 
              file = paste0(comp_str, "03_subsample/binary/pheno", p, 
                            "/val/dosage/val.fam"))
}