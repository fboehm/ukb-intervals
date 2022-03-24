library(bigreadr)
com_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
setwd(com_str)
load(paste0("./07_external_c/03_EAS/02_clean/hm3_snp_inter.RData"))

# inter_snp
pheno_list <- c(1:25)
for (p in pheno_list) {
  cat(p, "\n")
  eur_path <- paste0("./05_internal_c/pheno", p, "/output/")
  eas_path <- paste0("./07_external_c/03_EAS/03_res/continuous/pheno", p, "_data1/output/")
  for (cross in 1:5) {
    res <- parallel::mclapply(c(1: 22), function(chr){
      eur_dat <- fread2(paste0(eur_path, "summary_hm3_cross",cross,
                                "_chr",chr,".assoc.txt"))
      eas_dat <- subset(eur_dat, eur_dat[, 2] %in% inter_snp)
      fwrite2(eas_dat, sep = "\t", col.names=F,
              file = paste0(eas_path, "summary_hm3_cross",cross,
                            "_chr",chr,".assoc.txt"))
    }, mc.cores = 22)
  }
}


library(bigreadr)
com_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
setwd(com_str)
inter_snp <- fread2("/net/mulan/disk2/yasheng/predictionProject/plink_file/EAS/hm3/merge.bim")[, 2]
# inter_snp
pheno_list <- c(2:25)
for (p in pheno_list) {
  cat(p, "\n")
  eur_path <- paste0("./06_internal_b/pheno", p, "/output/")
  eas_path <- paste0("./07_external_c/03_EAS/03_res/binary/pheno", p, "_data1/output/")
  for (cross in 1:5) {
    res <- parallel::mclapply(c(1: 22), function(chr){
      eur_dat <- fread2(paste0(eur_path, "summary_hm3_cross",cross,
                               "_chr",chr,".assoc.txt"))
      eas_dat <- subset(eur_dat, eur_dat[, 2] %in% inter_snp)
      fwrite2(eas_dat, sep = "\t", col.names=F,
              file = paste0(eas_path, "summary_hm3_cross",cross,
                            "_chr",chr,".assoc.txt"))
    }, mc.cores = 22)
  }
}
