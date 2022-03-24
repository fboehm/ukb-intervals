library(bigreadr)
data_path <- "/net/mulan/Biobank/rawdata/EGAD00010001225/001/"
pred_path <- "/net/mulan/disk2/yasheng/predictionProject/"

chr=22
res <- parallel::mclapply(c(1: 22), function(chr){
  chr_mfi <- fread2(paste0(data_path, "ukb_mfi_chr", chr, "_v2.txt"))
  cnd1 <- chr_mfi[, 6] > 0.95
  cnd2 <- chr_mfi[, 5] > 0.005
  cnd3 <- chr_mfi[, 5] < 0.01
  rare_snp_chr <- chr_mfi[cnd1&cnd2&cnd3, 1]
  # comm_snp_chr <- fread2(paste0(pred_path, "plink_file/hm3/chr", chr, ".bim"), select = 2)
  # if(all(comm_snp_chr[, 1]%in%chr_mfi[, 1])){
    # cat("chr: ", chr, ":", length(rare_snp_chr), length(comm_snp_chr[, 1]), "\n")
    write.table(c(rare_snp_chr),
                  # , comm_snp_chr[, 1]), 
                file = paste0(pred_path, "plink_file/rare_snp_list/chr", 
                              chr, ".txt"), 
                col.names = F, row.names = F, quote = F)
  # }

}, mc.cores = 22)
