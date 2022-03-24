######
library(bigreadr)
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
pred_str <- "/net/mulan/disk2/yasheng/predictionProject/"
fam <- fread2(paste0(pred_str,"plink_file/AA/hm3/chr1.fam"))
AFR_idx2 <- fread2(paste0(comp_str,"02_pheno/08_pheno_AFR/idx_AFR2.txt"))
##
##

dat <- "binary"
##
if(dat == "continuous"){
  load(paste0(comp_str, "02_pheno/08_pheno_AFR/04_pheno_c_adj.RData"))
  pheno_AFR_sub <- pheno_c_adj_AFR[-which(AFR_idx2[,1] == 2e+05), ]
}

if(dat == "binary"){
  #
  load(paste0(comp_str, "02_pheno/08_pheno_AFR/05_pheno_b_clean.RData"))
  load(paste0(comp_str, "02_pheno/08_pheno_AFR/01_sqc.RData"))
  #
  pheno_AFR_sub <- pheno_b_AFR_all[-which(AFR_idx2[,1] == 2e+05), ]
  sqc_i_AFR <- sqc_i_AFR[match(fam[,1],sqc_i_AFR$idx),]
  coveff_AFR <- as.matrix(cbind(sqc_i_AFR[, c(26:35)], 
                                ifelse(sqc_i_AFR$Inferred.Gender == "F", 0, 1)))
  write.table(cbind(1,coveff_AFR), 
              file = paste0(comp_str, "02_pheno/08_pheno_AFR/binary/cov_AFR.txt"),
              quote = F, row.names = F, col.names = F)
  write.table(cbind(1,coveff_AFR[,-11]), 
              file = paste0(comp_str, "02_pheno/08_pheno_AFR/binary/cov_AFR_nosex.txt"),
              quote = F, row.names = F, col.names = F)
}


#
for (p in 1:25) {
  pheno_dat <- cbind(fam[,1:2],pheno_AFR_sub[,p])
  write.table(pheno_dat,
              file = paste0(comp_str,"02_pheno/08_pheno_AFR/",dat,"/pheno",p,".txt"),
              sep = "\t", col.names = F,row.names = F,quote = F)
}

# for (chr in 1:22) {
pheno_dat_lmm <- cbind(fam[,1:5],pheno_AFR_sub)
write.table(pheno_dat_lmm, file = paste0(pred_str, "plink_file/AA/hm3/merge.fam"),
            col.names = F, row.names = F, quote = F)
# }

