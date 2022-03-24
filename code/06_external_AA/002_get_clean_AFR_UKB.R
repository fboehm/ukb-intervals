#! /usr/bin/env Rscript
rm(list=ls())
library(plyr)

# load data
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
load(paste0(comp_str, "02_pheno/08_pheno_AFR/01_sqc.RData"))
load(paste0(comp_str, "02_pheno/08_pheno_AFR/02_pheno_c_raw.RData"))
load(paste0(comp_str, "02_pheno/08_pheno_AFR/03_pheno_b_raw.RData"))

# continuous traits
pheno_c_all <- matrix(NA, ncol = 25, nrow = nrow(pheno_c_AFR))
pheno_c_all[, 1] <- pheno_c_AFR[, 2]                      # 1.  SH, n = 336405
pheno_c_all[, 2] <- pheno_c_AFR[, 3]                      # 2.  PLT, n = 327153
pheno_c_all[, 3] <- pheno_c_AFR[, 4]                      # 3.  BMD, n = 194266
pheno_c_all[, 4] <- pheno_c_AFR[, 5]                      # 4.  BMR, n = 331239
pheno_c_all[, 5] <- pheno_c_AFR[, 6]                      # 5.  BMI, n = 336038
pheno_c_all[, 6] <- pheno_c_AFR[, 7]                      # 6.  RBC, n = 327152
pheno_c_all[, 7] <- pheno_c_AFR[, 8]                      # 7.  AM, n = 181021
pheno_c_all[, 8] <- pheno_c_AFR[, 9]                      # 8.  RDW, n = 327152
pheno_c_all[, 9] <- pheno_c_AFR[, 10]                     # 9.  EOS, n = 326587
pheno_c_all[, 10] <- pheno_c_AFR[, 11]                    # 10. WBC, n = 327150
pheno_c_all[, 11] <- pheno_c_AFR[, 12]                    # 11. FVC, n = 307573
pheno_c_all[, 12] <- pheno_c_AFR[, 13]                    # 12. FEV, n = 307573
pheno_c_all[, 13] <- pheno_c_AFR[, 13]/pheno_c_AFR[, 12]   # 13. FFR, n = 307573
pheno_c_all[, 14] <- pheno_c_AFR[, 14]                    # 14. WC, n = 336569
pheno_c_all[, 15] <- pheno_c_AFR[, 15]                    # 15. HC, n = 336531
pheno_c_all[, 16] <- pheno_c_AFR[, 14]/pheno_c_AFR[, 15]   # 16. WHR, n = 336499
pheno_c_all[, 17] <- pheno_c_AFR[, 16]                    # 17. SBP, n = 314907
pheno_c_all[, 18] <- pheno_c_AFR[, 17]                    # 18. BW, n = 193026
pheno_c_all[, 19] <- pheno_c_AFR[, 18]                    # 19. BFP, n = 331049
pheno_c_all[, 20] <- pheno_c_AFR[, 19]                    # 20. TFP, n = 331045
pheno_c_all[, 21] <- pheno_c_AFR[, 20]                    # 21. SU, n = 326762
pheno_c_all[, 22] <- pheno_c_AFR[, 21]                    # 22. CH, n = 321416
pheno_c_all[, 23] <- pheno_c_AFR[, 22]                    # 23. HDL, n = 294227
pheno_c_all[, 24] <- pheno_c_AFR[, 23]                    # 24. LDL, n = 320810
pheno_c_all[, 25] <- pheno_c_AFR[, 24]                    # 25. TC, n = 321152


# adjust PC for 25 continuous traits and 10-fold cross veidation
PC <- sqc_i_AFR[, which(colnames(sqc_i_AFR)%in%paste0("PC", 1:20))]
sex <- sqc_i_AFR[, which(colnames(sqc_i_AFR)%in%"Inferred.Gender")]
covVar <- as.matrix(cbind(PC[, c(1:10)], ifelse(sex == "F", 0, 1)))
pheno_c_adj_AFR <- matrix(NA, nrow = nrow(pheno_c_all), ncol = 25)
for (i in 1: 25){  
  na_idx <- ifelse(is.na(pheno_c_all[, i]), T, F)
  pheno_na <- ifelse(na_idx, NA, pheno_c_all[, i])
  pheno_scale <- scale(pheno_na)
  resid <- lm(pheno_scale[!na_idx] ~ covVar[!na_idx, ])$residual
  pheno_c_adj_AFR[!na_idx, i] <- qqnorm(resid, plot.it = F)$x
  pheno_c_adj_AFR[na_idx, i] <- NA
  cat(paste0("pheno: ", i, ", sample size: ", 
             length(pheno_c_adj_AFR[!na_idx, i]), "\n"))
}
save(pheno_c_adj_AFR, file = paste0(comp_str, "/02_pheno/08_pheno_AFR/04_pheno_c_adj.RData"))


# binary traits
df_cancer0 <- pheno_b_AFR[, colnames(pheno_b_AFR)%in%paste0("2453-", 0:2, ".0")]
df_cancer1 <-  pheno_b_AFR[, colnames(pheno_b_AFR)%in%c(paste0("20001-0.", 0:5),
                                                        paste0("20001-1.", 0:5),
                                                        paste0("20001-2.", 0:5))]
df_cancer2 <-  pheno_b_AFR[, colnames(pheno_b_AFR)%in% c(paste0("40001-", 0:2, ".0"),
                                                         paste0("40002-0.", 0:13),
                                                         paste0("40002-1.", 0:13),
                                                         paste0("40002-2.", 0:13),
                                                         paste0("40006-", 0:31, ".0"),
                                                         paste0("41202-0.", 0:379),
                                                         paste0("41204-0.", 0:434))]
df_illness <- pheno_b_AFR[, colnames(pheno_b_AFR)%in% c(paste0("20002-0.", 0:28),
                                                        paste0("20002-1.", 0:28),
                                                        paste0("20002-2.", 0:28))]
df_ICD10 <- pheno_b_AFR[, colnames(pheno_b_AFR)%in% c(paste0("40001-", 0:2, ".0"),
                                                      paste0("40002-0.", 0:13),
                                                      paste0("40002-1.", 0:13),
                                                      paste0("40002-2.", 0:13),
                                                      paste0("41202-0.", 0:379),
                                                      paste0("41204-0.", 0:434))]
df_heart <- pheno_b_AFR[, colnames(pheno_b_AFR)%in% c(paste0("6150-0.", 0:3),
                                                      paste0("6150-1.", 0:3),
                                                      paste0("6150-2.", 0:3))]

## PRCA
ind_PRCA <- unique(unlist(c(
  lapply(df_cancer1, function(x) which(x == 1044)),
  lapply(df_cancer2, function(x) which(x %in% c("C61", "D075")))
)))
PRCA <- rep(NA, nrow(pheno_b_AFR))
PRCA[rowMeans(df_cancer0 == 0, na.rm = TRUE) == 1] <- 0
PRCA[ind_PRCA] <- 1
PRCA[sex == "F"] <- NA

## TA
TA_code <- which(colnames(pheno_b_AFR) %in% paste0("1727-0.", 0))
na_idx <- ifelse(pheno_b_AFR[, TA_code] == -3 | pheno_b_AFR[, TA_code] == -1 | is.na(pheno_b_AFR[, TA_code]), T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, TA_code])
TA <- ifelse(pheno_na == 1, 1, 0)

## T2D
ind_diabetes <- unique(unlist(c(
  lapply(df_illness, function(x) which(x %in% 1220:1223)),
  lapply(df_ICD10, function(x) which(substr(x, 1, 3) %in% paste0("E", 10:14)))
)))
ind_TD1 <- unique(unlist(c(
  lapply(df_illness, function(x) which(x == 1222)),
  lapply(df_ICD10, function(x) which(substr(x, 1, 3) == "E10"))
)))
ind_TD2 <- unique(unlist(c(
  lapply(df_illness, function(x) which(x == 1223)),
  lapply(df_ICD10, function(x) which(substr(x, 1, 3) == "E11"))
)))
TD2 <- rep(0, nrow(pheno_b_AFR))
TD2[ind_diabetes] <- NA
TD2[ind_TD2] <- 1
TD2[ind_TD1] <- NA

## CAD
ind_CAD <- unique(unlist(c(
  lapply(df_heart,   function(x) which(x == 1)),
  lapply(df_illness, function(x) which(x == 1075)),
  lapply(df_ICD10,   function(x) which(substr(x, 1, 3) %in% paste0("I", 21:23))),
  lapply(df_ICD10,   function(x) which(x == "I252"))
)))
ind_heart <- unique(unlist(c(
  lapply(df_heart,   function(x) which(x %in% 1:3)),
  lapply(df_illness, function(x) which(x %in% 1074:1080)),
  lapply(df_ICD10,   function(x) which(substr(x, 1, 1) == "I"))
)))
CAD <- rep(0, nrow(pheno_b_AFR)) 
CAD[ind_heart] <- NA
CAD[ind_CAD] <- 1

## RA
ind_RA <- unique(unlist(c(
  lapply(df_illness, function(x) which(x == 1464)),
  lapply(df_ICD10,   function(x) which(substr(x, 1, 3) %in% c("M05", "M06")))
)))
ind_muscu <- unique(unlist(c(
  lapply(df_illness, function(x) which(x %in% c(1295, 1464:1467, 1477, 1538))),
  lapply(df_ICD10,   function(x) which(substr(x, 1, 1) == "M"))
)))
RA <- rep(0,nrow(pheno_b_AFR))
RA[ind_muscu] <- NA
RA[ind_RA] <- 1

## BRCA
ind_BRCA <- unique(unlist(c(
  lapply(df_cancer1,  function(x) which(x == 1002)),
  lapply(df_cancer2, function(x) which(substr(x, 1, 3) %in% c("C50", "D05")))
)))
BRCA <- rep(NA, nrow(pheno_b_AFR))
BRCA[rowMeans(df_cancer0 == 0, na.rm = TRUE) == 1] <- 0
BRCA[ind_BRCA] <- 1
BRCA[sex == "M"] <- NA

## Asthma
ind_asthma <- sort(unique(unlist(c(
  lapply(df_illness, function(x) which(x == 1111)),
  lapply(df_ICD10,   function(x) which(substr(x, 1, 3) == "J45"))
))))
ind_respi <- sort(unique(unlist(c(
  lapply(df_illness, function(x) which(x %in% 1111:1125)),
  lapply(df_ICD10,   function(x) which(substr(x, 1, 1) == "J"))
))))
AS <- rep(0, nrow(pheno_b_AFR))
AS[ind_respi] <- NA
AS[ind_asthma] <- 1

## morning person
MP_code <- which(colnames(pheno_b_AFR) %in% paste0("1180-0.", 0))
na_idx <- ifelse(pheno_b_AFR[, MP_code] == -3 | pheno_b_AFR[, MP_code] == -1 | is.na(pheno_b_AFR[, MP_code]), T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, MP_code])
MP <- ifelse(pheno_na == 1, 1, 0)

## MDD
ind_MDD <- unique(unlist(c(
  lapply(df_illness, function(x) which(x == 1286)),
  lapply(df_ICD10, function(x) which(substr(x, 1, 3) %in% c("F32", "F33")))
)))
ind_psy <- unique(unlist(c(
  lapply(df_illness, function(x) which(x %in% 1286:1291)),
  lapply(df_ICD10, function(x) which(substr(x, 1, 1) == "F"))
)))
ind_batch <- which(pheno_b_AFR[, colnames(pheno_b_AFR) %in% "22000-0.0"] < 0)
MDD <- rep(0, nrow(pheno_b_AFR))
MDD[unique(c(ind_batch, ind_psy))] <- NA
MDD[ind_MDD] <- 1

## smoking status
SS_code <- which(colnames(pheno_b_AFR) %in% paste0("20116-0.", 0))
na_idx <- ifelse(pheno_b_AFR[, SS_code] == -3, T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, SS_code])
SS <- ifelse(pheno_na == 0, 1, 0)

## qualfication
QU_code <- which(colnames(pheno_b_AFR) %in% paste0("6138-0.", 0))
na_idx <- ifelse(pheno_b_AFR[, QU_code] == -3 | is.na(pheno_b_AFR[, QU_code]), T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, QU_code])
QU <- ifelse(pheno_na == 1, 1, 0)

## HT
ind_HT <- unique(unlist(c(
  lapply(df_heart,   function(x) which(x == 1)),
  lapply(df_illness, function(x) which(x == 1065)),
  lapply(df_ICD10,   function(x) which(substr(x, 1, 3) %in% paste0("I", 10:16)))
)))
HT <- rep(0, nrow(pheno_b_AFR)) 
HT[ind_heart] <- NA
HT[ind_HT] <- 1

## OS
ind_OS <- unique(unlist(c(
  lapply(df_illness, function(x) which(x == 1465)),
  lapply(df_ICD10,   function(x) which(substr(x, 1, 5) %in% paste0("M", 1990:1993)))
)))
ind_psy <- unique(unlist(c(
  lapply(df_illness, function(x) which(x %in% 1286:1291)),
  lapply(df_ICD10, function(x) which(substr(x, 1, 1) == "M"))
)))
OS <- rep(0, nrow(pheno_b_AFR)) 
OS[ind_OS] <- 1

## fresh fruit intake
FFI_code <- which(colnames(pheno_b_AFR) %in% paste0("1309-0.", 0))
na_idx <- ifelse(pheno_b_AFR[, FFI_code] == -3 | pheno_b_AFR[, FFI_code] == -1, T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, FFI_code])
FFI <- ifelse(pheno_na == -10 | pheno_na == 0, 0, 1)

## dried fruit intake
DFI_code <- which(colnames(pheno_b_AFR) %in% paste0("1319-0.", 0))
na_idx <- ifelse(pheno_b_AFR[, DFI_code] == -3 | pheno_b_AFR[, DFI_code] == -1, T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, DFI_code])
DFI <- ifelse(pheno_na == -10 | pheno_na == 0, 0, 1)

## angina
ind_AN <- unique(unlist(c(
  lapply(df_heart,   function(x) which(x == 1)),
  lapply(df_illness, function(x) which(x == 1074)),
  lapply(df_ICD10,   function(x) which(substr(x, 1, 3) %in% paste0("I", 20)))
)))
AN <- rep(0, nrow(pheno_b_AFR)) 
AN[ind_heart] <- NA
AN[ind_AN] <- 1

## gout
ind_GO <- unique(unlist(c(
  lapply(df_illness, function(x) which(x == 1466)),
  lapply(df_ICD10,   function(x) which(substr(x, 1, 3) %in% paste0("M", 10)))
)))
GO <- rep(0, nrow(pheno_b_AFR))
GO[ind_muscu] <- NA
GO[ind_GO] <- 1

## salt added to food
SAF_code <- which(colnames(pheno_b_AFR) %in% paste0("1478-0.", 0))
na_idx <- ifelse(pheno_b_AFR[, SAF_code] == -3, T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, SAF_code])
SAF <- ifelse(pheno_na == 1, 1, 0)

## headache
HA_code <- which(colnames(pheno_b_AFR) %in% paste0("6159-0.", 0))
na_idx <- ifelse(pheno_b_AFR[, HA_code] == -3 | is.na(pheno_b_AFR[, HA_code]), T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, HA_code])
HA <- ifelse(pheno_na == 1, 1, 0)

## tense
TE_code <- which(colnames(pheno_b_AFR) %in% paste0("1990-0.", 0))
na_idx <- ifelse(pheno_b_AFR[, TE_code] == -3 | pheno_b_AFR[, TE_code] == -1 | is.na(pheno_b_AFR[, TE_code]), T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, TE_code])
TE <- ifelse(pheno_na == 1, 1, 0)

## balding type I
T1B_code <- which(colnames(pheno_b_AFR) %in% paste0("2395-0.", 0))
na_idx <- ifelse(pheno_b_AFR[, T1B_code] == -3 | pheno_b_AFR[, T1B_code] == -1 | is.na(pheno_b_AFR[, T1B_code]), T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, T1B_code])
T1B <- ifelse(pheno_na == 1, 1, 0)

## vitamin and mineral supplements
VMS_code <- which(colnames(pheno_b_AFR) %in% paste0("6155-0.", 0))
na_idx <- ifelse(pheno_b_AFR[, VMS_code] == -3 | is.na(pheno_b_AFR[, VMS_code]), T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, VMS_code])
VMS <- ifelse(pheno_na == -7, 0, 1)

## myxoedema
ind_MY <- unique(unlist(c(
  lapply(df_illness, function(x) which(x == 1226)),
  lapply(df_ICD10,   function(x) which(substr(x, 1, 3) %in% "E03"))
)))
ind_meta <- unique(unlist(c(
  lapply(df_ICD10,   function(x) which(substr(x, 1, 1) == "E"))
)))
MY <- rep(0, nrow(pheno_b_AFR))
MY[ind_meta] <- NA
MY[ind_MY] <- 1

## snoring
SN_code <- which(colnames(pheno_b_AFR) %in% paste0("1210-0.", 0))
na_idx <- ifelse(pheno_b_AFR[, SN_code] == -3 | pheno_b_AFR[, SN_code] == -1, T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, SN_code])
SN <- ifelse(pheno_na == 1, 1, 0)

## ever smoked
ES_code <- which(colnames(pheno_b_AFR) %in% paste0("20160-0.", 0))
na_idx <- ifelse(is.na(pheno_b_AFR[, ES_code]), T, F)
pheno_na <- ifelse(na_idx, NA, pheno_b_AFR[, ES_code])
ES <- ifelse(pheno_na == 1, 1, 0)

# pheno_b_AFR_all <- cbind(PRCA, TA, TD2, CAD, RA, 
#                      BRCA, AS, MP, MDD, SS, 
#                      QU, HT, FFI, DFI, HC, 
#                      AN, GO, SAF, HA, TE, 
#                      T1B, VMS, MY, SN, ES)
pheno_b_AFR_all <- cbind(PRCA, TA, TD2, CAD, RA, 
                         BRCA, AS, MP, MDD, SS, 
                         QU, HT, FFI, DFI, OS, 
                         AN, GO, SAF, HA, TE, 
                         T1B, VMS, MY, SN, ES)
save(pheno_b_AFR_all, file = paste0(comp_str, "02_pheno/08_pheno_AFR/05_pheno_b_clean.RData"))


load(paste0(comp_str, "02_pheno/08_pheno_AFR/05_pheno_b_clean.RData"))
covVar_AFR <- as.matrix(cbind(sqc_i_AFR[, c(26:35)], 
                              ifelse(sqc_i_AFR$Inferred.Gender == "F", 0, 1)))
for (p in 1:25) {
  # p=1
  covVar_AFR_dat <- data.frame(y = pheno_b_AFR_all[, p], 
                               covVar_AFR)
  coefMat_val <- lm(y~., data = covVar_AFR_dat) %>% coef()
  coefMat_val[is.na(coefMat_val)] <- 0
  pred_val <- cbind(1, covVar_AFR) %*% coefMat_val
  write.table(pred_val, row.names = F, col.names = F, quote = F, 
              file = paste0(comp_str, "02_pheno/08_pheno_AFR/coveff_pheno", p, ".txt"))
}