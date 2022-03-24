rm(list=ls())
library(plyr)
library(bigreadr)
library(tidyverse)
library(Metrics)
library(optparse)

## Parameter setting
args_list = list(
  make_option("--pheno", type="numeric", default=NULL,
              help="INPUT: phenotype number", metavar="character")
)

opt_parser = OptionParser(option_list=args_list)
opt = parse_args(opt_parser)

p <- opt$pheno

##############################
### summarize the result of validate
##############################
## val function
summPheno <- function(chr_path, type){
  require(bigreadr)
  require(Metrics)
  
  pred_tot <- vector()
  for(chr in 1: 22){
    pred_chr_str <- paste0(chr_path, chr, type, ".profile.gz")
    if (file.exists(pred_chr_str)){
      pred_chr <- fread2(pred_chr_str, header = T)[, 6]
      pred_tot <- cbind(pred_tot, pred_chr)
    } else {
      cat (paste0("chr:", chr, " fail!\n"))
    }
  }
  pheno_tot <- rowSums(pred_tot)
  return(pheno_tot)
}

comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
pheno <- c(1:25)
method <- c("CT", "DBSLMM", "lassosum", 
            "LDpred2", "LDpred2", "LDpred2", "LDpred2", 
            "nps/est", "PRScs", "SbayesR", "sblup", "SCT")
situ <- c("_hm3", "_hm3_best", "_hm3", 
          "_auto_hm3", "_inf_hm3", "_nosp_hm3", "_sp_hm3", 
          "", "", "", "_hm3", "_hm3")
situ2 <- c("", "", "",
           "", "", "", "", 
           "", "_best", "", "", "")
pheno_path <- paste0(comp_str, "05_internal_c/")
agg_pheno <- fread2(paste0(comp_str, "03_subsample/continuous/pheno", p,
                           "/agg/02_pheno_c.txt"))[, 1]
agg_method_pheno <- matrix(NA, length(agg_pheno), 11)
r2_mat <- vector("numeric", 5)
mse_mat <- vector("numeric", 5)

cat("p: ", p, "\n")

for (cross in 1: 5){
# cross=1
  
  ## estimate coefficient of each method
  agg_method_pheno <- plyr::aaply(c(1: length(method)), 1, function(m){
    agg_chr_path <- paste0(pheno_path, "pheno", p, "/", 
                           method[m], "/agg", situ[m], "_cross", cross,"_chr") 
    agg_method <- summPheno(agg_chr_path, situ2[m])
    return(agg_method)
  }) %>% t
  agg_fit_all <- lm(agg_pheno ~ agg_method_pheno) %>% 
    coef %>% as.vector %>% as.matrix(length(method), 1)
  
  #################################################################################
  ## estimate PGSagg effect
  summ_maf <- fread2(paste0(comp_str, "05_internal_c/pheno", p,
                            "/output/summary_hm3_cross", cross, ".assoc.txt"),
                     select = c(2, 6, 8))
  maf_w <- sqrt(2 * summ_maf$V8 * (1-summ_maf$V8))
  esteff_mat <- matrix(0, nrow = nrow(summ_maf), ncol = length(method))

  for (m in 1: length(method)){

    if (method[m] %in% c("CT", "SCT", "lassosum")){

      est_str <- paste0(comp_str, "05_internal_c/pheno", p, "/",
                        method[m], "/esteff_hm3_cross", cross, ".txt")
      est <- fread2(est_str)
      esteff_mat[, m] <- left_join(summ_maf, est, by = c("V2" = "V1"))[, 5]
    }
    if (method[m] == "DBSLMM"){
      est_str <- paste0(comp_str, "05_internal_c/pheno", p, "/",
                        method[m], "/summary_hm3_cross", cross)
      est_l <- alply(c(1: 22), 1, function (chr){
        fread2(paste0(est_str, "_chr", chr, "_best.dbslmm.txt.gz"), select = c(1, 2, 3))
      })
      est <- ldply(est_l, function(a) a)[, -1]
      esteff_mat[, m] <- left_join(summ_maf, est, by = c("V2" = "V1"))[, 5]
    }
    if (method[m] ==  "LDpred2-auto"){
      est_str <- paste0(comp_str, "05_internal_c/pheno", p, "/",
                        "/LDpred2/esteff_hm3_cross", cross)
      est_l <- alply(c(1: 22), 1, function (chr){
        fread2(paste0(est_str, "_chr", chr, ".txt.gz"), select = c(1, 2, 6))
      })
      est <- ldply(est_l, function(a) a)[, -1]
      esteff_mat[, m] <- left_join(summ_maf, est, by = c("V2" = "V1"))[, 5]
    }
    if (method[m] %in%  "LDpred2-inf"){
      est_str <- paste0(comp_str, "05_internal_c/pheno", p, "/",
                        "/LDpred2/esteff_hm3_cross", cross)
      est_l <- alply(c(1: 22), 1, function (chr){
        fread2(paste0(est_str, "_chr", chr, ".txt.gz"), select = c(1, 2, 3))
      })
      est <- ldply(est_l, function(a) a)[, -1]
      esteff_mat[, m] <- left_join(summ_maf, est, by = c("V2" = "V1"))[, 5]
    }
    if (method[m] %in%  "LDpred2-nosp"){
      est_str <- paste0(comp_str, "05_internal_c/pheno", p, "/",
                        "/LDpred2/esteff_hm3_cross", cross)
      est_l <- alply(c(1: 22), 1, function (chr){
        fread2(paste0(est_str, "_chr", chr, ".txt.gz"), select = c(1, 2, 4))
      })
      est <- ldply(est_l, function(a) a)[, -1]
      esteff_mat[, m]  <- left_join(summ_maf, est, by = c("V2" = "V1"))[, 5]
    }
    if (method[m] %in%  "LDpred2-sp"){
      est_str <- paste0(comp_str, "05_internal_c/pheno", p, "/",
                        "/LDpred2/esteff_hm3_cross", cross)
      est_l <- alply(c(1: 22), 1, function (chr){
        fread2(paste0(est_str, "_chr", chr, ".txt.gz"), select = c(1, 2, 5))
      })
      est <- ldply(est_l, function(a) a)[, -1]
      esteff_mat[, m] <- left_join(summ_maf, est, by = c("V2" = "V1"))[, 5]
    }
    if (method[m] == "nps"){
      est_str <- paste0(comp_str, "05_internal_c/pheno", p, "/",
                        method[m], "/esteff_cross", cross)
      est_l <- alply(c(1: 22), 1, function (chr){
        fread2(paste0(est_str, "_chr", chr, ".txt.gz"))
      })
      est <- ldply(est_l, function(a) a)[, -1]
      esteff_mat[, m] <- left_join(summ_maf, est, by = c("V2" = "V1"))[, 5]
    }
    if (method[m] == "PRScs"){
      est_str <- paste0(comp_str,  "05_internal_c/pheno", p, "/",
                        method[m], "/esteff_cross", cross)
      est_l <- alply(c(1: 22), 1, function (chr){
        fread2(paste0(est_str, "_chr", chr, "_best.txt.gz"), select = c(2, 4, 6))
      })
      est <- ldply(est_l, function(a) a)[, -1]
      esteff_mat[, m] <- left_join(summ_maf, est, by = c("V2" = "V2"))[, 5]
    }
    if (method[m] == "SbayesR"){
      est_str <- paste0(comp_str, "05_internal_c/pheno", p, "/",
                        method[m], "/esteff_cross", cross)
      est_l <- alply(c(1: 22), 1, function (chr){
        fread2(paste0(est_str, "_chr", chr, ".snpRes.gz"), select = c(2, 5, 8))
      })
      est <- ldply(est_l, function(a) a)[, -1]
      esteff_mat[, m] <- left_join(summ_maf, est, by = c("V2" = "Name"))[, 5]
    }
    if (method[m] == "sblup"){
      est_str <- paste0(comp_str, "05_internal_c/pheno", p, "/",
                        method[m], "/esteff_hm3_cross", cross)
      est_l <- alply(c(1: 22), 1, function (chr){
        fread2(paste0(est_str, "_chr", chr, ".sblup.cojo.gz"), select = c(1, 2, 3))
      })
      est <- ldply(est_l, function(a) a)[, -1]
      esteff_mat[, m] <- left_join(summ_maf, est, by = c("V2" = "V1"))[, 5]
    }
  }
  esteff_mat_z <- apply(esteff_mat, 2, function(a) ifelse(is.na(a), 0, a))
  agg_esteff <- data.frame(snp = summ_maf[, 1],
                           allele = summ_maf[, 2],
                           eff = esteff_mat_z %*% agg_fit_all[-1],
                           effstd = esteff_mat_z %*% agg_fit_all[-1] * maf_w)
  write.table(agg_esteff, file = paste0(comp_str, "05_internal_c/pheno",
                                        p, "/bagging/esteff_cross", cross, ".txt"),
              row.names = F, col.names = F, quote = F)
  system(paste0("gzip ", comp_str, "05_internal_c/pheno",
                p, "/bagging/esteff_cross", cross, ".txt"))
  ##############################################################################

  
  ##############################################################################
  ## estimate the r2 and mse
  # test_pheno <- fread2(paste0(comp_str, "02_pheno/03_test_c/pheno_pheno", p, ".txt"),
  #                      select = cross)[, 1]
  # test_pheno_na <- test_pheno[!is.na(test_pheno)]
  # pred_method_pheno <- vector()
  # for (m in 1: length(method)){
  #   # cat("test: ", method[m], "\n")
  #   pred_chr_path <- paste0(pheno_path, "pheno", p, "/",
  #                           method[m], "/pred", situ[m], "_cross", cross,
  #                           "_chr")
  #   pred_method_pheno_tmp <- summPheno(pred_chr_path, situ2[m])
  #   pred_method_pheno <- cbind(pred_method_pheno, pred_method_pheno_tmp)
  # }
  # pred_pheno <- cbind(1, pred_method_pheno) %*% agg_fit_all
  # r2_mat[cross] <- cor(test_pheno_na, pred_pheno)^2
  # mse_mat[cross] <- mse(test_pheno_na, pred_pheno)
  ##############################################################################
  cat("cross: ", cross, "\n")
}

# save(agg_fit_all, r2_mat, mse_mat, file = paste0(comp_str, "05_internal_c/pheno", p, "/bagging/res_mat_hm3.RData"))
