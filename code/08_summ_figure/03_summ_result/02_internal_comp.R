rm(list=ls())
library(plyr)
library(bigreadr)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"

# contiunous traits
pheno_path_c <- paste0(comp_str, "05_internal_c/")
pheno_uni_c <- c("SH", "PLT", "BMD", "BMR", "BMI", 
                 "RBC", "AM", "RDW", "EOS", "WBC", 
                 "FVC", "FEV", "FFR", "WC", "HC",
                 "WHR", "SBP", "BW", "BFP", "TFP", 
                 "SU", "TC", "HDL", "LDL", "TG")
pheno_order_c <- c("SH", "BMD", "HDL", "BMR", "PLT",  
                 "BMI", "BFP", "AM", "HC", "RBC",
                 "TFP", "RDW", "WC", "EOS", "TG",
                 "WBC", "FVC", "FFR", "FEV", "WHR",
                 "SBP", "TC", "LDL", "BW", "SU")
pheno_class_c <- c("Anthropometric", "Blood cell", "Anthropometric", "Anthropometric", "Anthropometric", 
                   "Blood cell", "Other", "Blood cell", "Blood cell", "Blood cell",
                   "Anthropometric", "Anthropometric", "Anthropometric", "Anthropometric", "Anthropometric", 
                   "Anthropometric", "Other", "Anthropometric", "Anthropometric", "Anthropometric", 
                   "Other", "Lipid", "Lipid", "Lipid", "Lipid")
pheno_f_c <- factor(pheno_uni_c, levels = pheno_order_c)

# binary
pheno_path_b <- paste0(comp_str, "06_internal_b/")
pheno_uni_b <- c("PRCA", "TA", "T2D", "CAD", "RA", 
                 "BRCA", "AS", "MP", "MDD", "SS", 
                 "QU", "HT", "FFI", "DFI", "OA", 
                 "AN", "GO", "SAF", "HA", "TE", 
                 "T1B", "VMS", "MY", "SN", "ES")
pheno_order_b <- c("T1B", "QU", "HT", "TA", "SS",
                   "MY", "ES", "SAF", "MP", "AS",   
                   "DFI", "SN", "TE", "AN", "HA", 
                   "CAD", "PRCA", "GO", "FFI", "T2D", 
                   "VMS", "MDD", "BRCA", "RA", "OA")
pheno_class_b <- c("Disease", "Other", "Disease", "Disease", "Disease", 
                   "Disease", "Disease", "Other", "Disease", "Other", 
                   "Other", "Disease", "Other", "Other", "Disease", 
                   "Disease", "Disease", "Other", "Disease", "Other",
                   "Other", "Other", "Disease", "Disease", "Other")
pheno_f_b <- factor(pheno_uni_b, levels = pheno_order_b)

# PRSCS
## continuous
PRSCS_hm3_list_c <- plyr::alply(c(1: length(pheno_uni_c)), 1, function(a){
  load(paste0(pheno_path_c, "summRes/res_hm3_c_pheno", a, ".RData"))
  r2_mat <- colMeans(res_list[[1]][, c(10, 11)])
  return(r2_mat)
})
PRSCS_hm3_dat_c <- laply(PRSCS_hm3_list_c, function(a) a)
PRSCS_l_imp_hm3_c <- (PRSCS_hm3_dat_c[, 2] - PRSCS_hm3_dat_c[, 1])/PRSCS_hm3_dat_c[, 1]
PRSCS_hm3_dat_c <- data.frame(Traits = pheno_f_c, 
                              Class = pheno_class_c,  
                              R_auto = PRSCS_hm3_dat_c[, 1], 
                              R_tuning = PRSCS_hm3_dat_c[, 2])
## binary
PRSCS_hm3_list_b <- plyr::alply(c(1: length(pheno_uni_b)), 1, function(a){
  load(paste0(pheno_path_b, "summRes/res_hm3_b_pheno", a, ".RData"))
  r2_mat <- colMeans(res_list[[2]][, c(10, 11)])
  return(r2_mat)
})
PRSCS_hm3_dat_b <- laply(PRSCS_hm3_list_b, function(a) a)
PRSCS_l_imp_hm3_b <- (PRSCS_hm3_dat_b[, 2] - PRSCS_hm3_dat_b[, 1])/(PRSCS_hm3_dat_b[, 1]-0.5)
PRSCS_hm3_dat_b <- data.frame(Traits = pheno_f_b, 
                              Class = pheno_class_b,  
                              AUC_auto = PRSCS_hm3_dat_b[, 1], 
                              AUC_tuning = PRSCS_hm3_dat_b[, 2])
PRSCS_imp_hm3 <- c(PRSCS_l_imp_hm3_c, PRSCS_l_imp_hm3_b)
cat("PRSCS hm3: ", round(mean(PRSCS_imp_hm3)*100, 2), round(median(PRSCS_imp_hm3)*100, 2), 
    round(range(PRSCS_imp_hm3)*100, 2), "\n")
## save result
save(PRSCS_hm3_dat_c, PRSCS_hm3_dat_b,
     file = paste0(comp_str, "05_internal_c/summRes/comp_PRSCS.RData"))

# DBSLMM
## hm3
### continuous
DBSLMM_hm3_list_c <- plyr::alply(c(1: length(pheno_uni_c)), 1, function(a){
  load(paste0(pheno_path_c, "summRes/res_hm3_c_pheno", a, ".RData"))
  r2_mat <- colMeans(res_list[[1]][, c(2, 3)])
  return(r2_mat)
})
DBSLMM_hm3_dat_c <- laply(DBSLMM_hm3_list_c, function(a) a)
DBSLMM_l_imp_hm3_c <- (DBSLMM_hm3_dat_c[, 2] - DBSLMM_hm3_dat_c[, 1])/DBSLMM_hm3_dat_c[, 1]
DBSLMM_hm3_dat_c <- data.frame(Traits = pheno_f_c, 
                               Class = pheno_class_c, 
                               R_auto = DBSLMM_hm3_dat_c[, 1], 
                               R_tuning = DBSLMM_hm3_dat_c[, 2])
### binary
DBSLMM_hm3_list_b <- plyr::alply(c(1: length(pheno_uni_b)), 1, function(a){
  load(paste0(pheno_path_b, "summRes/res_hm3_b_pheno", a, ".RData"))
  r2_mat <- colMeans(res_list[[2]][, c(2, 3)])
  return(r2_mat)
})
DBSLMM_hm3_dat_b <- laply(DBSLMM_hm3_list_b, function(a) a)
DBSLMM_l_imp_hm3_b <- (DBSLMM_hm3_dat_b[, 2] - DBSLMM_hm3_dat_b[, 1])/(DBSLMM_hm3_dat_b[, 1]-0.5)
DBSLMM_hm3_dat_b <- data.frame(Traits = pheno_f_b, 
                               Class = pheno_class_b, 
                               AUC_auto = DBSLMM_hm3_dat_b[, 1], 
                               AUC_tuning = DBSLMM_hm3_dat_b[, 2])
DBSLMM_imp_hm3 <- c(DBSLMM_l_imp_hm3_c, DBSLMM_l_imp_hm3_b)
cat("DBSLMM hm3: ", round(mean(DBSLMM_imp_hm3)*100, 2), round(median(DBSLMM_imp_hm3)*100, 2), 
    round(range(DBSLMM_imp_hm3)*100, 2), "\n")
save(DBSLMM_hm3_dat_c, DBSLMM_hm3_dat_b,
     file = paste0(comp_str, "05_internal_c/summRes/comp_DBSLMM.RData"))



