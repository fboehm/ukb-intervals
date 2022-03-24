# #! /usr/bin/env Rscript
rm(list=ls())
library(bigreadr)
library(plyr)
library(optparse)

## Parameter setting
args_list <- list(
  make_option("--chr", type = "character", default = NULL,
              help = "INPUT: chromosome", metavar = "character"))

opt_parser <- OptionParser(option_list=args_list)
opt <- parse_args(opt_parser)
chr <- opt$chr

## set parameters
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
hm3_str <- paste0(comp_str, "03_subsample/hm3/")
blk_str <- paste0(hm3_str, "blk/")
blk_info <- fread2(paste0(comp_str, "LDblock/chr", chr, ".bed"), select = c(2, 3))
chr_str <- paste0(hm3_str, "geno/chr", chr)
chr_bim <- fread2(paste0(chr_str, ".bim"), select = c(2, 4, 5, 6))
blk_snp_dat <- aaply(c(1: nrow(blk_info)), 1, function(a) 
  ifelse(chr_bim[, 2]>blk_info[a, 1] & chr_bim[, 2]<=blk_info[a, 2], a, 0))
chr_snp <- vector()
LD_list <- list()
for (b in 1: nrow(blk_info)){
  LD_mat <- list()
  ## get LD matrix
  blk_b_str <- paste0(blk_str, "chr", chr, "_blk", b)
  snp_blk <- chr_bim[blk_snp_dat[b, ] == b, 1]
  write.table(snp_blk, file = paste0(blk_b_str, ".snp"),
              row.names = F, col.names = F, quote = F)
  LD_cmd <- paste0("plink-1.9 --silent --bfile ", chr_str, "_imp --r square ",
                   " --extract ", blk_b_str, ".snp --out ", blk_b_str)
  system(LD_cmd)
  chr_snp <- c(chr_snp, snp_blk)
  cat ("blk", b, "snp number: ", length(snp_blk), "\n")
  
  LD_mat[[1]] <- as.matrix(fread2(paste0(blk_b_str, ".ld")))
  LD_mat[[2]] <- as.matrix(fread2(paste0(blk_b_str, ".snp"), header = F))
  LD_list[[b]] <- LD_mat
  
  ## remove files
  system(paste0("rm ", blk_b_str, ".log"))
  system(paste0("rm ", blk_b_str, ".snp"))
  system(paste0("rm ", blk_b_str, ".ld"))
}
save(LD_list, file = paste0(comp_str, "09_external_LD/UKB_hm3/LDmat/chr", chr, ".RData"))
# chr=22
# comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
# sel_snp_str <- paste0(comp_str, "09_external_LD/UKB_hm3/snp_inter.txt")
# hm3_str <- paste0(comp_str, "03_subsample/hm3/geno/chr")
# LD_str <- paste0(comp_str, "09_external_LD/UKB_hm3/geno/chr")
# emeraLD_str <- paste0(comp_str, "emeraLD/bin/emeraLD")
# chr_block_str <- paste0(comp_str, "LDblock/chr")
# blk_str <- paste0(comp_str, "09_external_LD/UKB_hm3/geno/")
# path <- "/net/mulan/disk2/yasheng/comparisonProject/09_external_LD/UKB_hm3/LDmat"
# 
# # ## select snp
# snp1 <- fread2(paste0(comp_str, "03_subsample/hm3/geno/merge.bim"))
# # load("/net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/hm3_snp_inter.RData")
# # 
# # write.table(intersect(hm3_snp_inter[, 1], snp1[, 2]), 
# #             file = sel_snp_str,
# #             col.names = F, row.names = F, quote = F)
# 
# 
# plink_sel_cmd <- paste0("plink-1.9 --silent --bfile ", hm3_str, chr, "_imp",
#                        # "_imp --extract ", sel_snp_str,
#                         " --recode vcf --out ", LD_str, chr)
# system(plink_sel_cmd)
# system(paste0("bgzip ", LD_str, chr, ".vcf"))
# system(paste0("rm ", LD_str, chr, ".log"))
# system(paste0("tabix -p vcf ", LD_str, chr, ".vcf.gz"))
# chr_block <- read.table(paste0(chr_block_str, chr, ".bed"))
# chr_block[, 1] <- sub("chr", "", chr_block[, 1])
# LD_list <- list()
# # for (b in 1: nrow(chr_block)){
# b=1
#   emeraLD_str <- paste0(comp_str, "emeraLD/bin/emeraLD")
#   block_string <- paste0(chr_block[, 1], ":", chr_block[, 2], "-", chr_block[, 3])
#   emeraLD_cmd <- paste0(emeraLD_str, " -i ", LD_str, chr, 
#                         ".vcf.gz --phased --region ", block_string[b],
#                         " --stdout | bgzip -c > ", 
#                         path, "/LD_chr", chr, "_block", b, ".txt.gz")
#   system(emeraLD_cmd)
#   ld_mat_str <- paste0(path, "/LD_chr", chr, "_block", b, ".txt.gz")
#   ld_mat_long <- fread2(ld_mat_str)
#   pos_uni <- unique(c(ld_mat_long[, 2], ld_mat_long[, 3]))
#   ld_mat <- matrix(0, length(pos_uni), length(pos_uni))
#   LD_mat <- list()
#   for(i in 1: c(length(pos_uni)-1)){
#     r_tmp <- ld_mat_long[ld_mat_long[, 2] == pos_uni[i], ]
#     pos_res <- data.frame(POS2 = pos_uni[c((i+1):length(pos_uni))])
#     r_tmp <- merge(pos_res, r_tmp, by = "POS2", all.x = T)
#     ld_mat[(i), c((i+1): dim(ld_mat)[2])] <- ifelse(is.na(r_tmp[, 4]), 0, 
#                                                     r_tmp[, 4])
#   }
#   ld_mat <- ld_mat + t(ld_mat)
#   diag(ld_mat) <- 1
#   # count <- count + length(snp_sub)
#   LD_mat[[1]] <- ld_mat
#   LD_mat[[2]] <- snp1[match(pos_uni, snp1[, 4]), 2]
#   LD_list[[b]] <- LD_mat
#   save(LD_list, file = paste0(comp_str, "09_external_LD/UKB_hm3/LDmat/chr", 
#                               chr, ".RData"))
#   system(paste0("rm ", path, "/LD_chr", chr, "_block", b, ".txt.gz"))
# }