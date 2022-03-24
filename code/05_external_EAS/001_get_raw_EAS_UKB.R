#! /usr/bin/env Rscript
rm(list=ls())
library(bigreadr)
library(plyr)

# Combine the sqc and fam
## Load files
sqc <- fread2("/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_sqc_v2.txt")
header <- read.table("/net/mulan/Biobank/rawdata/EGAD00010001225/001/ukb_sqc_v2_head.txt", 
                     stringsAsFactors = F)
fam <- fread2("/net/mulan/data/UKB/ukb30186_baf_chr9_v2_s488363.fam")
remove_id <- read.table("/net/mulan/disk2/yasheng/comparisonProject/w30186_20200820.csv")[, 1]
colnames(sqc) <- header[, 1]

## Check files
if (dim(fam)[1] != dim(sqc)[1]){
  stop("ERROR: The number of rows is not the same!")
}else{
  # sqc <- data.frame(sqc, eid=fam$V1)
  sqc$eid <- fam$V1
  cat("QC sample:", dim(sqc)[1], "\n")
}

## Select the samples
# select using genetype
## in.Phasing.Input.chr1_22==1
sqc_i <- sqc[sqc$in.Phasing.Input.chr1_22 == 1, ] ## 487409 samples
sqc_i$idx <- c(1: 487409)
eid_i <- sqc_i$eid
# select using phenotype
## in.white.British.ancestry.subset==1
## used.in.pca.calculation==1
## excess.relatives==0
## putative.sex.chromosome.aneuploidy==0
## eid > 0
cnd_i <- sqc_i$in.white.British.ancestry.subset != 1
cnd_ii <- sqc_i$excess.relatives == 0 
cnd_iii <- sqc_i$putative.sex.chromosome.aneuploidy == 0 
cnd_ix <- sqc_i$used.in.pca.calculation == 1
cnd_x <- sqc_i$eid > 0
cnd_xi <- !sqc_i$eid %in% remove_id
cnd <- cnd_i & cnd_ii & cnd_iii & cnd_ix & cnd_x & cnd_xi
cat("Samples Remaining:", sum(cnd), "\n")

# ancestry information
ancestry_info <- fread2("/net/mulan/data/UKB/ukb10683.csv", 
                        select = c("eid", "21000-0.0"))
# ancestry_info_EAS <- ancestry_info[ancestry_info[, 2] %in% c(5, 2003, 3003, 3004), ]
ancestry_info_EAS <- ancestry_info[ancestry_info[, 2] %in% c(5, 2003, 3004), ]
ancestry_info_EAS <- ancestry_info_EAS[match(eid_i, ancestry_info_EAS$eid), ]
ancestry_info_EAS <- ancestry_info_EAS[cnd, ]
ancestry_info_EAS <- ancestry_info_EAS[!is.na(ancestry_info_EAS[, 1]), ]
cat("Sample size of Asian ancestry: ", nrow(ancestry_info_EAS), ".\n")

# continuous phenotype data
compstr <- "/net/mulan/disk2/yasheng/comparisonProject/"
## load data 1
pheno_c_code1 <- c("eid", 
                   paste0(50, "-0.0"),      # SH
                   paste0(30080, "-0.0"),   # PLT
                   paste0(3148, "-0.0"),    # BMD
                   paste0(23105, "-0.0"),   # BMR
                   paste0(21001, "-0.0"),   # BMI
                   paste0(30010, "-0.0"),   # RBC
                   paste0(2714, "-0.0"),    # AM
                   paste0(30070, "-0.0"),   # RDW
                   paste0(30150, "-0.0"),   # EOS
                   paste0(30000, "-0.0"),   # WBC
                   paste0(3062, "-0.0"),    # FVC
                   paste0(3063, "-0.0"),    # FEV
                   paste0(48, "-0.0"),      # WC
                   paste0(49, "-0.0"),      # HC
                   paste0(4080, "-0.0"),    # SBP
                   paste0(20022, "-0.0"),   # birth weight (BW)
                   paste0(23099, "-0.0"),   # body fat percentage (BFP)
                   paste0(23127, "-0.0"),   # trunk fat percentage (TFP)
                   paste0(30530, "-0.0")    # sodium in urine (SU)
)   
pheno_c1 <- fread2("/net/mulan/data/UKB/ukb10683.csv", select = pheno_c_code1)
## load data 2
pheno_c_code2 <- paste0("f.", c("eid", 
                                paste0(30690, ".0.0"),    # Cholesterol(CH)
                                paste0(30760, ".0.0"),    # HDL cholesterol (HDL)
                                paste0(30780, ".0.0"),    # LDL direct (LDL)
                                paste0(30870, ".0.0")     # Triglycerides (TC)
))   
pheno_c2 <- fread2("/net/mulan/Biobank/rawdata/ukb42224.tab", select = pheno_c_code2)

## merge data1 and data2
pheno_c <- merge(pheno_c1, pheno_c2, by.x = "eid", by.y = "f.eid")
## match data
pheno_c_EAS <- pheno_c[match(ancestry_info_EAS$eid, pheno_c$eid), ]
sqc_i_EAS <- sqc_i[match(ancestry_info_EAS$eid, sqc_i$eid), ]
save(sqc_i_EAS, file = paste0(compstr, "02_pheno/07_pheno_EAS/01_sqc.RData"))
save(pheno_c_EAS, file = paste0(compstr, "02_pheno/07_pheno_EAS/02_pheno_c_raw.RData"))


# binary phenotype data
## load data
pheno_b_cancer_code1 <- paste0("2453-", 0:2, ".0")
pheno_b_cancer_code2 <- c(paste0("20001-0.", 0:5),
                          paste0("20001-1.", 0:5),
                          paste0("20001-2.", 0:5))
pheno_b_illness_code <- c(paste0("20002-0.", 0:28),
                          paste0("20002-1.", 0:28),
                          paste0("20002-2.", 0:28))
pheno_b_ICD10_code <- c(paste0("40001-", 0:2, ".0"),
                        paste0("40002-0.", 0:13),
                        paste0("40002-1.", 0:13),
                        paste0("40002-2.", 0:13),
                        paste0("40006-", 0:31, ".0"),
                        paste0("41202-0.", 0:379),
                        paste0("41204-0.", 0:434))
pheno_b_heart_code <- c(paste0("6150-0.", 0:3),
                        paste0("6150-1.", 0:3),
                        paste0("6150-2.", 0:3))
pheno_b_code <- c(paste0("1727-0.", 0),     # tanning ability (TA)
                  paste0("1180-0.", 0),     # morning person (MP)
                  paste0("20116-0.", 0),    # Smoking status: Never (SS)
                  paste0("6138-0.", 0),     # qualifications: College or University degree (QU)
                  paste0("1309-0.", 0),     # fresh fruit intake (FFI)
                  paste0("1319-0.", 0),     # dried fruit intake (DFI)
                  paste0("1478-0.", 0),     # salt added to food (SAF)
                  paste0("6159-0.", 0),     # Pain type(s) experienced in last month: None of the above (PT)
                  paste0("1990-0.", 0),     # tense (TE)
                  paste0("2395-0.", 0),     # type I bald (T1B)
                  paste0("6155-0.", 0),     # Vitamin and mineral supplements: None of the above (VMS)
                  paste0("1210-0.", 0),     # snoring (SN)
                  paste0("20160-0.", 0)     # Ever smoked (ES)
)
pheno_b <- fread2("/net/mulan/data/UKB/ukb10683.csv", select = c("eid", 
                                                                 "22000-0.0",
                                                                 pheno_b_cancer_code1, 
                                                                 pheno_b_cancer_code2, 
                                                                 pheno_b_illness_code, 
                                                                 pheno_b_ICD10_code,
                                                                 pheno_b_heart_code, 
                                                                 pheno_b_code))
## match data
pheno_b_EAS <- pheno_b[match(ancestry_info_EAS$eid, pheno_c$eid), ]
save(pheno_b_EAS, file = paste0(compstr, "02_pheno/07_pheno_EAS/03_pheno_b_raw.RData"))

# idx
idx1 <- cbind(sqc_i_EAS$idx, sqc_i_EAS$idx)
idx2 <- rbind(c(1, 1), idx1)
write.table(idx2, 
            file = paste0(compstr, "02_pheno/07_pheno_EAS/idx_EAS1.txt"), 
            row.names = F, col.names = F, quote = F)
write.table(idx1, 
            file = paste0(compstr, "02_pheno/07_pheno_EAS/idx_EAS2.txt"), 
            row.names = F, col.names = F, quote = F)
