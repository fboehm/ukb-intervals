#!/bin/bash
rm(list=ls())
library(bigreadr)
library(plyr)
library(dplyr)
library(optparse)

## Parameter setting
args_list <- list(
  make_option("--pheno", type = "numeric", default = NULL,
              help = "INPUT: pheno number", metavar = "character"),
  make_option("--cross", type = "numeric", default = NULL,
              help = "INPUT: cross number", metavar = "character"),
  make_option("--data", type = "numeric", default = NULL,
              help = "INPUT: data number", metavar = "character"),
  make_option("--method", type = "character", default = NULL,
              help = "INPUT: method", metavar = "character"))
opt_parser <- OptionParser(option_list=args_list)
opt <- parse_args(opt_parser)

# opt <- list(pheno = 1,
#             data = 1,
#             cross = 1,
#             method = "bagging")

cat(opt$pheno, "\n")
cat(opt$data, "\n")
cat(opt$cross, "\n")
cat(opt$method, "\n")

est_chr_r2 <- function(summ_dat, est_dat, chr){
  
  require(plyr)
  comp_str <- "/net/mulan/home/yasheng/comparisonProject/"
  load(paste0(comp_str, "09_external_LD/EUR/LD_mat", opt$cross, "/chr", chr, ".RData"))
  r2_chr <- matrix(NA, length(LD_list), 2)
  count <- 0
  for (b in 1: length(LD_list)){
    summ_dat <- summ_dat[!is.na(summ_dat[, 3]), ]
    est_dat <- est_dat[!is.na(est_dat[, 3]), ]
    snp_inter <- Reduce(intersect, list(summ_dat[, 1], est_dat[, 1],
                                        LD_list[[b]][2][[1]]))
    if (length(snp_inter) == 0){
    
      r2_chr[b, 1] <- r2_chr[b, 2] <- NA
    } else {
    
      summ_inter <- summ_dat[match(snp_inter, summ_dat[, 1]), ]
      est_inter <- est_dat[match(snp_inter, est_dat[, 1]), ]
      summ_inter[, 3] <- ifelse(summ_inter[, 2] == est_inter[, 2], 
                                summ_inter[, 3], -summ_inter[, 3])
      
      LD_inter <- LD_list[[b]][1][[1]][match(snp_inter, LD_list[[b]][2][[1]]), 
                                       match(snp_inter, LD_list[[b]][2][[1]])]
      r2_chr[b, 1] <- as.numeric(t(summ_inter[, 3]) %*% est_inter$beta)
      r2_chr[b, 2] <- as.numeric(t(est_inter$beta) %*% LD_inter %*% est_inter$beta)
    }
    # cat("chr ", chr, " block ", b, r2_chr[b, 1], "\n")
    if(r2_chr[b, 1] < 0 & is.na(r2_chr[b, 1]) == FALSE){
      count <- count + 1
    }
    
  }
  # cat(chr, "count: ", count, " blocks are smaller than 0.\n")
  return(r2_chr)
}

comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
summ <- fread2(paste0(comp_str, "07_external_c/02_EUR/02_clean/pheno", opt$pheno,
                      "_data", opt$data, "_val.txt.gz"))

r2_list <- list()

for (chr in 1: 22){
  summ_maf <- fread2(paste0(comp_str, "05_internal_c/pheno", opt$pheno,
                            "/output/summary_hm3_cross",
                            opt$cross, "_chr", chr, ".assoc.txt"),
                     select = c(2, 8))
  if (opt$method %in% c("CT", "SCT", "lassosum")){
    library(dplyr)
    est_str <- paste0(comp_str, "05_internal_c/pheno", opt$pheno,
                      "/", opt$method, "/esteff_hm3_cross", opt$cross, ".txt")
    est <- fread2(est_str)
    est <- inner_join(est, summ_maf, by = c("V1" = "V2"))
    est2 <- data.frame(SNP = est[, 1], EA = est[, 2], 
                       beta = est[, 3] * sqrt(2 * est$V8 * (1-est$V8)))
    out_str <- paste0(comp_str, "07_external_c/02_EUR/03_res//pheno", opt$pheno,
                      "_data", opt$data, "/", opt$method, "/val_r2_cross", opt$cross, ".txt")
  }
  if (opt$method == "bagging"){
    library(dplyr)
    est_str <- paste0(comp_str, "05_internal_c/pheno", opt$pheno,
                      "/", opt$method, "/esteff_cross", opt$cross, ".txt")
    est <- fread2(est_str)
    est <- inner_join(est, summ_maf, by = c("V1" = "V2"))
    est2 <- data.frame(SNP = est[, 1], EA = est[, 2], 
                       beta = est[, 3] * sqrt(2 * est$V8 * (1-est$V8)))
    out_str <- paste0(comp_str, "07_external_c/02_EUR/03_res//pheno", opt$pheno,
                      "_data", opt$data, "/", opt$method, "/val_r2_cross", opt$cross, ".txt")
  }
  
  if (opt$method == "DBSLMM"){
    est_str <- paste0(comp_str, "05_internal_c/pheno", opt$pheno,
                      "/DBSLMM/summary_hm3_cross", opt$cross, "_chr", chr, "_best.dbslmm.txt")
    est <- fread2(est_str)
    est2 <- data.frame(SNP = est[, 1], EA = est[, 2], 
                       beta = est[, 3])
    out_str <- paste0(comp_str, "07_external_c/02_EUR/03_res/pheno", opt$pheno,
                      "_data", opt$data, "/DBSLMM/val_r2_cross", opt$cross, ".txt")
  }
  if (opt$method == "nps"){
    est_str <- paste0(comp_str, "05_internal_c/pheno", opt$pheno,
                      "/nps/est/esteff_cross", opt$cross, "_chr", chr, ".txt.gz")
    est <- fread2(est_str)
    est <- inner_join(est, summ_maf, by = c("V1" = "V2"))
    est2 <- data.frame(SNP = est[, 1], EA = est[, 2], 
                       beta = est[, 3] * sqrt(2 * est$V8 * (1-est$V8)))
    out_str <- paste0(comp_str, "07_external_c/02_EUR/03_res/pheno", opt$pheno,
                      "_data", opt$data, "/", opt$method, "/val_r2_cross", opt$cross, ".txt")
  }
  if (opt$method == "sblup"){
    est_str <- paste0(comp_str, "05_internal_c/pheno", opt$pheno,
                      "/", opt$method, "/esteff_hm3_cross", opt$cross, "_chr", chr, ".sblup.cojo.gz")
    est <- fread2(est_str)
    est <- merge(est, summ_maf, by.x = "V1", by.y = "V2")
    est2 <- data.frame(SNP = est[, 1], EA = est[, 2], 
                       beta = est[, 4] * sqrt(2 * est$V8 * (1-est$V8)))
    out_str <- paste0(comp_str, "07_external_c/02_EUR/03_res/pheno", opt$pheno,
                      "_data", opt$data, "/", opt$method, "/val_r2_cross", opt$cross, ".txt")
  }
  if (opt$method == "SbayesR"){
    est_str <- paste0(comp_str, "05_internal_c/pheno", opt$pheno,
                       "/", opt$method, "/esteff_cross", opt$cross, "_chr", chr, ".snpRes.gz")
    est <- fread2(est_str)
    est2 <- data.frame(SNP = est$Name, EA = est$A1, 
                       beta = est$A1Effect * sqrt(2 * est$A1Frq * (1-est$A1Frq)))
    out_str <- paste0(comp_str, "07_external_c/02_EUR/03_res/pheno", opt$pheno,
                      "_data", opt$data, "/", opt$method, "/val_r2_cross", opt$cross, ".txt")
  }
  if (opt$method == "PRScs"){
    est_str <- paste0(comp_str, "05_internal_c/pheno", opt$pheno,
                      "/PRScs/esteff_cross", opt$cross, "_chr", chr, "_best.txt.gz")
    est <- fread2(est_str)
    est <- merge(est, summ_maf, by.x = "V2", by.y = "V2")
    est2 <- data.frame(SNP = est[, 1], EA = est[, 4], 
                       beta = est[, 6] * sqrt(2 * est$V8 * (1-est$V8)))
    out_str <- paste0(comp_str, "07_external_c/02_EUR/03_res/pheno", opt$pheno,
                      "_data", opt$data, "/PRScs/val_r2_cross", opt$cross, ".txt")
  }
  if (opt$method %in%  "auto"){
    est_str <- paste0(comp_str, "05_internal_c/pheno", opt$pheno,
                      "/LDpred2/esteff_hm3_cross", opt$cross, "_chr", chr, ".txt.gz")
    est <- fread2(est_str, select = c(1, 2, 6))
    est <- merge(est, summ_maf, by.x = "V1", by.y = "V2")
    est2 <- data.frame(SNP = est$V1, EA = est$V2, 
                       beta = est$V6 * sqrt(2 * est$V8 * (1-est$V8)))
    out_str <- paste0(comp_str, "07_external_c/02_EUR/03_res/pheno", opt$pheno,
                      "_data", opt$data, "/LDpred2/val_auto_r2_cross", opt$cross, ".txt")
  }
  if (opt$method %in%  "inf"){
    est_str <- paste0(comp_str, "05_internal_c/pheno", opt$pheno,
                      "/LDpred2/esteff_hm3_cross", opt$cross, "_chr", chr, ".txt.gz")
    est <- fread2(est_str, select = c(1, 2, 3))
    est <- merge(est, summ_maf, by.x = "V1", by.y = "V2")
    est2 <- data.frame(SNP = est$V1, EA = est$V2, 
                       beta = est$V3 * sqrt(2 * est$V8 * (1-est$V8)))
    out_str <- paste0(comp_str, "07_external_c/02_EUR/03_res/pheno", opt$pheno,
                      "_data", opt$data, "/LDpred2/val_inf_r2_cross", opt$cross, ".txt")
  }
  if (opt$method %in%  "nosp"){
    est_str <- paste0(comp_str, "05_internal_c/pheno", opt$pheno,
                      "/LDpred2/esteff_hm3_cross", opt$cross, "_chr", chr, ".txt.gz")
    est <- fread2(est_str, select = c(1, 2, 4))
    est <- merge(est, summ_maf, by.x = "V1", by.y = "V2")
    est2 <- data.frame(SNP = est$V1, EA = est$V2, 
                       beta = est$V4 * sqrt(2 * est$V8 * (1-est$V8)))
    out_str <- paste0(comp_str, "07_external_c/02_EUR/03_res/pheno", opt$pheno,
                      "_data", opt$data, "/LDpred2/val_nosp_r2_cross", opt$cross, ".txt")
  }
  if (opt$method %in%  "sp"){
    est_str <- paste0(comp_str, "05_internal_c/pheno", opt$pheno,
                      "/LDpred2/esteff_hm3_cross", opt$cross, "_chr", chr, ".txt.gz")
    est <- fread2(est_str, select = c(1, 2, 5))
    est <- merge(est, summ_maf, by.x = "V1", by.y = "V2")
    est2 <- data.frame(SNP = est$V1, EA = est$V2, 
                       beta = est$V5 * sqrt(2 * est$V8 * (1-est$V8)))
    out_str <- paste0(comp_str, "07_external_c/02_EUR/03_res/pheno", opt$pheno,
                      "_data", opt$data, "/LDpred2/val_sp_r2_cross", opt$cross, ".txt")
  }
  r2_list[[chr]] <- est_chr_r2(summ_dat = summ, est_dat = est2, chr = chr)
  cat("chr", chr, "is finished.\n")
}

r2_dat <- ldply(r2_list, function (a) a)
r2 <- sum(r2_dat[, 1], na.rm = T)^2 / sum(r2_dat[, 2], na.rm = T)
cat("r2: ", r2, "\n")
write.table(r2, file = out_str, row.names = F, 
            col.names = F, quote = F)
