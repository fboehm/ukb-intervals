#! /usr/bin/env Rscript
rm(list=ls())

library(bigreadr)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
dat = "continuous"
for (p in 2: 25){
  fam_str <- paste0(comp_str, "03_subsample/", dat, "/pheno", p, "/hm3/impute/chr1.fam")
  fam_p <- fread2(fam_str, select = c(1:5))
  pheno_str <- paste0(comp_str, "03_subsample/", dat, "/pheno", p, "/02_pheno_c.txt")
  pheno <- fread2(pheno_str)[, 1]
  fam <- cbind(fam_p, pheno)
  set.seed(20211111)
  sel_idx <- sort(sample(c(1: nrow(fam)), ceiling(nrow(fam)*0.1)))
  fam_sub <- fam[sel_idx, ]
  cat(p, nrow(fam_sub), "\n")
  write.table(fam_sub[, c(1, 2)], row.names = F, col.names = F, quote = F, 
              file = paste0(comp_str, "03_subsample/", dat, "/pheno", 
                            p, "/hm3/dosage/val_idx.txt"))
  write.table(fam_sub, row.names = F, col.names = F, quote = F, 
              file = paste0(comp_str, "03_subsample/", dat, "/pheno", 
                            p, "/hm3/dosage/val.fam"))
}

