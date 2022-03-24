rm(list=ls())
library(Metrics)
library(bigreadr)
library(optparse)

## Parameter setting
args_list = list(
  make_option("--iter", type="numeric", default=NULL,
              help="INPUT: phenotype number", metavar="character")
)
opt_parser = OptionParser(option_list=args_list)
opt = parse_args(opt_parser)

iter <- opt$iter

##############################
### summarize the result of validate
##############################
## summ function
summPheno <- function(chr_path, type){
  require(bigreadr)
  require(Metrics)
  valid_pheno <- pheno_c_adj_EAS[, p]
  valid_pheno_na <- valid_pheno[!is.na(valid_pheno)]
  pred_tot <- vector()
  for(chr in 1: 22){
    pred_chr_str <- paste0(chr_path, chr, type, ".profile.gz")
    
    if (file.exists(pred_chr_str)){
      pred_chr <- fread2(pred_chr_str, header = T)[, 6]
      pred_tot <- cbind(pred_tot, pred_chr)
    } else {
      cat (paste0("chr:", chr, " fail!\n"))
    }
  }
  pheno_tot <- rowSums(pred_tot)
  pheno_tot <- pheno_tot[idx]
  r2 <- cor(valid_pheno_na, pheno_tot[!is.na(valid_pheno)])^2
  return(r2)
}

comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
ext_pheno <- read.table(paste0(comp_str, "code/05_external_EAS/pheno.txt"))[, 1]
ext_dat <- read.table(paste0(comp_str, "code/05_external_EAS/dat.txt"))[, 1]
p <- ext_pheno[iter]
d <- ext_dat[iter]
idx_new <- fread2(paste0(comp_str, "02_pheno/07_pheno_EAS/idx_EAS2.txt"), select = 1)[, 1]
idx_old <- fread2(paste0("/net/mulan/disk2/yasheng/predictionProject/plink_file/EAS/hm3/chr1.fam"),
                  select = 1)[, 1]
idx <- which(idx_old%in%idx_new)


method <- c("CT", "DBSLMM", "lassosum",
            "LDpred2", "LDpred2", "LDpred2", "LDpred2",
            "nps", "PRScs", "SbayesR", "sblup", "SCT", "bagging")
situ <- c("_hm3", "_hm3_best", "_hm3", 
          "_auto_hm3", "_inf_hm3", "_nosp_hm3", "_sp_hm3", 
          "", "", "", "_hm3", "_hm3", "_hm3")
situ2 <- c("", "", "",
           "", "", "", "", 
           "", "_best", "", "", "", "")
load(paste0(comp_str, "02_pheno/07_pheno_EAS/04_pheno_c_adj.RData"))

r2_mat <- matrix(NA, ncol = length(method), nrow = 5)
pheno_path <- paste0(comp_str, "07_external_c/03_EAS/03_res/continuous/")

for (m in 1: length(method)){
  cat (method[m], "\n")
  for(cross in 1:5){
    chr_path <- paste0(pheno_path, "pheno", p, "_data", d, "/", method[m], 
                         "/pred", situ[m], "_cross", cross, "_chr") 
    temp_res <- try(summPheno(chr_path, situ2[m]), silent = T)
    
    if (inherits(temp_res, "try-error") == F){
      r2_mat[cross, m] <- temp_res
    }
  }
}

save(r2_mat, file = paste0(comp_str, "07_external_c/03_EAS/04_summ_res/res_hm3_c_pheno",
                           ext_pheno[iter], "_dat", ext_dat[iter], ".RData"))
