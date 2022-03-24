#! /usr/bin/env Rscript

rm(list=ls())
library(plyr)

comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
dat <- read.table(paste0(comp_str, "code/04_external/dat.txt"))
pheno <- read.table(paste0(comp_str, "code/04_external/pheno.txt"))
herit_dat <- matrix(NA, 28, 2)
for (cc in 1: nrow(pheno)){
  pp <- pheno[cc, 1]
  dd <- dat[cc, 1]
  
  herit_tmp <- read.delim(paste0(comp_str, "07_external_c/02_EUR/03_res/pheno", 
                                 pp, "_data", dd, "/herit.log"))
  herit_dat[cc, 1] <- as.numeric(strsplit(strsplit(as.character(herit_tmp[24,1]), ":")[[1]][2], "\\(")[[1]][1])
  herit_dat[cc, 2] <- as.numeric(strsplit(as.character(herit_tmp[25,1]), ":")[[1]][2])
}
write.csv(herit_dat, file = "/net/mulan/disk2/yasheng/comparisonProject/code/04_external/herit.csv", 
          row.names = F, quote = F)