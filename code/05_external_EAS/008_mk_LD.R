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
blk_str <- paste0(comp_str, "09_external_LD/EAS/")
blk_info <- fread2(paste0(comp_str, "LDblock_EAS/chr", chr, ".bed"), select = c(2, 3))
chr_str <- paste0(blk_str, "geno/chr", chr)
chr_bim <- fread2(paste0(chr_str, ".bim"), select = c(2, 4, 5, 6))
blk_snp_dat <- aaply(c(1: nrow(blk_info)), 1, function(a) 
  ifelse(chr_bim[, 2]>blk_info[a, 1] & chr_bim[, 2]<=blk_info[a, 2], a, 0))
chr_snp <- vector()
LD_list <- list()
for (b in 1: nrow(blk_info)){
  LD_mat <- list()
  ## get LD matrix
  blk_b_str <- paste0(blk_str, "geno/chr", chr, "_blk", b)
  snp_blk <- chr_bim[blk_snp_dat[b, ] == b, 1]
  if (length(snp_blk) != 0){
    write.table(snp_blk, file = paste0(blk_b_str, ".snp"),
                row.names = F, col.names = F, quote = F)
    LD_cmd <- paste0("plink-1.9 --silent --bfile ", chr_str, " --r square ",
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
    system(paste0("rm ", blk_b_str, ".nosex"))
  }
}
save(LD_list, file = paste0(comp_str, "09_external_LD/EAS/LDmat/chr", chr, ".RData"))
