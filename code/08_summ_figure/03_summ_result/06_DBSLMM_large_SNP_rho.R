library(bigreadr)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
pheno_uni_c <- c("SH", "PLT", "BMD", "BMR", "BMI", 
                 "RBC", "AM", "RDW", "EOS", "WBC", 
                 "FVC", "FEV", "FFR", "WC", "HC",
                 "WHR", "SBP", "BW", "BFP", "TFP", 
                 "SU", "TC", "HDL", "LDL", "TG")
pheno_uni_b <- c("PRCA", "TA", "T2D", "CAD", "RA", 
                 "BRCA", "AS", "MP", "MDD", "SS", 
                 "QU", "HT", "FFI", "DFI", "OA", 
                 "AN", "GO", "SAF", "HA", "TE", 
                 "T1B", "VMS", "MY", "SN", "ES")

DBSLMM_num_c <- matrix(NA, 25, 5)
for(p in 1: 25){
  for (cross in 1: 5){
    large_snp_num <- 0
    for (chr in 1: 22){
        DBSLMM_tmp <- fread2(paste0(comp_str, "05_internal_c/pheno", p, 
                             "/DBSLMM/summary_hm3_cross", cross, "_chr", chr, 
                             "_best.dbslmm.txt.gz"))
        large_snp_num <- large_snp_num + sum(DBSLMM_tmp[, 5] == 1)
    }

    DBSLMM_num_c[p, cross] <- large_snp_num
  }
  cat(p, "\n")
}


DBSLMM_num_b <- matrix(NA, 25, 5)
for(p in 1: 25){
  for (cross in 1: 5){
    large_snp_num <- 0
    for (chr in 1: 22){
      DBSLMM_tmp <- fread2(paste0(comp_str, "06_internal_b/pheno", p, 
                                  "/DBSLMM/summary_hm3_cross", cross, "_chr", chr, 
                                  "_best.dbslmm.txt.gz"))
      large_snp_num <- large_snp_num + sum(DBSLMM_tmp[, 5] == 1)
    }
    
    DBSLMM_num_b[p, cross] <- large_snp_num
  }
  cat(p, "\n")
}

DBSLMM_dat <- data.frame(Traits = c(pheno_uni_c, pheno_uni_b), 
                         snp = c(rowMeans(DBSLMM_num_c), rowMeans(DBSLMM_num_b)))
load("/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/summRes/r2_rho_hm3_dat.RData")
r2_rho <- r2_rho_dat[c(1:25), c(1, 4)]
load("/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/summRes/auc_rho_hm3_dat.RData")
auc_rho <- auc_rho_dat[c(1:25), c(1, 4)]
rho <- rbind(r2_rho, auc_rho)
rho <- rho[match(DBSLMM_dat$Traits, rho$pheno), ]
DBSLMM_dat$rho <- rho[, 2]
DBSLMM_dat
save(DBSLMM_dat, file = "/net/mulan/disk2/yasheng/comparisonProject/code/08_summ_figure/PGE_rho.RData")