library(bigreadr)
library(stringr)
setwd("/net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/")

###data2
# pheno2: PLT 
PLT_dat2<-fread2("./01_raw/PLT_AA_GWAMA_20190214_GC.gz")
PLT_dat2$SNP_POS2<-str_split(PLT_dat2[,1],"_",simplify = T)[,1]
PLT_snp_dat2<-PLT_dat2$SNP_POS2
cat("SNP number of PLT_dat2: ", nrow(PLT_dat2), "\n")

# pheno 6:RBC
RBC_dat2<-fread2("./01_raw/RBC_AA_GWAMA_20190214_GC.gz")
RBC_dat2$SNP_POS2<-str_split(RBC_dat2[,1],"_",simplify = T)[,1]
RBC_snp_dat2<-RBC_dat2$SNP_POS2
cat("SNP number of RBC_dat2: ", nrow(RBC_dat2), "\n")

# pheno 8: RDW
RDW_dat2 <- fread2("./01_raw/RDW_AA_GWAMA_20190214_GC.gz")
RDW_dat2$SNP_POS2<-str_split(RDW_dat2[,1],"_",simplify = T)[,1]
RDW_snp_dat2<-RDW_dat2$SNP_POS2
cat("SNP number of RDW_dat2: ", nrow(RDW_dat2), "\n")

# pheno 9: EOS
EOS_dat2 <- fread2("./01_raw/EOS_AA_GWAMA_20190214_GC.gz")
EOS_dat2$SNP_POS2<-str_split(EOS_dat2[,1],"_",simplify = T)[,1]
EOS_snp_dat2<-EOS_dat2$SNP_POS2
cat("SNP number of EOS_dat2: ", nrow(EOS_dat2), "\n")

# pheno 10: WBC 
WBC_dat2 <- fread2("./01_raw/WBC_AA_GWAMA_20190214_GC.gz")
WBC_dat2$SNP_POS2<-str_split(WBC_dat2[,1],"_",simplify = T)[,1]
WBC_snp_dat2<-WBC_dat2$SNP_POS2
cat("SNP number of WBC_dat2: ", nrow(WBC_dat2), "\n")


###hm3_ref
hm3_frq <- fread2("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/hm3/geno/merge.frq")
hm3_bim <- fread2("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/hm3/geno/merge.bim")
hm3_snp <- data.frame(SNP = hm3_bim$V2, 
                      SNP_POS = paste0(hm3_bim$V1, ":", hm3_bim$V4), 
                      A1 = hm3_bim$V5, 
                      A2 = hm3_bim$V6, 
                      MAF = hm3_frq$MAF)

rownames(hm3_snp)<-hm3_snp[,2]
inter_snp <- Reduce(intersect, list(PLT_snp_dat2,RBC_snp_dat2, 
                                    RDW_snp_dat2, EOS_snp_dat2, WBC_snp_dat2, 
                                    hm3_snp[, 2]))
hm3_snp_inter <- hm3_snp[hm3_snp$SNP_POS %in% inter_snp, ]
save(hm3_snp_inter, file = "./02_clean/hm3_snp_inter.RData")                   

### intersection of the data sets
load("./02_clean/hm3_snp_inter.RData")
## pheno2_2 
PLT_inter_dat2 <- PLT_dat2[PLT_dat2$SNP_POS2 %in% hm3_snp_inter$SNP_POS, ]
PLT_inter_dat2<-merge(PLT_inter_dat2,hm3_snp_inter,by.x="SNP_POS2",by.y="SNP_POS")
PLT_herit_dat2 <- data.frame(SNP = PLT_inter_dat2$SNP, 
                             N = PLT_inter_dat2$n_samples, 
                             Z = PLT_inter_dat2$z, 
                             A1 = PLT_inter_dat2$reference_allele,
                             A2 = PLT_inter_dat2$other_allele)
PLT_val_dat2 <- data.frame(SNP = PLT_inter_dat2$SNP, 
                           A1 = PLT_inter_dat2$reference_allele,
                           beta = PLT_inter_dat2$beta*sqrt(2*PLT_inter_dat2$eaf*(1-PLT_inter_dat2$eaf)))
write.table(PLT_herit_dat2, file = "./02_clean/pheno2_data2_herit.ldsc", 
            row.names = F, quote = F)
write.table(PLT_val_dat2, file = "./02_clean/pheno2_data2_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/02_clean/pheno2_data2_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/02_clean/pheno2_data2_val.txt")



## pheno6_2 
RBC_inter_dat2 <- RBC_dat2[RBC_dat2$SNP_POS2 %in% hm3_snp_inter$SNP_POS, ]
RBC_inter_dat2<-merge(RBC_inter_dat2,hm3_snp_inter,by.x="SNP_POS2",by.y="SNP_POS")
RBC_herit_dat2 <- data.frame(SNP = RBC_inter_dat2$SNP, 
                             N = RBC_inter_dat2$n_samples, 
                             Z = RBC_inter_dat2$z, 
                             A1 = RBC_inter_dat2$reference_allele,
                             A2 = RBC_inter_dat2$other_allele)
RBC_val_dat2 <- data.frame(SNP = RBC_inter_dat2$SNP, 
                           A1 = RBC_inter_dat2$reference_allele,
                           beta = RBC_inter_dat2$beta*sqrt(2*RBC_inter_dat2$eaf*(1-RBC_inter_dat2$eaf)))
write.table(RBC_herit_dat2, file = "./02_clean/pheno6_data2_herit.ldsc", 
            row.names = F, quote = F)
write.table(RBC_val_dat2, file = "./02_clean/pheno6_data2_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/02_clean/pheno6_data2_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/02_clean/pheno6_data2_val.txt")


## pheno8_2 
RDW_inter_dat2 <- RDW_dat2[RDW_dat2$SNP_POS2 %in% hm3_snp_inter$SNP_POS, ]
RDW_inter_dat2<-merge(RDW_inter_dat2,hm3_snp_inter,by.x="SNP_POS2",by.y="SNP_POS")
RDW_herit_dat2 <- data.frame(SNP = RDW_inter_dat2$SNP, 
                             N = RDW_inter_dat2$n_samples, 
                             Z = RDW_inter_dat2$z, 
                             A1 = RDW_inter_dat2$reference_allele,
                             A2 = RDW_inter_dat2$other_allele)
RDW_val_dat2 <- data.frame(SNP = RDW_inter_dat2$SNP, 
                           A1 = RDW_inter_dat2$reference_allele,
                           beta = RDW_inter_dat2$beta*sqrt(2*RDW_inter_dat2$eaf*(1-RDW_inter_dat2$eaf)))
write.table(RDW_herit_dat2, file = "./02_clean/pheno8_data2_herit.ldsc", 
            row.names = F, quote = F)
write.table(RDW_val_dat2, file = "./02_clean/pheno8_data2_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/02_clean/pheno8_data2_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/02_clean/pheno8_data2_val.txt")


## pheno9_2 
EOS_inter_dat2 <- EOS_dat2[EOS_dat2$SNP_POS2 %in% hm3_snp_inter$SNP_POS, ]
EOS_inter_dat2<-merge(EOS_inter_dat2,hm3_snp_inter,by.x="SNP_POS2",by.y="SNP_POS")
EOS_herit_dat2 <- data.frame(SNP = EOS_inter_dat2$SNP, 
                             N = EOS_inter_dat2$n_samples, 
                             Z = EOS_inter_dat2$z, 
                             A1 = EOS_inter_dat2$reference_allele,
                             A2 = EOS_inter_dat2$other_allele)
EOS_val_dat2 <- data.frame(SNP = EOS_inter_dat2$SNP, 
                           A1 = EOS_inter_dat2$reference_allele,
                           beta = EOS_inter_dat2$beta*sqrt(2*EOS_inter_dat2$eaf*(1-EOS_inter_dat2$eaf)))
write.table(EOS_herit_dat2, file = "./02_clean/pheno9_data2_herit.ldsc", 
            row.names = F, quote = F)
write.table(EOS_val_dat2, file = "./02_clean/pheno9_data2_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/02_clean/pheno9_data2_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/02_clean/pheno9_data2_val.txt")


## pheno10_2 
WBC_inter_dat2 <- WBC_dat2[WBC_dat2$SNP_POS2 %in% hm3_snp_inter$SNP_POS, ]
WBC_inter_dat2<-merge(WBC_inter_dat2,hm3_snp_inter,by.x="SNP_POS2",by.y="SNP_POS")
WBC_herit_dat2 <- data.frame(SNP = WBC_inter_dat2$SNP, 
                             N = WBC_inter_dat2$n_samples, 
                             Z = WBC_inter_dat2$z, 
                             A1 = WBC_inter_dat2$reference_allele,
                             A2 = WBC_inter_dat2$other_allele)
WBC_val_dat2 <- data.frame(SNP = WBC_inter_dat2$SNP, 
                           A1 = WBC_inter_dat2$reference_allele,
                           beta = WBC_inter_dat2$beta*sqrt(2*WBC_inter_dat2$eaf*(1-WBC_inter_dat2$eaf)))
write.table(WBC_herit_dat2, file = "./02_clean/pheno10_data2_herit.ldsc", 
            row.names = F, quote = F)
write.table(WBC_val_dat2, file = "./02_clean/pheno10_data2_val.txt", 
            row.names = F, quote = F)
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/02_clean/pheno10_data2_herit.ldsc")
system("gzip -f /net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/02_clean/pheno10_data2_val.txt")


###data1 from ukb
for (p in 1: 25){
  summ <- fread2(paste0("./01_raw/output/pheno", p, ".assoc.txt"))
  summ_herit <- data.frame(SNP = summ[,2],
                           N = summ[,4]+summ[,5],
                           Z = summ[,9]/summ[,10],
                           A1 = summ[,6],
                           A2 = summ[,7])
  summ_val <- data.frame(SNP = summ[, 2], 
                         A1 = summ[, 6], 
                         beta = summ[, 9] * sqrt(2*summ[, 8]*(1-summ[,8])))
  write.table(summ_herit, file = paste0("./02_clean/pheno", p, "_data1_herit.ldsc"), 
              row.names = F, quote = F)
  write.table(summ_val, file = paste0("./02_clean/pheno", p, "_data1_val.txt"), 
              row.names = F, quote = F)
  system(paste0("gzip /net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/02_clean/pheno", p, "_data1_herit.ldsc"))
  system(paste0("gzip /net/mulan/disk2/yasheng/comparisonProject/07_external_c/01_AA/02_clean/pheno", p, "_data1_val.txt"))
}

