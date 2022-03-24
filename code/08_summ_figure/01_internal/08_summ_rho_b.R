rm(list=ls())
library(reshape2)
internal_str <- "/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/"
setwd(internal_str)
pheno_uni <- c("PRCA", "TA", "T2D", "CAD", "RA", 
               "BRCA", "AS", "MP", "MDD", "SS", 
               "QU", "HT", "FFI", "DFI", "OA", 
               "AN", "GO", "SAF", "HA", "TE", 
               "T1B", "VMS", "MY", "SN", "ES")
pheno_class <- c("Disease", "Other", "Disease", "Disease", "Disease", 
                 "Disease", "Disease", "Other", "Disease", "Other", 
                 "Other", "Disease", "Other", "Other", "Disease", 
                 "Disease", "Disease", "Other", "Disease", "Other",
                 "Other", "Other", "Disease", "Disease", "Other")

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
# rho_mat <- vector("numeric", length(pheno))
# for (p in 1: length(pheno)){
#   for (cross in 1: 5){
#     rho_mat[c(5*(p-1)+cross)] <- get_rho(p, cross)
#   }
#   cat ("pheno: ", p , "\n")
# }
# 
# rho_mat <- data.frame(pheno = rep(pheno_uni, each = 5), 
#                       cross = c(1: 5), 
#                      rho = rho_mat)
# rho_mat_s <- reshape2::dcast(rho_mat, pheno~., mean)
# colnames(rho_mat_s) <- c("pheno", "rho")
# rho_mat_s <- dplyr::left_join(rho_mat_s, pheno_oo, by = "pheno")
# save(rho_mat_s, file = "./summRes/rho_mat_s.RData")
######################################################################
load("./summRes/rho_mat_s.RData")
## auc
load("./summRes/auc_hm3_dat.RData")
auc_dat_s <- reshape2::dcast(auc_dat, pheno~Methods, function(a) mean(a, na.rm = T))
auc_dat_l <- reshape2::melt(auc_dat_s, id = c("pheno"))
colnames(auc_dat_l) <- c("pheno", "Methods", "auc")
auc_rho_dat <- dplyr::left_join(auc_dat_l, rho_mat_s, by = "pheno")

## pr2
load("./summRes/pr2_hm3_dat.RData")
pr2_dat_s <- reshape2::dcast(pr2_dat, pheno~Methods, function(a) mean(a, na.rm = T))
pr2_dat_l <- reshape2::melt(pr2_dat_s, id = c("pheno"))
colnames(pr2_dat_l) <- c("pheno", "Methods", "pr2")
pr2_rho_dat <- dplyr::left_join(pr2_dat_l, rho_mat_s, by = "pheno")

save(auc_rho_dat, file = "./summRes/auc_rho_hm3_dat.RData")
save(pr2_rho_dat, file = "./summRes/pr2_rho_hm3_dat.RData")
