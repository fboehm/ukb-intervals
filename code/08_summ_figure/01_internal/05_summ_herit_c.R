rm(list=ls())
library(reshape2)

# hm3
## herit for continuous traits
herit_hm3 <- matrix(NA, 25, 5)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
for (p in 1:25){
  for (cross in 1:5){
    herit_str <- paste0(comp_str, "05_internal_c/pheno", p, 
                        "/herit/h2_hm3_cross", cross, ".log")
    herit_file <- as.vector(read.delim(herit_str))
    herit_hm3[p, cross] <- as.numeric(strsplit(strsplit(as.character(herit_file[24, ]),": ")[[1]][2], " \\(")[[1]][1])
  }
}
herit_hm3_mean <- rowMeans(herit_hm3)
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

pheno_f <- factor(pheno_uni, levels = pheno_uni[order(herit_hm3_mean, decreasing = T)])
herit_hm3_dat <- data.frame(pheno = pheno_f, 
                            herit_hm3_mean, 
                            ref = "HM3", 
                            class = pheno_class)
load(paste0(comp_str, "05_internal_c/summRes/r2_hm3_dat.RData"))
r2_dat <- r2_dat[r2_dat$Methods != "PGSagg", ]
r2_dat <- dcast(r2_dat[, -4], pheno~Methods, mean)
r2_dat <- melt(r2_dat, id = "pheno")
r2_herit_dat <- dplyr::left_join(herit_hm3_dat, r2_dat, by = "pheno")
colnames(r2_herit_dat) <- c("Traits", "herit", "Ref", "Class", "Methods","R2")

load(paste0(comp_str, "05_internal_c/summRes/mse_hm3_dat.RData"))
mse_dat <- mse_dat[mse_dat$Methods != "PGSagg", ]
mse_dat <- dcast(mse_dat, pheno~Methods, mean)
mse_dat <- melt(mse_dat, id = "pheno")
mse_herit_dat <- dplyr::left_join(herit_hm3_dat, mse_dat, by = "pheno")
colnames(mse_herit_dat) <- c("Traits", "herit", "Ref", "Class", "Methods","MSE")
## output
save(r2_herit_dat, file = paste0(comp_str, "05_internal_c/summRes/r2_herit_hm3_dat.RData"))
save(mse_herit_dat, file = paste0(comp_str, "05_internal_c/summRes/mse_herit_hm3_dat.RData"))




# ukb
## herit for continuous traits
herit_ukb <- matrix(NA, 25, 5)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
for (p in 1:25){
  for (cross in 1:5){
    herit_str <- paste0(comp_str, "05_internal_c/pheno", p, 
                        "/herit/h2_ukb_cross", cross, ".log")
    herit_file <- as.vector(read.delim(herit_str))
    herit_ukb[p, cross] <- as.numeric(strsplit(strsplit(as.character(herit_file[24, ]),": ")[[1]][2], " \\(")[[1]][1])
  }
}
herit_ukb_mean <- rowMeans(herit_ukb)
herit_ukb_dat <- data.frame(pheno = pheno_f, 
                            herit_ukb_mean, 
                            ref = "UKB", 
                            class = pheno_class)

load("/net/mulan/disk2/yasheng/comparisonProject/05_internal_c/summRes/r2_ukb_dat.RData")
r2_dat <- reshape2::dcast(r2_dat[, -4], pheno~method, mean)
r2_dat <- melt(r2_dat, id = "pheno")
r2_herit_dat <- merge(r2_dat, herit_ukb_dat, by = "pheno", sort = F)
colnames(r2_herit_dat) <- c("Traits", "Methods", "R2", "herit", "Ref", "Class")

## output
save(r2_herit_dat, file = paste0(comp_str, "05_internal_c/summRes/r2_herit_ukb_dat.RData"))
