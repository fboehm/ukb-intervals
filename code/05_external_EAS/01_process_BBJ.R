rm(list=ls())
library(bigreadr)
library(dplyr)
setwd("/net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/")

# HM3 SNP
hm3_frq <- fread2("/net/mulan/disk2/yasheng/predictionProject/plink_file/hm3/merge.frq")

# load all data to obtain the intersection of 17 data sets 
# pheno1: SH
SH_dat <- fread2("./01_raw/2019_BBJ_Height_autosomes_BOLT.txt.gz") %>%
  filter(MAF>0.01 & rsID %in% hm3_frq$SNP)
cat("SNP number of SH_dat: ", nrow(SH_dat), "\n")

# pheno 2: PLT 
PLT_dat <- fread2("./01_raw/BBJ.Plt.autosome.txt.gz") %>% 
  filter(Frq > 0.01 & Frq < 0.99 & SNP %in% hm3_frq$SNP)
cat("SNP number of PLT_dat1: ", nrow(PLT_dat), "\n")

# pheno 5: BMI
BMI_dat <- fread2("./01_raw/All_2017_BMI_BBJ_autosome.txt.gz") %>% 
filter(Frq > 0.01 & Frq < 0.99 & SNP %in% hm3_frq$SNP)
cat("SNP number of BMI_dat: ", nrow(BMI_dat), "\n")

# pheno 6: RBC
RBC_dat <- fread2("./01_raw/BBJ.RBC.autosome.txt.gz") %>% 
  filter(Frq > 0.01 & Frq < 0.99 & SNP %in% hm3_frq$SNP)
cat("SNP number of RBC_dat1: ", nrow(RBC_dat), "\n")

# pheno 7: AM 
AM_dat <- fread2("./01_raw/hum0014.v9.Men.v1.gz") %>% 
  filter(EFFECT_ALLELE_FREQ > 0.01 & EFFECT_ALLELE_FREQ < 0.99 & MARKER %in% hm3_frq$SNP)
cat("SNP number of AM_dat: ", nrow(AM_dat), "\n")

# pheno 9: EOS
EOS_dat <- fread2("./01_raw/BBJ.Eosino.autosome.txt.gz")%>% 
  filter(Frq > 0.01 & Frq < 0.99 & SNP %in% hm3_frq$SNP)
cat("SNP number of EOS_dat: ", nrow(EOS_dat), "\n")

# pheno 10: WBC 
WBC_dat <- fread2("./01_raw/BBJ.WBC.autosome.txt.gz")%>% 
  filter(Frq > 0.01 & Frq < 0.99 & SNP %in% hm3_frq$SNP)
cat("SNP number of WBC_dat: ", nrow(WBC_dat), "\n")

# pheno 17: SBP
SBP_dat <- fread2("./01_raw/BBJ.SBP.autosome.txt.gz")%>% 
  filter(Frq > 0.01 & Frq < 0.99 & SNP %in% hm3_frq$SNP)
cat("SNP number of SBP_dat: ", nrow(SBP_dat), "\n")

# pheno 22: TC 
TC_dat <- fread2("./01_raw/BBJ.TC.autosome.txt.gz")%>% 
  filter(Frq > 0.01 & Frq < 0.99 & SNP %in% hm3_frq$SNP)
cat("SNP number of TC_dat: ", nrow(TC_dat), "\n")

# pheno 23: HDL
HDL_dat <- fread2("./01_raw/BBJ.HDL-C.autosome.txt.gz")%>% 
  filter(Frq > 0.01 & Frq < 0.99 & SNP %in% hm3_frq$SNP)
cat("SNP number of HDL_dat: ", nrow(HDL_dat), "\n")

# pheno 24: LDL
LDL_dat <- fread2("./01_raw/BBJ.LDL-C.autosome.txt.gz")%>% 
  filter(Frq > 0.01 & Frq < 0.99 & SNP %in% hm3_frq$SNP)
cat("SNP number of LDL_dat: ", nrow(LDL_dat), "\n")

# pheno 25: TG
TG_dat <- fread2("./01_raw/BBJ.TG.autosome.txt.gz")%>% 
  filter(Frq > 0.01 & Frq < 0.99 & SNP %in% hm3_frq$SNP)
cat("SNP number of TG_dat: ", nrow(TG_dat), "\n")

# intersection of the data sets
inter_snp <- Reduce(intersect, list(SH_dat$rsID, PLT_dat$SNP, 
                                    RBC_dat$SNP, AM_dat$MARKER))
save(inter_snp, file = "./02_clean/hm3_snp_inter.RData")                   

# subset for each data set
# pheno1: SH
SH_inter_dat <- SH_dat[match(inter_snp, SH_dat$rsID), ]
SH_herit_dat <- data.frame(SNP = SH_inter_dat$rsID,
                           N = 159095,
                           Z = SH_inter_dat$BETA/SH_inter_dat$SE,
                           A1 = SH_inter_dat$ALT,
                           A2 = SH_inter_dat$REF)
SH_val_dat <- data.frame(SNP = SH_inter_dat$rsID, 
                         A1 = SH_inter_dat$ALT,
                         beta = SH_inter_dat$BETA*sqrt(2*SH_inter_dat$MAF*(1-SH_inter_dat$MAF)))
write.table(SH_herit_dat, file = "./02_clean/pheno1_data1_herit.ldsc",
            row.names = F, quote = F)
write.table(SH_val_dat, file = "./02_clean/pheno1_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno1_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno1_data1_val.txt")

# pheno2: PLT 
PLT_inter_dat <- PLT_dat[match(inter_snp, PLT_dat$SNP), ]
PLT_herit_dat <- data.frame(SNP = PLT_inter_dat$SNP, 
                             N = PLT_inter_dat$N, 
                             Z = PLT_inter_dat$BETA/PLT_inter_dat$SE, 
                             A1 = PLT_inter_dat$ALT,
                             A2 = PLT_inter_dat$REF)
PLT_val_dat <- data.frame(SNP = PLT_inter_dat$SNP, 
                          A1 = PLT_inter_dat$ALT,
                          beta = PLT_inter_dat$BETA*sqrt(2*PLT_inter_dat$Frq*(1-PLT_inter_dat$Frq)))
write.table(PLT_herit_dat, file = "./02_clean/pheno2_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(PLT_val_dat, file = "./02_clean/pheno2_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno2_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno2_data1_val.txt")

# pheno5: BMI
BMI_inter_dat <- BMI_dat[match(inter_snp, BMI_dat$SNP), ]
BMI_herit_dat <- data.frame(SNP = BMI_inter_dat$SNP, 
                             N = 158284, 
                             Z = BMI_inter_dat$BETA/BMI_inter_dat$SE,
                             A1 = BMI_inter_dat$ALT, 
                             A2 = BMI_inter_dat$REF)
BMI_val_dat <- data.frame(SNP = BMI_inter_dat$SNP, 
                           A1 = BMI_inter_dat$ALT,
                           beta = BMI_inter_dat$BETA*sqrt(2*BMI_inter_dat$Frq*(1-BMI_inter_dat$Frq)))
write.table(BMI_herit_dat, file = "./02_clean/pheno5_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(BMI_val_dat, file = "./02_clean/pheno5_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno5_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno5_data1_val.txt")

# pheno 6: RBC
RBC_inter_dat <- RBC_dat[match(inter_snp, RBC_dat$SNP), ]
RBC_herit_dat <- data.frame(SNP = RBC_inter_dat$SNP, 
                             N = RBC_inter_dat$N, 
                             Z = RBC_inter_dat$BETA/RBC_inter_dat$SE, 
                             A1 = RBC_inter_dat$ALT,
                             A2 = RBC_inter_dat$REF)
RBC_val_dat <- data.frame(SNP = RBC_inter_dat$SNP, 
                           A1 = RBC_inter_dat$ALT,
                           beta = RBC_inter_dat$BETA*sqrt(2*RBC_inter_dat$Frq*(1-RBC_inter_dat$Frq)))
write.table(RBC_herit_dat, file = "./02_clean/pheno6_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(RBC_val_dat, file = "./02_clean/pheno6_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno6_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno6_data1_val.txt")

# pheno 7: AM 
AM_inter_dat <- AM_dat[AM_dat$MARKER %in% inter_snp, ]
AM_herit_dat <- data.frame(SNP = AM_inter_dat$MARKER, 
                            N = AM_inter_dat$N, 
                            Z = AM_inter_dat$BETA/AM_inter_dat$SE, 
                            A1 = AM_inter_dat$EFFECT_ALLELE,
                            A2 = AM_inter_dat$NON_EFFECT_ALLELE)
AM_val_dat <- data.frame(SNP = AM_inter_dat$MARKER, 
                          A1 = AM_inter_dat$EFFECT_ALLELE,
                          beta = AM_inter_dat$BETA*sqrt(2*AM_inter_dat$EFFECT_ALLELE_FREQ*(1-AM_inter_dat$EFFECT_ALLELE_FREQ)))
write.table(AM_herit_dat, file = "./02_clean/pheno7_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(AM_val_dat, file = "./02_clean/pheno7_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno7_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno7_data1_val.txt")

# pheno 9: EOS
EOS_inter_dat <- EOS_dat[EOS_dat$SNP %in% inter_snp, ]
EOS_herit_dat <- data.frame(SNP = EOS_inter_dat$SNP, 
                             N = EOS_inter_dat$N, 
                             Z = EOS_inter_dat$BETA/EOS_inter_dat$SE, 
                             A1 = EOS_inter_dat$ALT,
                             A2 = EOS_inter_dat$REF)
EOS_val_dat <- data.frame(SNP = EOS_inter_dat$SNP, 
                           A1 = EOS_inter_dat$ALT,
                           beta = EOS_inter_dat$BETA*sqrt(2*EOS_inter_dat$Frq*(1-EOS_inter_dat$Frq)))
write.table(EOS_herit_dat, file = "./02_clean/pheno9_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(EOS_val_dat, file = "./02_clean/pheno9_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno9_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno9_data1_val.txt")

# pheno 10: WBC
WBC_inter_dat <- WBC_dat[WBC_dat$SNP %in% inter_snp, ]
WBC_herit_dat <- data.frame(SNP = WBC_inter_dat$SNP, 
                             N = WBC_inter_dat$N, 
                             Z = WBC_inter_dat$BETA/WBC_inter_dat$SE, 
                             A1 = WBC_inter_dat$ALT,
                             A2 = WBC_inter_dat$REF)
WBC_val_dat <- data.frame(SNP = WBC_inter_dat$SNP, 
                           A1 = WBC_inter_dat$ALT,
                           beta = WBC_inter_dat$BETA*sqrt(2*WBC_inter_dat$Frq*(1-WBC_inter_dat$Frq)))
write.table(WBC_herit_dat, file = "./02_clean/pheno10_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(WBC_val_dat, file = "./02_clean/pheno10_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno10_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno10_data1_val.txt")

# pheno17: SBP
SBP_inter_dat <- SBP_dat[SBP_dat$SNP %in% inter_snp, ]
SBP_herit_dat <- data.frame(SNP = SBP_inter_dat$SNP, 
                            N =SBP_inter_dat$N, 
                            Z = SBP_inter_dat$BETA/SBP_inter_dat$SE,
                            A1 = SBP_inter_dat$ALT, 
                            A2 = SBP_inter_dat$REF)
SBP_val_dat <- data.frame(SNP = SBP_inter_dat$SNP, 
                          A1 = SBP_inter_dat$ALT,
                          beta = SBP_inter_dat$BETA*sqrt(2*SBP_inter_dat$Frq*(1-SBP_inter_dat$Frq)))
write.table(SBP_herit_dat, file = "./02_clean/pheno17_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(SBP_val_dat, file = "./02_clean/pheno17_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno17_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno17_data1_val.txt")

# pheno22: TC
TC_inter_dat <- TC_dat[TC_dat$SNP %in% inter_snp, ]
TC_herit_dat <- data.frame(SNP = TC_inter_dat$SNP, 
                           N = TC_inter_dat$N, 
                           Z = TC_inter_dat$BETA/TC_inter_dat$SE,
                           A1 = TC_inter_dat$ALT, 
                           A2 = TC_inter_dat$REF)
TC_val_dat <- data.frame(SNP = TC_inter_dat$SNP, 
                         A1 = TC_inter_dat$ALT,
                         beta = TC_inter_dat$BETA*sqrt(2*TC_inter_dat$Frq*(1-TC_inter_dat$Frq)))
write.table(TC_herit_dat, file = "./02_clean/pheno22_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(TC_val_dat, file = "./02_clean/pheno22_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno22_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno22_data1_val.txt")

# pheno23: HDL
HDL_inter_dat <- HDL_dat[HDL_dat$SNP %in% inter_snp, ]
HDL_herit_dat <- data.frame(SNP = HDL_inter_dat$SNP, 
                           N = HDL_inter_dat$N, 
                           Z = HDL_inter_dat$BETA/HDL_inter_dat$SE,
                           A1 = HDL_inter_dat$ALT, 
                           A2 = HDL_inter_dat$REF)
HDL_val_dat <- data.frame(SNP = HDL_inter_dat$SNP, 
                         A1 = HDL_inter_dat$ALT,
                         beta = HDL_inter_dat$BETA*sqrt(2*HDL_inter_dat$Frq*(1-HDL_inter_dat$Frq)))
write.table(HDL_herit_dat, file = "./02_clean/pheno23_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(HDL_val_dat, file = "./02_clean/pheno23_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno23_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno23_data1_val.txt")


# pheno24: LDL
LDL_inter_dat <- LDL_dat[LDL_dat$SNP %in% inter_snp, ]
LDL_herit_dat <- data.frame(SNP = LDL_inter_dat$SNP, 
                            N = LDL_inter_dat$N, 
                            Z = LDL_inter_dat$BETA/LDL_inter_dat$SE,
                            A1 = LDL_inter_dat$ALT, 
                            A2 = LDL_inter_dat$REF)
LDL_val_dat <- data.frame(SNP = LDL_inter_dat$SNP, 
                          A1 = LDL_inter_dat$ALT,
                          beta = LDL_inter_dat$BETA*sqrt(2*LDL_inter_dat$Frq*(1-LDL_inter_dat$Frq)))
write.table(LDL_herit_dat, file = "./02_clean/pheno24_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(LDL_val_dat, file = "./02_clean/pheno24_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno24_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno24_data1_val.txt")


# pheno25: TG
TG_inter_dat <- TG_dat[TG_dat$SNP %in% inter_snp, ]

TG_herit_dat <- data.frame(SNP = TG_inter_dat$SNP, 
                            N = TG_inter_dat$N, 
                            Z = TG_inter_dat$BETA/TG_inter_dat$SE,
                            A1 = TG_inter_dat$ALT, 
                            A2 = TG_inter_dat$REF)
TG_val_dat <- data.frame(SNP = TG_inter_dat$SNP, 
                          A1 = TG_inter_dat$ALT,
                          beta = TG_inter_dat$BETA*sqrt(2*TG_inter_dat$Frq*(1-TG_inter_dat$Frq)))
write.table(TG_herit_dat, file = "./02_clean/pheno25_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(TG_val_dat, file = "./02_clean/pheno25_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno25_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/03_EAS/02_clean/pheno25_data1_val.txt")

