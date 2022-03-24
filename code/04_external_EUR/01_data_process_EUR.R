rm(list=ls())
library(bigreadr)
setwd("/net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/")
load("./02_clean/hm3_snp_inter.RData")
# load all data to obtain the intersection of 30 data sets 
# pheno1: SH
## pheno1_1: Yang et al. (2012)
SH_dat1 <- fread2("./01_raw/GIANT_Yang2012Nature_publicrelease_HapMapCeuFreq_Height.txt.gz")
SH_snp_dat1 <- SH_dat1$MarkerName
cat("SNP number of SH_dat1: ", nrow(SH_dat1), "\n")
## pheno1_2: Wood et al. (2014)
SH_dat2 <- fread2("./01_raw/GIANT_HEIGHT_Wood_et_al_2014_publicrelease_HapMapCeuFreq.txt.gz")
SH_snp_dat2 <- SH_dat2$MarkerName
cat("SNP number of SH_dat2: ", nrow(SH_dat2), "\n")

# pheno2: PLT 
## pheno2_1 Ferreira et al. (2009)
PLT_dat1 <- fread2("./01_raw/PLT.assoc.gz")
PLT_snp_dat1 <- PLT_dat1$SNP
cat("SNP number of PLT_dat1: ", nrow(PLT_dat1), "\n")
## pheno2_2 Astle et al. (2016)
PLT_dat2 <- fread2("./01_raw/plt.tsv.gz")
PLT_snp_dat2 <- PLT_dat2$ID
cat("SNP number of PLT_dat2: ", nrow(PLT_dat2), "\n")

# pheno3: BMD Medina-Gomez et al.
BMD_dat <- fread2("./01_raw/METAANALYSIS2016_all_GEFOS.txt.gz")
cat("SNP number of BMD_dat: ", nrow(BMD_dat), "\n")

# pheno5: BMI
## pheno5_1 Yang et al. (2012)
BMI_dat1 <- fread2("./01_raw/GIANT_Yang2012Nature_publicrelease_HapMapCeuFreq_BMI.txt.gz")
BMI_snp_dat1 <- BMI_dat1$MarkerName
cat("SNP number of BMI_dat1: ", nrow(BMI_dat1), "\n")
## pheno5_2 Locke et al. (2015)
BMI_dat2 <- fread2("./01_raw/SNP_gwas_mc_merge_nogc.tbl.uniq.gz")
BMI_snp_dat2 <- BMI_dat2$SNP
cat("SNP number of BMI_dat2: ", nrow(BMI_dat2), "\n")

# pheno 6: RBC Ferreira et al. (2009)
RBC_dat <- fread2("./01_raw/RBC.assoc.gz")
cat("SNP number of RBC_dat: ", nrow(RBC_dat), "\n")

# pheno 7: AM !unzip files
## pheno7_1 Perry et al. (2014)
AM_dat1 <- fread2("./01_raw/Menarche_Nature2014_GWASMetaResults_17122014.txt")
AM_snp_dat1 <- AM_dat1$MarkerName
cat("SNP number of AM_dat1: ", nrow(AM_dat1), "\n")
## pheno7_2 Day et al. (2017)
AM_dat2 <- fread2("./01_raw/Menarche_1KG_NatGen2017_WebsiteUpload.txt")
cat("SNP number of AM_dat2: ", nrow(AM_dat2), "\n")

# pheno 9: EOS Ferreira et al. (2009)
EOS_dat <- fread2("./01_raw/EOS.assoc.gz")
cat("SNP number of EOS_dat: ", nrow(EOS_dat), "\n")

# pheno 10: WBC Ferreira et al. (2009)
WBC_dat <- fread2("./01_raw/WBC.assoc.gz")
cat("SNP number of WBC_dat: ", nrow(WBC_dat), "\n")

# pheno 11: FVC Shrine et al. (2019)
FVC_dat <- fread2("./01_raw/Shrine_30804560_SpiroMeta_FVC.txt.gz")
FVC_snp_dat <- FVC_dat[, 1]
cat("SNP number of FVC_dat: ", nrow(FVC_dat), "\n")

# pheno 12: FEV Shrine et al. (2019)
FEV_dat <- fread2("./01_raw/Shrine_30804560_SpiroMeta_FEV1.txt.gz")
cat("SNP number of FEV_dat: ", nrow(FEV_dat), "\n")

# pheno 13: FFR Shrine et al. (2019)
FFR_dat <- fread2("./01_raw/Shrine_30804560_SpiroMeta_FEV1_to_FVC_RATIO.txt.gz")
cat("SNP number of FFR_dat: ", nrow(FFR_dat), "\n")

# pheno 14: WC
WC_dat <- fread2("./01_raw/GIANT_2015_WC_COMBINED_EUR.txt.gz", skip = 8)
colnames(WC_dat) <- c("MarkerName", "Allele1", "Allele2", "FreqAllele1HapMapCEU", 
                      "b", "se", "p", "N")
WC_snp_dat <- WC_dat$MarkerName
cat("SNP number of WC_dat: ", nrow(WC_dat), "\n")

# pheno 15: HC
HC_dat <- fread2("./01_raw/GIANT_2015_HIP_COMBINED_EUR.txt.gz", skip = 8)
colnames(HC_dat) <- c("MarkerName", "Allele1", "Allele2", "FreqAllele1HapMapCEU", 
                      "b", "se", "p", "N")
cat("SNP number of HC_dat: ", nrow(HC_dat), "\n")

# pheno 16: WHR
WHR_dat <- fread2("./01_raw/GIANT_2015_WHR_COMBINED_EUR.txt.gz", skip = 8)
colnames(WHR_dat) <- c("MarkerName", "chr",  "pos", "Allele1", "Allele2", "FreqAllele1HapMapCEU", 
                       "b", "se", "p", "N")
cat("SNP number of WHR_dat: ", nrow(WHR_dat), "\n")

# pheno 18: BW
BW_dat <- fread2("./01_raw/EGG_BirthWeight2_DISCOVERY.txt")
BW_snp_dat <- BW_dat$SNP
cat("SNP number of BW_dat: ", nrow(BW_dat), "\n")

# pheno 22: TC  Willer et al.
TC_dat <- fread2("./01_raw/jointGwasMc_TC.txt.gz")
TC_snp_dat <- TC_dat$rsid
cat("SNP number of TC_dat: ", nrow(TC_dat), "\n")

# pheno 23: HDL
## pheno23_1: Willer et al.
HDL_dat1 <- fread2("./01_raw/jointGwasMc_HDL.txt.gz")
HDL_snp_dat1 <- HDL_dat1$rsid
cat("SNP number of HDL_dat1: ", nrow(HDL_dat1), "\n")
## pheno23_2: Kathiresan et al.
HDL_dat2 <- fread2("./01_raw/METAHDL2009.tbl")
HDL_snp_dat2 <- HDL_dat2$MarkerName
cat("SNP number of HDL_dat2: ", nrow(HDL_dat2), "\n")
## pheno23_3: Kettunen et al.
HDL_dat3 <- fread2("./01_raw/Summary_statistics_MAGNETIC_HDL.C.txt.gz")
HDL_snp_dat3 <- HDL_dat3$ID
cat("SNP number of HDL_dat3: ", nrow(HDL_dat3), "\n")

# pheno 24: LDL
## pheno 24_1: Willer et al.
LDL_dat1 <- fread2("./01_raw/jointGwasMc_LDL.txt.gz")
LDL_snp_dat1 <- LDL_dat1$rsid
cat("SNP number of LDL_dat1: ", nrow(LDL_dat1), "\n")
## pheno  23_2: Kathiresan et al.
LDL_dat2 <- fread2("./01_raw/METALDL2009.tbl")
LDL_snp_dat2 <- LDL_dat2$MarkerName
cat("SNP number of LDL_dat2: ", nrow(LDL_dat2), "\n")
## pheno23_3: Kettunen et al.
LDL_dat3 <- fread2("./01_raw/Summary_statistics_MAGNETIC_LDL.C.txt.gz")
LDL_snp_dat3 <- LDL_dat3$ID
cat("SNP number of LDL_dat3: ", nrow(LDL_dat3), "\n")

# pheno 25: TG
## pheno 25_1: Willer et al.
TG_dat1 <- fread2("./01_raw/jointGwasMc_TG.txt.gz")
TG_snp_dat1 <- TG_dat1$rsid
cat("SNP number of TG_dat1: ", nrow(TG_dat1), "\n")
## pheno 25_2: Kettunen et al.
TG_dat2 <- fread2("./01_raw/Summary_statistics_MAGNETIC_Serum.TG.txt.gz")
TG_snp_dat2 <- TG_dat2$ID
cat("SNP number of TG_dat2: ", nrow(TG_dat2), "\n")

# hm3 snp
hm3_frq <- fread2("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/hm3/geno/merge.frq")
hm3_bim <- fread2("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/hm3/geno/merge.bim")
hm3_snp <- data.frame(SNP = hm3_bim$V2, 
                      SNP_POS = paste0(hm3_bim$V1, ":", hm3_bim$V4), 
                      A1 = hm3_bim$V5, 
                      A2 = hm3_bim$V6, 
                      MAF = hm3_frq$MAF)

# intersection of the data sets
inter_snp <- Reduce(intersect, list(SH_snp_dat1, SH_snp_dat2, PLT_snp_dat1, 
                                    PLT_snp_dat2, BMI_snp_dat1, BMI_snp_dat2, 
                                    AM_snp_dat1, FVC_snp_dat, WC_snp_dat, 
                                    BW_snp_dat, TC_snp_dat, HDL_snp_dat1, 
                                    HDL_snp_dat2, HDL_snp_dat3, LDL_snp_dat1, 
                                    LDL_snp_dat2, LDL_snp_dat3, TG_snp_dat1, 
                                    TG_snp_dat2, hm3_snp[, 1]))
hm3_snp_inter <- hm3_snp[hm3_snp$SNP %in% inter_snp, ]
save(hm3_snp_inter, file = "./02_clean/hm3_snp_inter.RData")                   
                                    
# subset for each data set
# pheno1: SH
## pheno1_1: Yang et al. (2012)
SH_inter_dat1 <- SH_dat1[match(hm3_snp_inter$SNP, SH_dat1$MarkerName), ]
# SH_inter_dat1$b <- ifelse(toupper(SH_inter_dat1$Allele1)==hm3_snp_inter$A1, 
#                           SH_inter_dat1$b, -SH_inter_dat1$b)
# SH_herit_dat1 <- data.frame(SNP = SH_inter_dat1$MarkerName, 
#                             N = floor(SH_inter_dat1$N), 
#                             Z = SH_inter_dat1$b/SH_inter_dat1$se, 
#                             A1 = toupper(SH_inter_dat1$Allele1),
#                             A2 = toupper(SH_inter_dat1$Allele2))
SH_val_dat1 <- data.frame(SNP = SH_inter_dat1$MarkerName, 
                          A1 = toupper(SH_inter_dat1$Allele1),
                          beta = SH_inter_dat1$b*sqrt(2*SH_inter_dat1$Freq.Allele1.HapMapCEU*(1-SH_inter_dat1$Freq.Allele1.HapMapCEU)))
## pheno1_2: Wood et al. (2014)
SH_inter_dat2 <- SH_dat2[match(hm3_snp_inter$SNP, SH_dat2$MarkerName), ]
# SH_herit_dat2 <- data.frame(SNP = SH_inter_dat2$MarkerName, 
#                             N = SH_inter_dat2$N, 
#                             Z = SH_inter_dat2$b/SH_inter_dat2$SE, 
#                             A1 = SH_inter_dat2$Allele1,
#                             A2 = SH_inter_dat2$Allele2)
SH_val_dat2 <- data.frame(SNP = SH_inter_dat2$MarkerName, 
                          A1 = SH_inter_dat2$Allele1,
                          beta = SH_inter_dat2$b*sqrt(2*SH_inter_dat2$Freq.Allele1.HapMapCEU*(1-SH_inter_dat2$Freq.Allele1.HapMapCEU)))
SH_val_dat1[, 3] <- ifelse(sign(SH_val_dat1[, 3]) == sign(SH_val_dat2[, 3]), 
                           SH_val_dat1[, 3], -SH_val_dat1[, 3])
# write.table(SH_herit_dat1, file = "./02_clean/pheno1_data1_herit.ldsc",
#             row.names = F, quote = F)
write.table(SH_val_dat1, file = "./02_clean/pheno1_data1_val.txt", 
            row.names = F, quote = F)
# system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno1_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno1_data1_val.txt")
write.table(SH_herit_dat2, file = "./02_clean/pheno1_data2_herit.ldsc", 
            row.names = F, quote = F)
write.table(SH_val_dat2, file = "./02_clean/pheno1_data2_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno1_data2_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno1_data2_val.txt")

# pheno2: PLT 
## pheno2_1 Ferreira et al. (2009)
PLT_inter_dat1 <- PLT_dat1[PLT_dat1$SNP %in% hm3_snp_inter$SNP, ]
PLT_inter_dat1 <- merge(PLT_inter_dat1, hm3_snp_inter, by.x = "SNP", by.y = "SNP")
PLT_inter_dat1$A2.x <- ifelse(PLT_inter_dat1$A1.x == PLT_inter_dat1$A2, 
                              as.character(PLT_inter_dat1$A1.y), 
                              as.character(PLT_inter_dat1$A2))
PLT_herit_dat1 <- data.frame(SNP = PLT_inter_dat1$SNP, 
                             N = 4250, 
                             Z = PLT_inter_dat1$BETA/PLT_inter_dat1$SE, 
                             A1 = PLT_inter_dat1$A2.x,
                             A2 = PLT_inter_dat1$A1.x)
PLT_val_dat1 <- data.frame(SNP = PLT_inter_dat1$SNP, 
                           A1 = PLT_inter_dat1$A2.x,
                           beta = PLT_inter_dat1$BETA*sqrt(2*PLT_inter_dat1$MAF*(1-PLT_inter_dat1$MAF)))
write.table(PLT_herit_dat1, file = "./02_clean/pheno2_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(PLT_val_dat1, file = "./02_clean/pheno2_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno2_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno2_data1_val.txt")

## pheno2_2 Astle et al. (2016)
PLT_inter_dat2 <- PLT_dat2[PLT_dat2$ID %in% inter_snp, ]
PLT_herit_dat2 <- data.frame(SNP = PLT_inter_dat2$ID, 
                             N = 173480, 
                             Z = PLT_inter_dat2$EFFECT/PLT_inter_dat2$SE, 
                             A1 = PLT_inter_dat2$ALT,
                             A2 = PLT_inter_dat2$REF)
PLT_val_dat2 <- data.frame(SNP = PLT_inter_dat2$ID, 
                           A1 = PLT_inter_dat2$ALT,
                           beta = PLT_inter_dat2$EFFECT*sqrt(2*PLT_inter_dat2$MA_FREQ*(1-PLT_inter_dat2$MA_FREQ)))
write.table(PLT_herit_dat2, file = "./02_clean/pheno2_data2_herit.ldsc", 
            row.names = F, quote = F)
write.table(PLT_val_dat2, file = "./02_clean/pheno2_data2_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno2_data2_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno2_data2_val.txt")

# pheno3: BMD Medina-Gomez et al.
BMD_inter_dat <- BMD_dat[BMD_dat$MarkerName %in% hm3_snp_inter$SNP_POS, ]
BMD_inter_dat <- merge(BMD_inter_dat, hm3_snp_inter, 
                       by.x = "MarkerName", by.y = "SNP_POS")
BMD_herit_dat <- data.frame(SNP = BMD_inter_dat$SNP, 
                            N = 66628, 
                            Z = BMD_inter_dat$Effect/BMD_inter_dat$StdErr,
                            A1 = toupper(BMD_inter_dat$Allele1), 
                            A2 = toupper(BMD_inter_dat$Allele2))
BMD_val_dat <- data.frame(SNP = BMD_inter_dat$SNP, 
                          A1 = toupper(BMD_inter_dat$Allele1),
                          beta = BMD_inter_dat$Effect*sqrt(2*BMD_inter_dat$Freq1*(1-BMD_inter_dat$Freq1)))
write.table(BMD_herit_dat, file = "./02_clean/pheno3_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(BMD_val_dat, file = "./02_clean/pheno3_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno3_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno3_data1_val.txt")

# pheno5: BMI
## pheno5_1 Yang et al. (2012)
BMI_inter_dat1 <- BMI_dat1[BMI_dat1$MarkerName %in% hm3_snp_inter$SNP, ]
BMI_inter_dat1 <- merge(BMI_inter_dat1, hm3_snp_inter, 
                        by.x = "MarkerName", by.y = "SNP")
BMI_herit_dat1 <- data.frame(SNP = BMI_inter_dat1$MarkerName, 
                             N = floor(BMI_inter_dat1$N), 
                             Z = BMI_inter_dat1$b/BMI_inter_dat1$se,
                             A1 = toupper(BMI_inter_dat1$Allele1), 
                             A2 = toupper(BMI_inter_dat1$Allele2))
BMI_val_dat1 <- data.frame(SNP = BMI_inter_dat1$MarkerName, 
                           A1 = toupper(BMI_inter_dat1$Allele1),
                           beta = BMI_inter_dat1$b*sqrt(2*BMI_inter_dat1$MAF*(1-BMI_inter_dat1$MAF)))
write.table(BMI_herit_dat1, file = "./02_clean/pheno5_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(BMI_val_dat1, file = "./02_clean/pheno5_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno5_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno5_data1_val.txt")

## pheno5_2 Locke et al. (2015)
BMI_inter_dat2 <- BMI_dat2[BMI_dat2$SNP %in% inter_snp, ]
BMI_herit_dat2 <- data.frame(SNP = BMI_inter_dat2$SNP, 
                             N = BMI_inter_dat2$N, 
                             Z = BMI_inter_dat2$b/BMI_inter_dat2$se,
                             A1 = BMI_inter_dat2$A1, 
                             A2 = BMI_inter_dat2$A2)
BMI_val_dat2 <- data.frame(SNP = BMI_inter_dat2$SNP, 
                           A1 = BMI_inter_dat2$A1,
                           beta = BMI_inter_dat2$b*sqrt(2*BMI_inter_dat2$Freq1.Hapmap*(1-BMI_inter_dat2$Freq1.Hapmap)))
write.table(BMI_herit_dat2, file = "./02_clean/pheno5_data2_herit.ldsc", 
            row.names = F, quote = F)
write.table(BMI_val_dat2, file = "./02_clean/pheno5_data2_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno5_data2_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno5_data2_val.txt")


# pheno 6: RBC
RBC_inter_dat1 <- RBC_dat[RBC_dat$SNP %in% inter_snp, ]
RBC_inter_dat1 <- merge(RBC_inter_dat1, hm3_snp_inter, by.x = "SNP", by.y = "SNP")
RBC_inter_dat1$A2.x <- ifelse(RBC_inter_dat1$A1.x == RBC_inter_dat1$A2, 
                              as.character(RBC_inter_dat1$A1.y), 
                              as.character(RBC_inter_dat1$A2))
RBC_herit_dat1 <- data.frame(SNP = RBC_inter_dat1$SNP, 
                             N = 4250, 
                             Z = RBC_inter_dat1$BETA/RBC_inter_dat1$SE, 
                             A1 = RBC_inter_dat1$A2.x,
                             A2 = RBC_inter_dat1$A1.x)
RBC_val_dat1 <- data.frame(SNP = RBC_inter_dat1$SNP, 
                           A1 = RBC_inter_dat1$A2.x,
                           beta = RBC_inter_dat1$BETA*sqrt(2*RBC_inter_dat1$MAF*(1-RBC_inter_dat1$MAF)))
write.table(RBC_herit_dat1, file = "./02_clean/pheno6_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(RBC_val_dat1, file = "./02_clean/pheno6_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno6_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno6_data1_val.txt")

# pheno 7: AM 
## pheno7_1 Perry et al. (2014)
AM_inter_dat1 <- AM_dat1[AM_dat1$MarkerName %in% hm3_snp_inter$SNP, ]
AM_inter_dat1 <- merge(AM_inter_dat1, hm3_snp_inter, 
                       by.x = "MarkerName", by.y = "SNP")
AM_inter_dat1$GWAS_Beta <- ifelse(toupper(AM_inter_dat1$Effect_Allele) == AM_inter_dat1$A1, 
                                  AM_inter_dat1$GWAS_Beta, 
                                  -AM_inter_dat1$GWAS_Beta)
Z_abs <- ifelse(AM_inter_dat1$GWAS_P == 0, 12.51475, qnorm(AM_inter_dat1$GWAS_P/2))
Z_abs <- ifelse(AM_inter_dat1$GWAS_P == 1, 1e-100, Z_abs)
AM_herit_dat1 <- data.frame(SNP = AM_inter_dat1$MarkerName, 
                            N = 49427, 
                            Z = ifelse(AM_inter_dat1$GWAS_Beta>0, Z_abs, -Z_abs), 
                            A1 = toupper(AM_inter_dat1$Effect_Allele),
                            A2 = toupper(AM_inter_dat1$Other_Allele))
AM_val_dat1 <- data.frame(SNP = AM_inter_dat1$MarkerName, 
                          A1 = AM_inter_dat1$A1,
                          beta = AM_inter_dat1$GWAS_Beta*sqrt(2*AM_inter_dat1$HapMap_Freq*(1-AM_inter_dat1$HapMap_Freq)))
write.table(AM_herit_dat1, file = "./02_clean/pheno7_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(AM_val_dat1, file = "./02_clean/pheno7_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno7_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno7_data1_val.txt")

## pheno7_2 Day et al. (2017)
hm3_snp_inter$SNP_POS_CHR <- paste0("chr", hm3_snp_inter$SNP_POS)
AM_inter_dat2 <- AM_dat2[AM_dat2$Markername %in% hm3_snp_inter$SNP_POS_CHR, ]
AM_inter_dat2 <- merge(AM_inter_dat2, hm3_snp_inter, by.x = "Markername", 
                       by.y = "SNP_POS_CHR")
Z_abs <- ifelse(AM_inter_dat2$Pvalue == 0, 26.81108, qnorm(AM_inter_dat2$Pvalue/2))
# qnorm(min(AM_inter_dat2$Pvalue[AM_inter_dat2$Pvalue!=0]))
AM_herit_dat2 <- data.frame(SNP = AM_inter_dat2$SNP, 
                            N = 329345, 
                            Z = ifelse(AM_inter_dat2$Effect>0, Z_abs, -Z_abs), 
                            A1 = toupper(AM_inter_dat2$Allele1),
                            A2 = toupper(AM_inter_dat2$Allele2))
AM_val_dat2 <- data.frame(SNP = AM_inter_dat2$SNP, 
                          A1 = toupper(AM_inter_dat2$Allele1),
                          beta = AM_inter_dat2$Effect*sqrt(2*AM_inter_dat2$MAF*(1-AM_inter_dat2$MAF)))
write.table(AM_herit_dat2, file = "./02_clean/pheno7_data2_herit.ldsc", 
            row.names = F, quote = F)
write.table(AM_val_dat2, file = "./02_clean/pheno7_data2_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno7_data2_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno7_data2_val.txt")

# pheno 9: EOS
EOS_inter_dat1 <- EOS_dat[EOS_dat$SNP %in% inter_snp, ]
EOS_inter_dat1 <- merge(EOS_inter_dat1, hm3_snp_inter, by.x = "SNP", by.y = "SNP")
EOS_inter_dat1$A2.x <- ifelse(EOS_inter_dat1$A1.x == EOS_inter_dat1$A2, 
                              as.character(EOS_inter_dat1$A1.y), 
                              as.character(EOS_inter_dat1$A2))
EOS_herit_dat1 <- data.frame(SNP = EOS_inter_dat1$SNP, 
                             N = 4250, 
                             Z = EOS_inter_dat1$BETA/EOS_inter_dat1$SE, 
                             A1 = EOS_inter_dat1$A2.x,
                             A2 = EOS_inter_dat1$A1.x)
EOS_val_dat1 <- data.frame(SNP = EOS_inter_dat1$SNP, 
                           A1 = EOS_inter_dat1$A2.x,
                           beta = EOS_inter_dat1$BETA*sqrt(2*EOS_inter_dat1$MAF*(1-EOS_inter_dat1$MAF)))
write.table(EOS_herit_dat1, file = "./02_clean/pheno9_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(EOS_val_dat1, file = "./02_clean/pheno9_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno9_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno9_data1_val.txt")

# pheno 10: WBC
WBC_inter_dat1 <- WBC_dat[WBC_dat$SNP %in% inter_snp, ]
WBC_inter_dat1 <- merge(WBC_inter_dat1, hm3_snp_inter, by.x = "SNP", by.y = "SNP")
WBC_inter_dat1$A2.x <- ifelse(WBC_inter_dat1$A1.x == WBC_inter_dat1$A2, 
                              as.character(WBC_inter_dat1$A1.y), 
                              as.character(WBC_inter_dat1$A2))
WBC_herit_dat1 <- data.frame(SNP = WBC_inter_dat1$SNP, 
                             N = 4250, 
                             Z = WBC_inter_dat1$BETA/WBC_inter_dat1$SE, 
                             A1 = WBC_inter_dat1$A2.x,
                             A2 = WBC_inter_dat1$A1.x)
WBC_val_dat1 <- data.frame(SNP = WBC_inter_dat1$SNP, 
                           A1 = WBC_inter_dat1$A2.x,
                           beta = WBC_inter_dat1$BETA*sqrt(2*WBC_inter_dat1$MAF*(1-WBC_inter_dat1$MAF)))
write.table(WBC_herit_dat1, file = "./02_clean/pheno10_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(WBC_val_dat1, file = "./02_clean/pheno10_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno10_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno10_data1_val.txt")

# pheno 11: FVC
FVC_inter_dat1 <- FVC_dat[FVC_dat[, 1] %in% inter_snp, ]
FVC_herit_dat1 <- data.frame(SNP = FVC_inter_dat1[, 1], 
                             N = FVC_inter_dat1$N, 
                             Z = FVC_inter_dat1$beta/FVC_inter_dat1$SE, 
                             A1 = FVC_inter_dat1$Coded,
                             A2 = FVC_inter_dat1$Non_coded)
FVC_val_dat1 <- data.frame(SNP = FVC_inter_dat1[, 1], 
                           A1 = FVC_inter_dat1$Coded,
                           beta = FVC_inter_dat1$beta*sqrt(2*FVC_inter_dat1$Coded_freq*(1-FVC_inter_dat1$Coded_freq)))
write.table(FVC_herit_dat1, file = "./02_clean/pheno11_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(FVC_val_dat1, file = "./02_clean/pheno11_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno11_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno11_data1_val.txt")

# pheno 12: FEV
FEV_inter_dat1 <- FEV_dat[FEV_dat[, 1] %in% inter_snp, ]
FEV_herit_dat1 <- data.frame(SNP = FEV_inter_dat1[, 1], 
                             N = FEV_inter_dat1$N, 
                             Z = FEV_inter_dat1$beta/FEV_inter_dat1$SE, 
                             A1 = FEV_inter_dat1$Coded,
                             A2 = FEV_inter_dat1$Non_coded)
FEV_val_dat1 <- data.frame(SNP = FEV_inter_dat1[, 1], 
                           A1 = FEV_inter_dat1$Coded,
                           beta = FEV_inter_dat1$beta*sqrt(2*FEV_inter_dat1$Coded_freq*(1-FEV_inter_dat1$Coded_freq)))
write.table(FEV_herit_dat1, file = "./02_clean/pheno12_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(FEV_val_dat1, file = "./02_clean/pheno12_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno12_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno12_data1_val.txt")

# pheno 13: FFR
FFR_inter_dat1 <- FFR_dat[FFR_dat[, 1] %in% inter_snp, ]
FFR_herit_dat1 <- data.frame(SNP = FFR_inter_dat1[, 1], 
                             N = FFR_inter_dat1$N, 
                             Z = FFR_inter_dat1$beta/FFR_inter_dat1$SE, 
                             A1 = FFR_inter_dat1$Coded,
                             A2 = FFR_inter_dat1$Non_coded)
FFR_val_dat1 <- data.frame(SNP = FFR_inter_dat1[, 1], 
                           A1 = FFR_inter_dat1$Coded,
                           beta = FFR_inter_dat1$beta*sqrt(2*FFR_inter_dat1$Coded_freq*(1-FFR_inter_dat1$Coded_freq)))
write.table(FFR_herit_dat1, file = "./02_clean/pheno13_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(FFR_val_dat1, file = "./02_clean/pheno13_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno13_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno13_data1_val.txt")

# pheno 14: WC
WC_inter_dat1 <- WC_dat[WC_dat$MarkerName %in% inter_snp, ]
WC_herit_dat1 <- data.frame(SNP = WC_inter_dat1$MarkerName, 
                            N = WC_inter_dat1$N, 
                            Z = WC_inter_dat1$b/WC_inter_dat1$se, 
                            A1 = WC_inter_dat1$Allele1,
                            A2 = WC_inter_dat1$Allele2)
WC_val_dat1 <- data.frame(SNP = WC_inter_dat1$MarkerName, 
                          A1 = WC_inter_dat1$Allele1,
                          beta = WC_inter_dat1$b*sqrt(2*WC_inter_dat1$FreqAllele1HapMapCEU*(1-WC_inter_dat1$FreqAllele1HapMapCEU)))
write.table(WC_herit_dat1, file = "./02_clean/pheno14_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(WC_val_dat1, file = "./02_clean/pheno14_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno14_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno14_data1_val.txt")

# pheno 15: HC
HC_inter_dat1 <- HC_dat[HC_dat$MarkerName %in% inter_snp, ]
HC_herit_dat1 <- data.frame(SNP = HC_inter_dat1$MarkerName, 
                            N = HC_inter_dat1$N, 
                            Z = HC_inter_dat1$b/HC_inter_dat1$se, 
                            A1 = HC_inter_dat1$Allele1,
                            A2 = HC_inter_dat1$Allele2)
HC_val_dat1 <- data.frame(SNP = HC_inter_dat1$MarkerName, 
                          A1 = HC_inter_dat1$Allele1,
                          beta = HC_inter_dat1$b*sqrt(2*HC_inter_dat1$FreqAllele1HapMapCEU*(1-HC_inter_dat1$FreqAllele1HapMapCEU)))
write.table(HC_herit_dat1, file = "./02_clean/pheno15_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(HC_val_dat1, file = "./02_clean/pheno15_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno15_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno15_data1_val.txt")

# pheno 16: WHR
WHR_inter_dat1 <- WHR_dat[WHR_dat$MarkerName %in% inter_snp, ]
WHR_herit_dat1 <- data.frame(SNP = WHR_inter_dat1$MarkerName, 
                             N = WHR_inter_dat1$N, 
                             Z = WHR_inter_dat1$b/WHR_inter_dat1$se, 
                             A1 = WHR_inter_dat1$Allele1,
                             A2 = WHR_inter_dat1$Allele2)
WHR_val_dat1 <- data.frame(SNP = WHR_inter_dat1$MarkerName, 
                           A1 = WHR_inter_dat1$Allele1,
                           beta = WHR_inter_dat1$b*sqrt(2*WHR_inter_dat1$FreqAllele1HapMapCEU*(1-WHR_inter_dat1$FreqAllele1HapMapCEU)))
write.table(WHR_herit_dat1, file = "./02_clean/pheno16_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(WHR_val_dat1, file = "./02_clean/pheno16_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno16_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno16_data1_val.txt")

# pheno 18: BW
BW_inter_dat1 <- BW_dat[BW_dat$SNP %in% hm3_snp_inter$SNP, ]
BW_inter_dat1 <- merge(BW_inter_dat1, hm3_snp_inter, 
                       by.x = "SNP", by.y = "SNP")
BW_inter_dat1$EFFECT <- ifelse(toupper(BW_inter_dat1$EFFECT_ALLELE) == BW_inter_dat1$A1, 
                               BW_inter_dat1$EFFECT, 
                               -BW_inter_dat1$EFFECT)
BW_herit_dat1 <- data.frame(SNP = BW_inter_dat1$SNP, 
                            N = 69308,
                            Z = BW_inter_dat1$EFFECT/BW_inter_dat1$SE, 
                            A1 = toupper(BW_inter_dat1$EFFECT_ALLELE),
                            A2 = toupper(BW_inter_dat1$OTHER_ALLELE))
BW_val_dat1 <- data.frame(SNP = BW_inter_dat1$SNP, 
                          A1 = BW_inter_dat1$A1,
                          beta = BW_inter_dat1$EFFECT*sqrt(2*BW_inter_dat1$MAF*(1-BW_inter_dat1$MAF)))
write.table(BW_herit_dat1, file = "./02_clean/pheno18_data1_herit.ldsc", 
            row.names = F, quote = F)
write.table(BW_val_dat1, file = "./02_clean/pheno18_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno18_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno18_data1_val.txt")

# pheno 22: TC 
TC_inter_dat1 <- TC_dat[TC_dat$rsid %in% hm3_snp_inter$SNP, ]
TC_inter_dat1 <- merge(TC_inter_dat1, hm3_snp_inter, 
                       by.x = "rsid", by.y = "SNP")
TC_inter_dat1$beta <- ifelse(toupper(TC_inter_dat1$A1.x) == TC_inter_dat1$A1.y, 
                             TC_inter_dat1$beta, 
                              -TC_inter_dat1$beta)
# TC_herit_dat1 <- data.frame(SNP = TC_inter_dat1$rsid, 
#                             N = TC_inter_dat1$N,
#                             Z = TC_inter_dat1$beta/TC_inter_dat1$se, 
#                             A1 = toupper(TC_inter_dat1$A1.y),
#                             A2 = toupper(TC_inter_dat1$A2.y))
TC_val_dat1 <- data.frame(SNP = TC_inter_dat1$rsid, 
                          A1 = TC_inter_dat1$A1.y,
                          beta = TC_inter_dat1$beta*sqrt(2*TC_inter_dat1$Freq.A1.1000G.EUR*(1-TC_inter_dat1$Freq.A1.1000G.EUR)))
# write.table(TC_herit_dat1, file = "./02_clean/pheno22_data1_herit.ldsc", 
#             row.names = F, quote = F)
write.table(TC_val_dat1, file = "./02_clean/pheno22_data1_val.txt", 
            row.names = F, quote = F)
# system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno22_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno22_data1_val.txt")

# pheno 23: HDL
## pheno23_1: Willer et al.
HDL_inter_dat1 <- HDL_dat1[HDL_dat1$rsid %in% hm3_snp_inter$SNP, ]
HDL_inter_dat1 <- merge(HDL_inter_dat1, hm3_snp_inter, 
                        by.x = "rsid", by.y = "SNP")
HDL_inter_dat1$beta <- ifelse(toupper(HDL_inter_dat1$A1.x) == HDL_inter_dat1$A1.y, 
                              HDL_inter_dat1$beta, 
                              -HDL_inter_dat1$beta)
# HDL_herit_dat1 <- data.frame(SNP = HDL_inter_dat1$rsid, 
#                              N = HDL_inter_dat1$N,
#                              Z = HDL_inter_dat1$beta/HDL_inter_dat1$se, 
#                              A1 = toupper(HDL_inter_dat1$A1.y),
#                              A2 = toupper(HDL_inter_dat1$A2.y))
HDL_val_dat1 <- data.frame(SNP = HDL_inter_dat1$rsid, 
                           A1 = toupper(HDL_inter_dat1$A1.y),
                           beta = HDL_inter_dat1$beta*sqrt(2*HDL_inter_dat1$MAF*(1-HDL_inter_dat1$MAF)))
# write.table(HDL_herit_dat1, file = "./02_clean/pheno23_data1_herit.ldsc", 
#             row.names = F, quote = F)
write.table(HDL_val_dat1x, file = "./02_clean/pheno23_data1_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno23_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno23_data1_val.txt")
## pheno23_2: Kathiresan et al.
HDL_inter_dat2 <- HDL_dat2[HDL_dat2$MarkerName %in% hm3_snp_inter$SNP, ]
HDL_inter_dat2 <- merge(HDL_inter_dat2, hm3_snp_inter, 
                        by.x = "MarkerName", by.y = "SNP")
HDL_inter_dat2$Zscore <- ifelse(toupper(HDL_inter_dat2$Allele1) == HDL_inter_dat2$A1, 
                                HDL_inter_dat2$Zscore, 
                                -HDL_inter_dat2$Zscore)
HDL_herit_dat2 <- data.frame(SNP = HDL_inter_dat2$MarkerName, 
                             N = HDL_inter_dat2$Weight,
                             Z = HDL_inter_dat2$Zscore, 
                             A1 = toupper(HDL_inter_dat2$Allele1),
                             A2 = toupper(HDL_inter_dat2$Allele2))
HDL_val_dat2 <- data.frame(SNP = HDL_inter_dat2$MarkerName, 
                           A1 = toupper(HDL_inter_dat2$A1),
                           beta = HDL_inter_dat2$Zscore/sqrt(HDL_inter_dat2$Weight))
write.table(HDL_herit_dat2, file = "./02_clean/pheno23_data2_herit.ldsc", 
            row.names = F, quote = F)
write.table(HDL_val_dat2, file = "./02_clean/pheno23_data2_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno23_data2_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno23_data2_val.txt")
## pheno23_3: Kettunen et al.
HDL_inter_dat3 <- HDL_dat3[HDL_dat3$ID %in% inter_snp, ]
HDL_inter_dat3 <- merge(HDL_inter_dat3, hm3_snp_inter, by.x = "ID", by.y = "SNP")
HDL_herit_dat3 <- data.frame(SNP = HDL_inter_dat3$ID, 
                             N = HDL_inter_dat3$n_samples,
                             Z = HDL_inter_dat3$beta/HDL_inter_dat3$se, 
                             A1 = toupper(HDL_inter_dat3$EA),
                             A2 = toupper(HDL_inter_dat3$NEA))
HDL_val_dat3 <- data.frame(SNP = HDL_inter_dat3$ID, 
                           A1 = HDL_inter_dat3$EA,
                           beta = HDL_inter_dat3$beta*sqrt(2*HDL_inter_dat3$MAF*(1-HDL_inter_dat3$MAF)))
write.table(HDL_herit_dat3, file = "./02_clean/pheno23_data3_herit.ldsc", 
            row.names = F, quote = F)
write.table(HDL_val_dat3, file = "./02_clean/pheno23_data3_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno23_data3_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno23_data3_val.txt")

# pheno 24: LDL
## pheno 24_1: Willer et al.
LDL_inter_dat1 <- LDL_dat1[LDL_dat1$rsid %in% hm3_snp_inter$SNP, ]
LDL_inter_dat1 <- merge(LDL_inter_dat1, hm3_snp_inter, 
                        by.x = "rsid", by.y = "SNP")
LDL_inter_dat1$beta <- ifelse(toupper(LDL_inter_dat1$A1.x) == LDL_inter_dat1$A1.y, 
                              LDL_inter_dat1$beta, 
                              -LDL_inter_dat1$beta)
LDL_herit_dat1 <- data.frame(SNP = LDL_inter_dat1$rsid, 
                             N = LDL_inter_dat1$N,
                             Z = LDL_inter_dat1$beta/LDL_inter_dat1$se, 
                             A1 = toupper(LDL_inter_dat1$A1.y),
                             A2 = toupper(LDL_inter_dat1$A2.y))
LDL_val_dat1 <- data.frame(SNP = LDL_inter_dat1$rsid, 
                           A1 = LDL_inter_dat1$A1.y,
                           beta = LDL_inter_dat1$beta*sqrt(2*LDL_inter_dat1$MAF*(1-LDL_inter_dat1$MAF)))
# write.table(LDL_herit_dat1, file = "./02_clean/pheno24_data1_herit.ldsc", 
#             row.names = F, quote = F)
write.table(LDL_val_dat1, file = "./02_clean/pheno24_data1_val.txt", 
            row.names = F, quote = F)
# system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno24_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno24_data1_val.txt")
## pheno  24_2: Kathiresan et al.
LDL_inter_dat2 <- LDL_dat2[LDL_dat2$MarkerName %in% hm3_snp_inter$SNP, ]
LDL_inter_dat2 <- merge(LDL_inter_dat2, hm3_snp_inter, 
                        by.x = "MarkerName", by.y = "SNP")
LDL_inter_dat2$Zscore <- ifelse(toupper(LDL_inter_dat2$Allele1) == LDL_inter_dat2$A1, 
                                LDL_inter_dat2$Zscore, 
                                -LDL_inter_dat2$Zscore)
LDL_herit_dat2 <- data.frame(SNP = LDL_inter_dat2$MarkerName, 
                             N = LDL_inter_dat2$Weight,
                             Z = LDL_inter_dat2$Zscore, 
                             A1 = toupper(LDL_inter_dat2$Allele1),
                             A2 = toupper(LDL_inter_dat2$Allele2))
LDL_val_dat2 <- data.frame(SNP = LDL_inter_dat2$MarkerName, 
                           A1 = LDL_inter_dat2$A1,
                           beta = LDL_inter_dat2$Zscore/sqrt(LDL_inter_dat2$Weight))
write.table(LDL_herit_dat2, file = "./02_clean/pheno24_data2_herit.ldsc", 
            row.names = F, quote = F)
write.table(LDL_val_dat2, file = "./02_clean/pheno24_data2_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno24_data2_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno24_data2_val.txt")
## pheno24_3: Kettunen et al.
LDL_inter_dat3 <- LDL_dat3[LDL_dat3$ID %in% hm3_snp_inter$SNP, ]
LDL_herit_dat3 <- data.frame(SNP = LDL_inter_dat3$ID, 
                             N = LDL_inter_dat3$n_samples,
                             Z = LDL_inter_dat3$beta/LDL_inter_dat3$se, 
                             A1 = LDL_inter_dat3$EA,
                             A2 = LDL_inter_dat3$NEA)
LDL_val_dat3 <- data.frame(SNP = LDL_inter_dat3$ID, 
                           A1 = LDL_inter_dat3$EA,
                           beta = LDL_inter_dat3$beta*sqrt(2*LDL_inter_dat3$eaf*(1-LDL_inter_dat3$MAF)))
write.table(LDL_herit_dat3, file = "./02_clean/pheno24_data3_herit.ldsc", 
            row.names = F, quote = F)
write.table(LDL_val_dat3, file = "./02_clean/pheno24_data3_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno24_data3_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno24_data3_val.txt")

# pheno 25: TG
## pheno 25_1: Willer et al.
TG_inter_dat1 <- TG_dat1[TG_dat1$rsid %in% hm3_snp_inter$SNP, ]
TG_inter_dat1 <- merge(TG_inter_dat1, hm3_snp_inter, 
                       by.x = "rsid", by.y = "SNP")
TG_inter_dat1$beta <- ifelse(toupper(TG_inter_dat1$A1.x) == TG_inter_dat1$A1.y, 
                             TG_inter_dat1$beta, 
                              -TG_inter_dat1$beta)
# TG_herit_dat1 <- data.frame(SNP = TG_inter_dat1$rsid, 
#                             N = TG_inter_dat1$N,
#                             Z = TG_inter_dat1$beta/TG_inter_dat1$se, 
#                             A1 = toupper(TG_inter_dat1$A1.y),
#                             A2 = toupper(TG_inter_dat1$A2.y))
TG_val_dat1 <- data.frame(SNP = TG_inter_dat1$rsid, 
                          A1 = toupper(TG_inter_dat1$A1.y),
                          beta = TG_inter_dat1$beta*sqrt(2*TG_inter_dat1$MAF*(1-TG_inter_dat1$MAF)))
# write.table(TG_herit_dat1, file = "./02_clean/pheno25_data1_herit.ldsc", 
#             row.names = F, quote = F)
write.table(TG_val_dat1, file = "./02_clean/pheno25_data1_val.txt", 
            row.names = F, quote = F)
# system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno25_data1_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno25_data1_val.txt")
## pheno 25_2: Kettunen et al.
TG_inter_dat2 <- TG_dat2[TG_dat2$ID %in% hm3_snp_inter$SNP, ]
TG_inter_dat2 <- merge(TG_inter_dat2, hm3_snp_inter, 
                       by.x = "ID", by.y = "SNP")
TG_inter_dat2$beta <- ifelse(toupper(TG_inter_dat2$EA) == TG_inter_dat2$A1, 
                                TG_inter_dat2$beta, 
                                -TG_inter_dat2$beta)
TG_herit_dat2 <- data.frame(SNP = TG_inter_dat2$ID, 
                            N = TG_inter_dat2$n_samples,
                            Z = TG_inter_dat2$beta/TG_inter_dat2$se, 
                            A1 = TG_inter_dat2$EA,
                            A2 = TG_inter_dat2$NEA)
TG_val_dat2 <- data.frame(SNP = TG_inter_dat2$ID, 
                          A1 = TG_inter_dat2$EA,
                          beta = TG_inter_dat2$beta*sqrt(2*TG_inter_dat2$eaf*(1-TG_inter_dat2$eaf)))
write.table(TG_herit_dat2, file = "./02_clean/pheno25_data2_herit.ldsc", 
            row.names = F, quote = F)
write.table(TG_val_dat2, file = "./02_clean/pheno25_data2_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno25_data2_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/pheno25_data2_val.txt")
