rm(list=ls())
library(plyr)
library(bigreadr)
require(pROC)
require(rms)
library(optparse)
library(dplyr)
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
## summ function
summPheno <- function(test_pheno, chr_path, test_cov, lm_coef, type){

  require(bigreadr)
  require(pROC)
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
  pred <- cbind(cbind(1, pheno_tot), test_cov) %*% lm_coef
  auc <- as.numeric(roc(test_pheno, pred[, 1], levels = c(0, 1))$auc)
  pr2 <- lrm(test_pheno ~ pred[, 1])$stats["R2"]
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

pheno <- c(1:25)

method <- c("CT", "DBSLMM", "DBSLMM", "lassosum",
            "LDpred2", "LDpred2", "LDpred2", "LDpred2", 
            "nps/est", "PRScs", "PRScs", "SbayesR", "sblup", "SCT")
situ <- c("_hm3", "_hm3", "_hm3_best", "_hm3", 
          "_auto_hm3", "_inf_hm3", "_nosp_hm3", "_sp_hm3", 
          "", "", "", "", "_hm3", "_hm3")
situ2 <- c("", "_auto", "", "",
           "", "", "", "", 
           "", "_auto", "_best", "", "", "")
val_pheno <- fread2(paste0("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/binary/pheno",p,
                           "/val/02_pheno_b.txt"))[, 1]
val_cov_eff <- fread2(paste0(comp_str,"03_subsample/binary/pheno",p,
                             "/val/03_cov_eff.txt")) %>% as.matrix()

pr2_mat <- matrix(NA, ncol = length(method), nrow = 5)
auc_mat <- matrix(NA, ncol = length(method), nrow = 5)
pheno_path <- paste0(comp_str, "06_internal_b/")


for (m in 1: length(method)){

  cat (method[m], "\n")
  for (cross in 1: 5){
    test_pheno <- fread2(paste0(comp_str, "02_pheno/06_test_b/pheno_pheno", 
                                pheno[p], ".txt"), select = cross)[, 1]
    test_pheno_na <- test_pheno[!is.na(test_pheno) ] 
    test_cov_eff <- fread2(paste0(comp_str, "02_pheno/06_test_b/coveff_pheno",p,".txt"),
                          select = cross)
    test_cov_eff <- test_cov_eff[!is.na(test_cov_eff[,1]),] %>% as.matrix()
    val_chr_path <- paste0(pheno_path, "pheno", pheno[p], "/", method[m], 
                           "/val", situ[m], "_cross", cross, "_chr") 
    chr_path <- paste0(pheno_path, "pheno", pheno[p], "/", method[m], 
                       "/pred", situ[m], "_cross", cross, "_chr") 
    
    lm_coef <- try(summPheno_val(val_pheno, val_chr_path, val_cov_eff, situ2[m]), silent = T)
    temp_res <- try(summPheno(test_pheno_na, chr_path, test_cov_eff[, 1], lm_coef, situ2[m]), silent = T)
      
    if (inherits(temp_res, "try-error") == F){
      pr2_mat[cross, m] <- temp_res[[2]]
      auc_mat[cross, m] <- temp_res[[1]]
    } 
  }
}

# load(paste0(comp_str, "06_internal_b/summRes/res_hm3_b_pheno", p, ".RData"))
# save(res_list, file = paste0(comp_str, "06_internal_b/summRes/res_hm3_b_pheno", p, "_old.RData"))
# res_list[[1]][,3] <- pr2_mat[,3]
# res_list[[2]][,3] <- auc_mat[,3]

res_list <- list(pr2 = pr2_mat, auc = auc_mat)
save(res_list, file = paste0(comp_str, "06_internal_b/summRes/res_hm3_b_pheno", p, ".RData"))
