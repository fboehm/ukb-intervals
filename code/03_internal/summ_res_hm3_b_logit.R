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
summPheno <- function(test_pheno, chr_path, test_cov, glm_coef){
  
  require(bigreadr)
  require(pROC)
  pred_tot <- vector()
  for(chr in 1: 22){
    pred_chr_str <- paste0(chr_path, chr, "_logistic.profile.gz")
    if (file.exists(pred_chr_str)){
      pred_chr <- fread2(pred_chr_str, header = T)[, 6]
      pred_tot <- cbind(pred_tot, pred_chr)
    } else {
      cat (paste0("chr:", chr, " fail!\n"))
    }
  }
  pheno_tot <- rowSums(pred_tot) 
  pred_glm <- cbind(cbind(1, pheno_tot), test_cov) %*% glm_coef
  pred <- 1/(1+1/exp(pred_glm))
  
  auc <- as.numeric(roc(test_pheno, pred[, 1], levels = c(0, 1))$auc)
  pr2 <- lrm(test_pheno ~ pred[, 1])$stats["R2"]
  result <- list(auc, pr2)
  return(result)
}

## val function
summPheno_val <- function(valid_pheno, chr_path, val_cov){
  
  require(bigreadr)
  require(Metrics)
  
  pred_tot <- vector()
  for(chr in 1: 22){
    pred_chr_str <- as.character(paste0(chr_path, chr, "_logistic.profile.gz"))
    
    if (file.exists(pred_chr_str)){
      pred_chr <- read.table(pred_chr_str, header = T)[, 6]
      pred_tot <- cbind(pred_tot, pred_chr)
    } else {
      cat (paste0("chr:", chr, " fail!\n"))
    }
  }
  pheno_tot <- rowSums(pred_tot)
  if (all(pheno_tot == 0)){
    glm_coef <- coef(glm(valid_pheno~val_cov, 
                         family = binomial(link = "logit")))
    glm_coef <- c(glm_coef[1], 0, glm_coef[2])
  } else {
    glm_coef <- coef(glm(valid_pheno~pheno_tot+val_cov,
                         family = binomial(link = "logit")))
  }
  return(glm_coef)
}

comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
pheno <- c(1:25)

method <- c("CT", "SCT")
situ <- c("_hm3", "_hm3")
val_pheno <- fread2(paste0("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/binary/pheno",p,
                           "/val/02_pheno_b.txt"))[, 1]
val_cov_eff <- fread2(paste0(comp_str,"03_subsample/binary/pheno",p,
                             "/val/04_cov_eff_glm.txt")) %>% as.matrix()

pr2_mat <- matrix(NA, ncol = length(method), nrow = 5)
auc_mat <- matrix(NA, ncol = length(method), nrow = 5)
pheno_path <- paste0(comp_str, "06_internal_b/")


for (m in c(1:2)){
  
  cat (method[m], "\n")
  for (cross in 1: 5){
    test_pheno <- fread2(paste0(comp_str, "02_pheno/06_test_b/pheno_pheno", 
                                pheno[p], ".txt"), select = cross)[, 1]
    test_pheno_na <- test_pheno[!is.na(test_pheno) ] 
    test_cov_eff <- fread2(paste0(comp_str, "02_pheno/06_test_b/coveff_pheno",p,"_glm.txt"),
                           select = cross)
    test_cov_eff <- test_cov_eff[!is.na(test_cov_eff[,1]),] %>% as.matrix()
    val_chr_path <- paste0(pheno_path, "pheno", pheno[p], "/", method[m], 
                           "/val", situ[m], "_cross", cross, "_chr") 
    chr_path <- paste0(pheno_path, "pheno", pheno[p], "/", method[m], 
                       "/pred", situ[m], "_cross", cross, "_chr") 
    
    glm_coef <- try(summPheno_val(val_pheno, val_chr_path, val_cov_eff), silent = T)
    temp_res <- try(summPheno(test_pheno_na, chr_path, test_cov_eff[, 1], glm_coef), silent = T)
    
    if (inherits(temp_res, "try-error") == F){
      pr2_mat[cross, m] <- temp_res[[2]]
      auc_mat[cross, m] <- temp_res[[1]]
    } 
  }
}

res_list <- list(pr2 = pr2_mat, 
                 auc = auc_mat)
save(res_list, file = paste0(comp_str, "06_internal_b/summRes/res_hm3_b_pheno", p, "_glm.RData"))
