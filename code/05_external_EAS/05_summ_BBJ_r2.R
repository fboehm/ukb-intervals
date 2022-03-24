rm(list=ls())
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
ext_pheno <- read.table(paste0(comp_str, "code/05_external_EAS/pheno.txt"))[, 1]
ext_dat <- read.table(paste0(comp_str, "code/05_external_EAS/dat.txt"))[, 1]
method <- c("CT",  "DBSLMM", "lassosum",
            "LDpred2", "LDpred2", "LDpred2", "LDpred2", 
            "nps", "PRScs", "SbayesR", "sblup", "SCT", "bagging")
method_s <- c("", "", "",
              "auto_", "inf_", "nosp_", "sp_", 
              "", "", "", "", "", "")
              
iter_str <- c(1: 12)
for (iter in iter_str){
  
  r2_mat <- matrix(NA, nrow = 5, ncol = length(method))
  for (m in 1: length(method)){
    for (cross in 1: 5){
      r2_str <- paste0(comp_str, "07_external_c/03_EAS/03_res/continuous/pheno", 
                       ext_pheno[iter], "_data", ext_dat[iter], "/", method[m], "/", 
                       method_s[m], "r2_cross", cross, ".txt")
      if(file.exists(r2_str)){
        r2_mat[cross, m] <- read.table(r2_str)[1, 1]
      }else{
        cat(iter, method[m], "/", 
            method_s[m], "r2_cross", cross, ".txt\n")
      }
    }
  }
  cat(colMeans(r2_mat, na.rm = T), "\n")
  save(r2_mat, file = paste0(comp_str, "07_external_c/03_EAS/04_summ_res/res_hm3_c_pheno",
                             ext_pheno[iter], "_dat", ext_dat[iter], ".RData"))
}