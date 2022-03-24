rm(list=ls())
library(bigreadr)
library(pROC)
library(dplyr)
library(rms)
library(optparse)

## Parameter setting
args_list = list(
  make_option("--pheno", type="numeric", default=NULL,
              help="INPUT: phenotype number", metavar="character")
)
opt_parser = OptionParser(option_list=args_list)
opt = parse_args(opt_parser)

p = opt$pheno

##############################
### summarize the result of validate
##############################
## summ function
summPheno <- function(chr_path, test_cov, lm_coef, type){
  
  require(bigreadr)
  require(pROC)
  test_pheno <- pheno_b_EAS_all[, p]
  test_pheno_na <- test_pheno[!is.na(test_pheno)]
  
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
  pheno_tot_na <- pheno_tot[!is.na(test_pheno)]
  test_cov_na <- test_cov[!is.na(test_pheno)]
  pred <- cbind(cbind(1, pheno_tot_na), test_cov_na) %*% lm_coef
  auc <- as.numeric(roc(test_pheno_na, pred[,1], levels = c(0, 1))$auc)
  pr2 <- as.numeric(lrm(test_pheno_na ~ pred[,1])$stats["R2"])
  result <- list(auc, pr2)
  return(result)
}

## val function
summPheno_val <- function(valid_pheno, chr_path, val_cov, type){
  
  require(bigreadr)
  require(Metrics)
  
  pred_tot <- vector()
  for(chr in 1: 22){
    pred_chr_str <- as.character(paste0(chr_path, chr, type, ".profile.gz"))
    
    if (file.exists(pred_chr_str)){
      pred_chr <- read.table(pred_chr_str, header = T)[, 6]
      pred_tot <- cbind(pred_tot, pred_chr)
    } else {
      cat (paste0("chr:", chr, " fail!\n"))
    }
  }
  pheno_tot <- rowSums(pred_tot)
  if (all(pheno_tot == 0)){
    lm_coef <- coef(lm(valid_pheno~val_cov))
    lm_coef <- c(lm_coef[1], 0, lm_coef[2])
  } else {
    lm_coef <- coef(lm(valid_pheno~pheno_tot+val_cov))
  }
  return(lm_coef)
}

comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
val_pheno <- fread2(paste0(comp_str, "03_subsample/binary/pheno",p,
                           "/val/02_pheno_b.txt"))[, 1]
val_cov_eff <- fread2(paste0(comp_str,"03_subsample/binary/pheno",p,
                             "/val/03_cov_eff.txt")) %>% as.matrix()
load(paste0(comp_str, "02_pheno/07_pheno_EAS/05_pheno_b_clean.RData"))
test_pheno <- pheno_b_EAS_all[, p]
test_cov_eff <- fread2(paste0(comp_str, "02_pheno/07_pheno_EAS/coveff_pheno", p, ".txt"))[, 1]

method <- c("CT", "DBSLMM", "lassosum",
            "LDpred2", "LDpred2", "LDpred2", "LDpred2",
            "nps", "PRScs", "SbayesR", "sblup", "SCT", "bagging")
method2 <- c("CT", "DBSLMM", "lassosum",
             "LDpred2", "LDpred2", "LDpred2", "LDpred2",
             "nps/est", "PRScs", "SbayesR", "sblup", "SCT", "bagging")
situ <- c("_hm3", "_hm3_best", "_hm3", 
          "_auto_hm3", "_inf_hm3", "_nosp_hm3", "_sp_hm3", 
          "", "", "", "_hm3", "_hm3", "")
situ2 <- c("", "", "",
           "", "", "", "", 
           "", "_best", "", "", "", "")

pheno_path1 <- paste0(comp_str, "07_external_c/03_EAS/03_res/binary/")
pheno_path2 <- paste0(comp_str, "06_internal_b/")
auc_mat <- matrix(NA, ncol = length(method), nrow = 5)

for (m in 1: 13){

  cat (method[m], "\n")
  for(cross in 1:5){

    chr_path <- paste0(pheno_path1, "pheno", p, "_data1/", method[m], 
                         "/pred", situ[m], "_cross", cross, "_chr") 
    val_chr_path <- paste0(pheno_path2, "pheno", p, "/", method2[m], 
                           "/val", situ[m], "_cross", cross, "_chr") 
    lm_coef <- try(summPheno_val(val_pheno, val_chr_path,
                                 val_cov_eff, situ2[m]), silent = T)
    temp_res <- try(summPheno(chr_path, test_cov_eff, 
                              lm_coef, situ2[m]), silent = T)
    
    if (inherits(temp_res, "try-error") == F){
      auc_mat[cross, m] <- temp_res[[1]]
    }
  }
}
save(auc_mat, file = paste0(comp_str, "07_external_c/03_EAS/04_summ_res/res_hm3_b_pheno",
                            p, "_dat1.RData"))
