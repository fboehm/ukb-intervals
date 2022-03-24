rm(list=ls())
library(reshape2)

# continuous traits
pheno_uni <- c("SH", "PLT", "BMD", "BMR", "BMI", 
               "RBC", "AM", "RDW", "EOS", "WBC", 
               "FVC", "FEV", "FFR", "WC", "HC",
               "WHR", "SBP", "BW", "BFP", "TFP", 
               "SU", "TC", "HDL", "LDL", "TG")
## hm3
herit_hm3 <- infl_hm3 <- matrix(NA, 25, 5)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
for (p in 1:25){
  for (cross in 1:5){
    herit_str <- paste0(comp_str, "05_internal_c/pheno", p, 
                        "/herit/h2_hm3_cross", cross, ".log")
    herit_file <- as.vector(read.delim(herit_str))
    herit_hm3[p, cross] <- as.numeric(strsplit(strsplit(as.character(herit_file[24, ]),": ")[[1]][2], " \\(")[[1]][1])
    infl_hm3[p, cross] <- as.numeric(strsplit(as.character(herit_file[25, ]),": ")[[1]][2])
  }
}
herit_hm3_mean <- rowMeans(herit_hm3)
infl_hm3_mean <- rowMeans(infl_hm3)
pheno_f <- factor(pheno_uni, levels = pheno_uni[order(herit_hm3_mean, decreasing = T)])
herit_hm3_dat <- data.frame(pheno = pheno_f, 
                            herit_hm3, 
                            ref = "HM3")
summ_hm3_dat <- data.frame(pheno = pheno_f, 
                           herit = round(herit_hm3_mean,4), 
                           infl = round(infl_hm3_mean, 4))
summ_hm3_dat <- summ_hm3_dat[order(summ_hm3_dat[, 1]), ]
write.csv(summ_hm3_dat, file = "/net/mulan/disk2/yasheng/comparisonProject/code/08_summ_figure/01_internal/hm3_c.csv", 
          row.names = F, quote = F)
## ukb
herit_ukb <- infl_ukb <-  matrix(NA, 25, 5)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
for (p in 1:25){
  for (cross in 1:5){
    herit_str <- paste0(comp_str, "05_internal_c/pheno", p, 
                        "/herit/h2_ukb_cross", cross, ".log")
    herit_file <- as.vector(read.delim(herit_str))
    herit_ukb[p, cross] <- as.numeric(strsplit(strsplit(as.character(herit_file[24, ]),": ")[[1]][2], " \\(")[[1]][1])
    infl_ukb[p, cross] <- as.numeric(strsplit(as.character(herit_file[25, ]),": ")[[1]][2])
  }
}
herit_ukb_mean <- rowMeans(herit_ukb)
infl_ukb_mean <- rowMeans(infl_ukb)
herit_ukb_dat <- data.frame(pheno = pheno_f, 
                            herit_ukb, 
                            ref = "UKB")
herit_dat <- rbind(herit_hm3_dat, herit_ukb_dat)
herit_dat_l <- melt(herit_dat, id.vars = c("pheno", "ref"))
save(herit_dat_l, file = paste0(comp_str, "05_internal_c/summRes/herit.RData"))
summ_ukb_dat <- data.frame(pheno = pheno_f, 
                           herit = round(herit_ukb_mean,4), 
                           infl = round(infl_ukb_mean, 4))
summ_ukb_dat <- summ_ukb_dat[order(summ_ukb_dat[, 1]), ]
write.csv(summ_ukb_dat, file = "/net/mulan/disk2/yasheng/comparisonProject/code/08_summ_figure/01_internal/ukb_c.csv", 
          row.names = F, quote = F)





## herit for binary traits
herit_hm3 <- infl_hm3 <- matrix(NA, 25, 5)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
for (p in 1:25){
  for (cross in 1:5){
    herit_str <- paste0(comp_str, "06_internal_b/pheno", p, 
                        "/herit/h2_hm3_cross", cross, ".log")
    herit_file <- as.vector(read.delim(herit_str))
    herit_hm3[p, cross] <- as.numeric(strsplit(strsplit(as.character(herit_file[24, ]),": ")[[1]][2], " \\(")[[1]][1])
    infl_hm3[p, cross] <- as.numeric(strsplit(as.character(herit_file[25, ]),": ")[[1]][2])
  }
}
herit_hm3_mean <- rowMeans(herit_hm3)
infl_hm3_mean <- rowMeans(infl_hm3)
pheno_uni <- c("PRCA", "TA", "TD2", "CAD", "RA", 
               "BRCA", "AS", "MP", "MDD", "SS", 
               "QU", "HT", "FFI", "DFI", "OS", 
               "AN", "GO", "SAF", "HA", "TE", 
               "T1B", "VMS", "MY", "SN", "ES")
pheno_f <- factor(pheno_uni, levels = pheno_uni[order(herit_hm3_mean, decreasing = T)])
herit_hm3_dat <- data.frame(pheno = pheno_f, 
                            herit_hm3, 
                            ref = "HM3")
summ_hm3_dat <- data.frame(pheno = pheno_f, 
                           herit = round(herit_hm3_mean,4), 
                           infl = round(infl_hm3_mean, 4))
summ_hm3_dat <- summ_hm3_dat[order(summ_hm3_dat[, 1]), ]
write.csv(summ_hm3_dat, file = "/net/mulan/disk2/yasheng/comparisonProject/code/08_summ_figure/01_internal/hm3_b.csv", 
          row.names = F, quote = F)



## snp_num
snp_num_hm3 <- matrix(NA, 25, 5)
for (p in 1:25){
  for (cross in 1:5){
    herit_str <- paste0(comp_str, "05_internal_c/pheno", p, 
                        "/herit/h2_hm3_cross", cross, ".log")
    herit_file <- as.vector(read.delim(herit_str))
    snp_num_hm3[p, cross] <- as.numeric(strsplit(strsplit(as.character(herit_file[22, ]),",")[[1]][2], " ")[[1]][2])
  }
}
snp_num_hm3_dat <- data.frame(pheno = pheno_f, 
                              snp_num_hm3, 
                              ref = "HM3")
snp_num_ukb <- matrix(NA, 25, 5)
for (p in 1:25){
  for (cross in 1:5){
    herit_str <- paste0(comp_str, "05_internal_c/pheno", p, 
                        "/herit/h2_ukb_cross", cross, ".log")
    herit_file <- as.vector(read.delim(herit_str))
    snp_num_ukb[p, cross] <- as.numeric(strsplit(strsplit(as.character(herit_file[22, ]),",")[[1]][2], " ")[[1]][2])
  }
}
snp_num_ukb_dat <- data.frame(pheno = pheno_f, 
                              snp_num_ukb, 
                              ref = "UKB")
snp_num_dat <- rbind(snp_num_hm3_dat, snp_num_ukb_dat)
snp_num_dat_l <- melt(snp_num_dat, id.vars = c("pheno", "ref"))
save(snp_num_dat_l, file = paste0(comp_str, "05_internal_c/summRes/snp_num.RData"))

## sample size
sample_vec <- vector()
for (p in 1: 25){
  train_str <- paste0(comp_str, "02_pheno/02_train_c/n_pheno", p, ".txt")
  sample_tmp <- read.table(train_str)[, 1]
  sample_vec <- c(sample_vec, sample_tmp)
}
sample_dat <- data.frame(pheno = rep(pheno_f, each = 5), 
                         sample_vec)
save(sample_dat, file = paste0(comp_str, "05_internal_c/summRes/sample_dat.RData"))
