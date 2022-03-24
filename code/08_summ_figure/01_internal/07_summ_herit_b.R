rm(list=ls())

# hm3
## herit for continuous traits
internal_str <- "/net/mulan/disk2/yasheng/comparisonProject/06_internal_b"
setwd(internal_str)
herit_hm3 <- matrix(NA, 25, 5)
for (p in 1:25){
  for (cross in 1:5){
    herit_str <- paste0("./pheno", p, 
                        "/herit/h2_hm3_cross", cross, ".log")
    herit_file <- as.vector(read.delim(herit_str))
    herit_hm3[p, cross] <- as.numeric(strsplit(strsplit(as.character(herit_file[24, ]),": ")[[1]][2], " \\(")[[1]][1])
  }
}
herit_hm3_mean <- rowMeans(herit_hm3)
pheno_uni <- c("PRCA", "TA", "T2D", "CAD", "RA", 
               "BRCA", "AS", "MP", "MDD", "SS", 
               "QU", "HT", "FFI", "DFI", "OA", 
               "AN", "GO", "SAF", "HA", "TE", 
               "T1B", "VMS", "MY", "SN", "ES")
pheno_class <- c("Disease", "Other", "Disease", "Disease", "Disease", 
                 "Disease", "Disease", "Other", "Disease", "Other", 
                 "Other", "Disease", "Other", "Other", "Disease", 
                 "Disease", "Disease", "Other", "Disease", "Other",
                 "Other", "Other", "Disease", "Disease", "Other")
pheno_f <- factor(pheno_uni, levels = pheno_uni[order(herit_hm3_mean, decreasing = T)])
herit_hm3_dat <- data.frame(pheno = pheno_f, 
                            herit_hm3_mean, 
                            ref = "HM3", 
                            class = pheno_class)
load("./summRes/auc_hm3_dat.RData")
auc_dat <- reshape2::dcast(auc_dat, pheno~Methods, function(a) mean(a, na.rm = T))
auc_dat <- reshape2::melt(auc_dat, id = "pheno")
auc_herit_dat <- dplyr::left_join(auc_dat, herit_hm3_dat, by = "pheno")
colnames(auc_herit_dat) <- c("Traits", "Methods", "auc", 
                             "herit", "Ref", "Class")

load("./summRes/pr2_hm3_dat.RData")
pr2_dat <- reshape2::dcast(pr2_dat, pheno~Methods, function(a) mean(a, na.rm = T))
pr2_dat <- reshape2::melt(pr2_dat, id = "pheno")
pr2_herit_dat <- dplyr::left_join(pr2_dat, herit_hm3_dat, by = "pheno")
colnames(pr2_herit_dat) <- c("Traits", "Methods", "pr2", 
                             "herit", "Ref", "Class")

## output
save(auc_herit_dat, file = "./summRes/auc_herit_hm3_dat.RData")
save(pr2_herit_dat, file = "./summRes/pr2_herit_hm3_dat.RData")
