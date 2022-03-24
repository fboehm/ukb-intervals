#! /usr/bin/env Rscript
rm(list=ls())
library(bigreadr)
library(plyr)
library(optparse)

## Input parameters
args_list = list(
  make_option("--chr", type="numeric", default=NULL,
              help="INPUT: gemma file", metavar="character")
)

opt_parser = OptionParser(option_list=args_list)
opt = parse_args(opt_parser)

chr = opt$chr

## set parameters
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
hm3_str <- paste0(comp_str, "04_reference/hm3/")
blk_str <- paste0(hm3_str, "blk/")
blk_info <- fread2(paste0("/net/mulan/disk2/yasheng/comparisonProject-archieve/LDblock_EUR/chr", chr, ".bed"), select = c(2, 3))
chr_str <- paste0(hm3_str, "geno/chr", chr)
chr_bim <- fread2(paste0(chr_str, ".bim"), select = c(2, 4, 5, 6))
blk_snp_dat <- aaply(c(1: nrow(blk_info)), 1, function(a) 
  ifelse(chr_bim[, 2]>blk_info[a, 1] & chr_bim[, 2]<=blk_info[a, 2], a, 0))
chr_snp <- vector()

for (b in 1: nrow(blk_info)){

  ## get LD matrix
  blk_b_str <- paste0(blk_str, "chr", chr, "_blk", b)
  snp_blk <- chr_bim[blk_snp_dat[b, ] == b, 1]
  write.table(snp_blk, file = paste0(blk_b_str, ".snp"),
              row.names = F, col.names = F, quote = F)
  LD_cmd <- paste0("plink-1.9 --silent --bfile ", chr_str, " --r square ",
                    " --extract ", blk_b_str, ".snp --out ", blk_b_str)
  system(LD_cmd)
  chr_snp <- c(chr_snp, snp_blk)

  ## remove files
  system(paste0("rm ", blk_b_str, ".log"))
  cat ("blk", b, "snp number: ", length(snp_blk), "\n")
}

## get MAF
frq_cmd <- paste0("plink-1.9 --silent --bfile ", chr_str,
                  " --freq --out ", chr_str)
system(frq_cmd)
system(paste0("rm ", chr_str, ".log"))

chr_frq <- fread2(paste0(chr_str, ".frq"), select = c(1, 2, 3, 4, 5))
chr_frq <- cbind(chr_frq[, c(1, 2)], chr_bim[, 2], chr_frq[, -c(1, 2)])
chr_frq <- chr_frq[match(chr_snp, chr_frq[, 2]), ]
cat ("chr ", chr, ": ", nrow(chr_frq), "snps.\n")
if (chr < 10){
  write.table(chr_frq, file = paste0(hm3_str, "/ldblk_1kg_eur/snpinfo_1kg_hm3_chr0", chr), 
              row.names = F, col.names = F, quote = F, sep = "\t")
} else {
  write.table(chr_frq, file = paste0(hm3_str, "/ldblk_1kg_eur/snpinfo_1kg_hm3_chr", chr), 
              row.names = F, col.names = F, quote = F, sep = "\t")
}
