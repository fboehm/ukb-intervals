rm(list = ls())
# combine result of hm3 and rare
summRes_b_path <- "/net/mulan/disk2/yasheng/comparisonProject/06_internal_b/summRes/"
setwd(summRes_b_path)

auc_hm3 <- list()
auc_hm3_rare <- list()
for (p in 1:25) {
  load(paste0("res_hm3_b_pheno",p,".RData"))
  auc_hm3[[p]] <- colMeans(res_list[[2]])[c(1, 3, 4:8, 14)]
  load(paste0("res_hm3_rare_b_pheno",p,".RData"))
  auc_hm3_rare[[p]] <- colMeans(res_list[[2]]) # exclude
}

auc_hm3_mat <- Reduce(rbind, auc_hm3)
auc_hm3_rare_mat <- Reduce(rbind, auc_hm3_rare)
colnames(auc_hm3_mat) <- c("CT", "DBSLMM", "lassosum", 
                           "LDpred2_auto",  "LDpres2_inf", "LDpred2_nosp", "LDpred2_sp",
                           "SCT")
rownames(auc_hm3_mat) <- paste0("pheno",1:25)
dimnames(auc_hm3_rare_mat) <- dimnames(auc_hm3_mat)

# improvement of hm3_rare
improve_hm3_rare <- (auc_hm3_rare_mat-auc_hm3_mat)/(auc_hm3_mat)
round(summary(as.vector(improve_hm3_rare)),2)# output 

save(auc_hm3_mat, file = "auc_hm3_mat.Rdata")
save(auc_hm3_rare_mat, file = "auc_hm3_rare_mat.Rdata")
write.table(improve_hm3_rare, file = "improve_hm3_rare.txt",
            sep = "\t", col.names = T, row.names = T, quote = F)
