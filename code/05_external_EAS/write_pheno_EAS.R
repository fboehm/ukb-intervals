library(bigreadr)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
pred_str <- "/net/mulan/disk2/yasheng/predictionProject/"
fam <- fread2(paste0(pred_str,"plink_file/EAS/hm3/chr1.fam"))

dat <- "binary"
##
if(dat == "continuous"){
  load(paste0(comp_str, "02_pheno/07_pheno_EAS/04_pheno_c_adj.RData"))
  pheno_EAS <- pheno_c_adj_EAS
}

if(dat == "binary"){
  #
  load(paste0(comp_str, "02_pheno/07_pheno_EAS/05_pheno_b_clean.RData"))
  load(paste0(comp_str, "02_pheno/07_pheno_EAS/01_sqc.RData"))
  #
  pheno_EAS <- pheno_b_EAS_all
  sqc_i_EAS <- sqc_i_EAS[match(fam[,1],sqc_i_EAS$idx),]
  coveff_EAS <- as.matrix(cbind(sqc_i_EAS[, c(26:35)], 
                                ifelse(sqc_i_EAS$Inferred.Gender == "F", 0, 1)))
  #
  write.table(cbind(1,coveff_EAS), 
              file = paste0(comp_str, "02_pheno/07_pheno_EAS/binary/cov_EAS.txt"),
              quote = F, row.names = F, col.names = F)
  write.table(cbind(1,coveff_EAS[,-11]), 
              file = paste0(comp_str, "02_pheno/07_pheno_EAS/binary/cov_EAS_nosex.txt"),
              quote = F, row.names = F, col.names = F)
}

##
for (p in 1:25) {
  pheno_dat_grm <- cbind(fam[,1:2],pheno_EAS[,p])
  write.table(pheno_dat_grm,
              file = paste0(comp_str,"02_pheno/07_pheno_EAS/",dat,"/pheno",p,".txt"),
              sep = "\t", col.names = F,row.names = F,quote = F)
}

# for (chr in 1:22) {
  pheno_dat_lmm <- cbind(fam[,1:5],pheno_EAS)
  write.table(pheno_dat_lmm, file = paste0(pred_str, "plink_file/EAS/hm3/merge.fam"),
              col.names = F, row.names = F, quote = F)
# }


