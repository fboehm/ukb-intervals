rm(list = ls())
library(plyr)
library(reshape2)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
load(paste0(comp_str, "05_internal_c/summRes/r2_hm3_mean_dat.RData"))
load(paste0(comp_str, "06_internal_b/summRes/auc_hm3_mean_dat.RData"))

# best PGSagg
sum(r2_mean_dat[r2_mean_dat$Methods == "PGSagg", 4]==1)
sum(auc_mean_dat[auc_mean_dat$Methods == "PGSagg", 4]==1)

# improvment for PGSagg
pheno_uni_b <- c("PRCA", "TA", "T2D", "CAD", "RA", 
                 "BRCA", "AS", "MP", "MDD", "SS", 
                 "QU", "HT", "FFI", "DFI", "OA", 
                 "AN", "GO", "SAF", "HA", "TE", 
                 "T1B", "VMS", "MY", "SN", "ES")
pheno_uni_c <- c("SH", "PLT", "BMD", "BMR", "BMI", 
                 "RBC", "AM", "RDW", "EOS", "WBC", 
                 "FVC", "FEV", "FFR", "WC", "HC",
                 "WHR", "SBP", "BW", "BFP", "TFP", 
                 "SU", "TC", "HDL", "LDL", "TG")
## continuous
imp_c <- loss_c <- vector()
for (p in 1: length(pheno_uni_c)){
  tmp <- r2_mean_dat[r2_mean_dat$Traits == pheno_uni_c[p], ]
  if (tmp[13, 4] == 1){
    imp_tmp <- (tmp[13, 3]-tmp[tmp$Rank == 2, 3])/tmp[tmp$Rank == 2, 3]*100
    imp_c <- c(imp_c, imp_tmp)
  } else {
    loss_tmp <- (tmp[tmp$Rank == 1, 3] - tmp[13, 3])/tmp[tmp$Rank == 1, 3]*100
    loss_c <- c(loss_c, loss_tmp)
  }
}
## binary
imp_b <- loss_b <- vector()
for (p in 1: length(pheno_uni_b)){
  # p=1
  tmp <- auc_mean_dat[auc_mean_dat$Traits == pheno_uni_b[p], ]
  if (tmp[13, 4] == 1){
    imp_tmp <- (tmp[13, 3]-tmp[tmp$Rank == 2, 3])/(tmp[tmp$Rank == 2, 3]-0.5)*100
    imp_b <- c(imp_b, imp_tmp)
  } else {
    loss_tmp <- (tmp[tmp$Rank == 1, 3] - tmp[13, 3])/(tmp[tmp$Rank == 1, 3]-0.5)*100
    loss_b <- c(loss_b, loss_tmp)
  }
}
## summary
round(mean(c(imp_c, imp_b)), 2)
round(mean(c(loss_c, loss_b)), 2)

# improvement for each method
imp_method_c <- aaply(c(1: length(pheno_uni_c)), 1, function(p){
  tmp <- r2_mean_dat[r2_mean_dat$Traits == pheno_uni_c[p], ]
  tmp_res <- (tmp[13, 3] - tmp[, 3]) / tmp[, 3] * 100
  return(tmp_res)
})[, -13]
imp_method_b <- aaply(c(1: length(pheno_uni_b)), 1, function(p){
  tmp <- auc_mean_dat[auc_mean_dat$Traits == pheno_uni_b[p], ]
  tmp_res <- (tmp[13, 3] - tmp[, 3]) / (tmp[, 3] - 0.5) * 100
  return(tmp_res)
})[, -13]
imp_method <- rbind(imp_method_c, imp_method_b)
round(colMeans(imp_method), 2)