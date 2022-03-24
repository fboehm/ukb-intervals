rm(list=ls())
library(plyr)
library(bigreadr)
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
# p=1
##############################
### summarize the result of validate
##############################
## summ function
summPheno <- function(test_pheno, chr_path, lm_coef, type){
  
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
  pred <- cbind(1, pheno_tot) %*% lm_coef
  r2 <- cor(test_pheno, pred[, 1])^2
  mse <- mse(test_pheno, pred[, 1])
  result <- list(r2, mse)
  return(result)
}

## val function
summPheno_val <- function(valid_pheno, chr_path, type){
  require(bigreadr)
  require(Metrics)
  
  pred_tot <- vector()
  for(chr in 1: 22){
    pred_chr_str <- as.character(paste0(chr_path, chr, type, ".profile.gz"))
    
    if (file.exists(pred_chr_str)){
      pred_chr <- read.table(pred_chr_str, header = T)[, 6]
      # cat(summary(pred_chr), "\n")
      pred_tot <- cbind(pred_tot, pred_chr)
    } else {
      cat (paste0("chr:", chr, " fail!\n"))
    }
  }
  pheno_tot <- rowSums(pred_tot)
  lm_coef <- coef(lm(valid_pheno~pheno_tot))
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
val_pheno <- fread2(paste0("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/continuous/pheno",p,
                           "/val/02_pheno_c.txt"))[, 1]
r2_mat <- matrix(NA, ncol = length(method), nrow = 5)
mse_mat <- matrix(NA, ncol = length(method), nrow = 5)
pheno_path <- paste0(comp_str, "05_internal_c/")

for (m in 1: length(method)){
  cat (method[m], "\n")
  for (cross in 1: 5){

    test_pheno <- fread2(paste0(comp_str, "02_pheno/03_test_c/pheno_pheno", 
                                 pheno[p], ".txt"), select = cross)[, 1]
    test_pheno_na <- test_pheno[!is.na(test_pheno)]

    val_chr_path <- paste0(pheno_path, "pheno", pheno[p], "/", method[m], 
                           "/val", situ[m], "_cross", cross, "_chr") 
    chr_path <- paste0(pheno_path, "pheno", pheno[p], "/", method[m], 
                       "/pred", situ[m], "_cross", cross, "_chr") 
      
    lm_coef <- try(summPheno_val(val_pheno, val_chr_path, situ2[m]), silent = T)
    temp_res <- try(summPheno(test_pheno_na, chr_path, lm_coef, situ2[m]), silent = T)
    

    if (inherits(temp_res, "try-error") == F){
      r2_mat[cross, m] <- temp_res[[1]]
      mse_mat[cross, m] <- temp_res[[2]]
    }
  }
}

# load(paste0(comp_str, "05_internal_c/summRes/res_hm3_c_pheno", p, ".RData"))
# save(res_list, file = paste0(comp_str, "05_internal_c/summRes/res_hm3_c_pheno", p, "_old.RData"))
# res_list[[1]][,3] <- r2_mat[,3]
# res_list[[2]][,3] <- mse_mat[,3]
res_list <- list(r2 = r2_mat,
                 mse = mse_mat)
save(res_list, file = paste0(comp_str, "05_internal_c/summRes/res_hm3_c_pheno", p, ".RData"))
