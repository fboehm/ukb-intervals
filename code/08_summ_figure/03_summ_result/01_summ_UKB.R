# Summarize the UKB file
library(bigreadr)
library(dplyr)
library(plyr)

## Part one: the information of SNP number and sample size
plink_str <- "/net/mulan/disk2/yasheng/predictionProject/plink_file/"
### sample size
fam_file <- paste0(plink_str, "hm3/chr1.fam") %>% fread2
cat("Sample size: ", nrow(fam_file), "\n")
### hm3 SNP number
hm3_num <- aaply(c(1: 22), 1, function(chr){
  chr_num <-  paste0(plink_str, "hm3/chr", chr, ".bim") %>% fread2 %>% nrow
  return(chr_num)
}) %>% sum
cat("HM3 SNP number: ", hm3_num, "\n")
### dense SNP number
dense_num <- aaply(c(1: 22), 1, function(chr){
  chr_num <-  paste0(plink_str, "ukb/chr", chr, ".bim") %>% fread2 %>% nrow
  return(chr_num)
}) %>% sum
cat("Dense SNP number: ", dense_num, "\n")
### low MAF SNP number
low_num <- aaply(c(1: 22), 1, function(chr){
  chr_num <-  paste0(plink_str, "rare/chr", chr, ".bim") %>% fread2 %>% nrow
  return(chr_num)
}) %>% sum
cat("Low MAF SNP number: ", low_num, "\n")
cat("HM3 and low MAF SNP number: ", hm3_num + low_num, "\n")


## Part two: the information of validation data
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
### continuous traits
pheno_uni_c <- c("SH", "PLT", "BMD", "BMR", "BMI", 
                 "RBC", "AM", "RDW", "EOS", "WBC", 
                 "FVC", "FEV", "FFR", "WC", "HC",
                 "WHR", "SBP", "BW", "BFP", "TFP", 
                 "SU", "TC", "HDL", "LDL", "TG")
tot_c <- aaply(c(1: 25), 1, function(p){
  sample_p <- bigreadr::fread2(paste0(comp_str, "03_subsample/continuous/pheno", 
                                      p, "/val/hm3/02_pheno_c.txt")) %>% nrow
  return(sample_p)
})
cat("Max continuous trait: ", pheno_uni_c[which.max(tot_c)], max(tot_c), "\n")
cat("Min continuous trait: ", pheno_uni_c[which.min(tot_c)], min(tot_c), "\n")
### binary traits
pheno_uni_b <- c("PRCA", "TA", "T2D", "CAD", "RA", 
                 "BRCA", "AS", "MP", "MDD", "SS", 
                 "QU", "HT", "FFI", "DFI", "OA", 
                 "AN", "GO", "SAF", "HA", "TE", 
                 "T1B", "VMS", "MY", "SN", "ES")
tot_b <- aaply(c(1: 25), 1, function(p){
  pheno <- bigreadr::fread2(paste0(comp_str, "03_subsample/binary/pheno", 
                                   p, "/val/02_pheno_b.txt"))[, 1]
  sample_p <- vector("numeric", 3)
  sample_p[1] <- length(pheno)
  sample_p[2] <- sum(pheno)
  sample_p[3] <- sum(pheno) / length(pheno)
  return(sample_p)
})
cat("Max binary trait: ", pheno_uni_b[which.max(tot_b[, 1])], max(tot_b[, 1]), "\n")
cat("Min binary trait: ", pheno_uni_b[which.min(tot_b[, 1])], min(tot_b[, 1]), "\n")
cat("Max binary trait: ", pheno_uni_b[which.max(tot_b[, 2])], max(tot_b[, 2]), "\n")
cat("Min binary trait: ", pheno_uni_b[which.min(tot_b[, 2])], min(tot_b[, 2]), "\n")
cat("Max binary trait: ", pheno_uni_b[which.max(tot_b[, 3])], round(max(tot_b[, 3]), 2), "\n")
cat("Min binary trait: ", pheno_uni_b[which.min(tot_b[, 3])], round(min(tot_b[, 3]), 2), "\n")



## Part three: sample size of training data of continuous and binary traits
### countinuous
sample_c <- paste0(comp_str, "02_pheno/sample_size_c.txt") %>% fread2
cat("Max continuous trait: ", sample_c[which.max(sample_c[, 6]), 1], max(sample_c[, 6]), "\n")
cat("Min continuous trait: ", sample_c[which.min(sample_c[, 6]), 1], min(sample_c[, 6]), "\n")
### binary
sample_b <- paste0(comp_str, "02_pheno/sample_size_b.txt") %>% fread2
cat("Max binary trait: ", sample_b[which.max(sample_b[, 6]), 1], max(sample_b[, 6]), "\n")
cat("Min binary trait: ", sample_b[which.min(sample_b[, 6]), 1], min(sample_b[, 6]), "\n")

## Part four: information of AFR UKB data
