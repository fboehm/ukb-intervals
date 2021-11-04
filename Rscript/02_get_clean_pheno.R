rm(list=ls())
library(tidyverse)

# load data
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
load(paste0(comp_str, "02_pheno/01_sqc.RData"))
load(paste0(comp_str, "02_pheno/02_pheno_c_raw.RData"))
#load(paste0(comp_str, "02_pheno/03_pheno_b_raw.RData"))

out_dir <- "~/research/ukb-intervals/dat"

# continuous traits
pheno_c_all <- matrix(NA, ncol = 25, nrow = nrow(pheno_c))
pheno_c_all[, 1] <- pheno_c[, 2]                   # 1.  SH, n = 336405
pheno_c_all[, 2] <- pheno_c[, 3]                   # 2.  PLT, n = 327153
pheno_c_all[, 3] <- pheno_c[, 4]                   # 3.  BMD, n = 194266
pheno_c_all[, 4] <- pheno_c[, 5]                   # 4.  BMR, n = 331239
pheno_c_all[, 5] <- pheno_c[, 6]                   # 5.  BMI, n = 336038
pheno_c_all[, 6] <- pheno_c[, 7]                   # 6.  RBC, n = 327152
pheno_c_all[, 7] <- pheno_c[, 8]                   # 7.  AM, n = 181021
pheno_c_all[, 8] <- pheno_c[, 9]                   # 8.  RDW, n = 327152
pheno_c_all[, 9] <- pheno_c[, 10]                  # 9.  EOS, n = 326587
pheno_c_all[, 10] <- pheno_c[, 11]                 # 10. WBC, n = 327150
pheno_c_all[, 11] <- pheno_c[, 12]                 # 11. FVC, n = 307573
pheno_c_all[, 12] <- pheno_c[, 13]                 # 12. FEV, n = 307573
pheno_c_all[, 13] <- pheno_c[, 13]/pheno_c[, 12]   # 13. FFR, n = 307573
pheno_c_all[, 14] <- pheno_c[, 14]                 # 14. WC, n = 336569
pheno_c_all[, 15] <- pheno_c[, 15]                 # 15. HC, n = 336531
pheno_c_all[, 16] <- pheno_c[, 14]/pheno_c[, 15]   # 16. WHR, n = 336499
pheno_c_all[, 17] <- pheno_c[, 16]                 # 17. SBP, n = 314907
pheno_c_all[, 18] <- pheno_c[, 17]                 # 18. BW, n = 193026
pheno_c_all[, 19] <- pheno_c[, 18]                 # 19. BFP, n = 331049
pheno_c_all[, 20] <- pheno_c[, 19]                 # 20. TFP, n = 331045
pheno_c_all[, 21] <- pheno_c[, 20]                 # 21. SU, n = 326762
pheno_c_all[, 22] <- pheno_c[, 21]                 # 22. CH, n = 321416
pheno_c_all[, 23] <- pheno_c[, 22]                 # 23. HDL, n = 294227
pheno_c_all[, 24] <- pheno_c[, 23]                 # 24. LDL, n = 320810
pheno_c_all[, 25] <- pheno_c[, 24]                 # 25. TC, n = 321152

# Quantile normalize raw data values for every trait
pheno_c_all <- apply(X = pheno_c_all, MARGIN = 2, FUN = function(dat){ryouready::qqnorm_spss(dat, method = 1, ties.method = "random")})



# adjust PC for 25 continuous traits and 10-fold cross veidation
PC <- sqc_i[, which(colnames(sqc_i)%in%paste0("PC", 1:20))]
sex <- sqc_i[, which(colnames(sqc_i)%in%"Inferred.Gender")]
covVar <- as.matrix(cbind(PC[, c(1:10)], ifelse(sex == "F", 0, 1)))
pheno_c_adj <- matrix(NA, nrow = nrow(pheno_c_all), ncol = 25)
for (i in 1: 25){
  na_idx <- ifelse(is.na(pheno_c_all[, i]), T, F)
  pheno_na <- ifelse(na_idx, NA, pheno_c_all[, i])
  pheno_scale <- scale(pheno_na)
   resid <- lm(pheno_scale[!na_idx] ~ covVar[!na_idx, ])$residual
  #pheno_c_adj[!na_idx, i] <- qqnorm(resid, plot.it = F)$x
  ## Check Xiang's R code for quantile normalization, with attention to treatment of ties!
  pheno_c_adj[!na_idx, i] <- ryouready::qqnorm_spss(resid, method = 1, ties.method = "random")$y
  pheno_c_adj[na_idx, i] <- NA
  cat(paste0("pheno: ", i, ", sample size: ", length(pheno_c_adj[!na_idx, i]), "\n"))
}
#save(pheno_c_adj, file = paste0(comp_str, "02_pheno/04_pheno_c_adj.RData"))
saveRDS(file.path(out_dir, "04_pheno_c_adj.rds"))
