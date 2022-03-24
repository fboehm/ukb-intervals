rm(list=ls())
library(reshape2)
internal_str <- "/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/"
setwd(internal_str)
pheno_uni <- c("SH", "PLT", "BMD", "BMR", "BMI", 
               "RBC", "AM", "RDW", "EOS", "WBC", 
               "FVC", "FEV", "FFR", "WC", "HC",
               "WHR", "SBP", "BW", "BFP", "TFP", 
               "SU", "TC", "HDL", "LDL", "TG")
pheno_class <- c("Anthropometric", "Blood cell", "Anthropometric", "Anthropometric", "Anthropometric", 
                 "Blood cell", "Other", "Blood cell", "Blood cell", "Blood cell",
                 "Anthropometric", "Anthropometric", "Anthropometric", "Anthropometric", "Anthropometric", 
                 "Anthropometric", "Other", "Anthropometric", "Anthropometric", "Anthropometric", 
                 "Other", "Lipid", "Lipid", "Lipid", "Lipid")
pheno_oo <- data.frame(pheno=pheno_uni, Class=pheno_class)

######################################################################
# get_rho <- function(p, cross){
#   require(bigreadr)
# 
#   all_pred_str <- paste0(internal_str, "pheno", p, "/DBSLMM/pred_hm3_best_cross", 
#                          cross, "_chr")
#   large_pred_str <- paste0(internal_str, "pheno", p, "/DBSLMM/l_pred_hm3_best_cross", 
#                            cross, "_chr")
#   all_pred_tot <- large_pred_tot <- vector()
#   for(chr in 1: 22){
#     all_pred_chr_str <- paste0(all_pred_str, chr, ".profile.gz")
#     if (file.exists(all_pred_chr_str)){
#       all_pred_chr <- fread2(all_pred_chr_str, header = T)[, 6]
#       all_pred_tot <- cbind(all_pred_tot, all_pred_chr)
#     } else {
#       cat (paste0("chr:", chr, " fail!\n"))
#     }
#   }
#   all_pred_var <- var(rowSums(all_pred_tot))
#   for(chr in 1: 22){
#     large_pred_chr_str <- paste0(large_pred_str, chr, ".profile.gz")
#     if (file.exists(large_pred_chr_str)){
#       large_pred_chr <- fread2(large_pred_chr_str, header = T)[, 6]
#       large_pred_tot <- cbind(large_pred_tot, large_pred_chr)
#     } else {
#       cat (paste0("chr:", chr, " fail!\n"))
#     }
#   }
#   large_pred_var <- var(rowSums(large_pred_tot))
#   
#   rho <- large_pred_var/all_pred_var
#   return(all_pred_var)
# }
# 
# pheno <- c(1: 25)
# rho_vec <- vector("numeric", length(pheno)*5)
# for (p in 1: length(pheno)){
#   for (cross in 1: 5){
#     rho_vec[c(5*(p-1)+cross)] <- get_rho(p, cross)
#   }
#   cat ("pheno: ", p , "\n")
# }
# rho_mat <- data.frame(pheno = rep(pheno_uni, each = 5), 
#                       cross = c(1: 5), 
#                       rho = rho_vec)
# rho_mat_s <- reshape2::dcast(rho_mat, pheno~., mean)
# colnames(rho_mat_s) <- c("pheno", "rho")
# rho_mat_s <- dplyr::left_join(rho_mat_s, pheno_oo, by = "pheno")
# save(rho_mat_s, file = paste0(internal_str, "summRes/rho_mat_s.RData"))
######################################################################
load("./summRes/rho_mat_s.RData")

## r2
load("./summRes/r2_hm3_dat.RData")
r2_dat_s <- reshape2::dcast(r2_dat[, -4], pheno~Methods, mean)
r2_dat_l <- reshape2::melt(r2_dat_s, id = c("pheno"))
colnames(r2_dat_l) <- c("pheno", "Methods", "R2")
r2_rho_dat <- dplyr::left_join(r2_dat_l, rho_mat_s, by = "pheno")

## mse
load("./summRes/mse_hm3_dat.RData")
mse_dat_s <- reshape2::dcast(mse_dat, pheno~Methods, mean)
mse_dat_l <- reshape2::melt(mse_dat_s, id = c("pheno"))
colnames(mse_dat_l) <- c("pheno", "Methods", "mse")
mse_rho_dat <- dplyr::left_join(mse_dat_l, rho_mat_s, by = "pheno")

save(r2_rho_dat, file = "./summRes/r2_rho_hm3_dat.RData")
save(mse_rho_dat, file = "./summRes/mse_rho_hm3_dat.RData")
