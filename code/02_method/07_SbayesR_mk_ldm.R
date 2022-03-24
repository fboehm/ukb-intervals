#! /usr/bin/env Rscript
library(tidyverse)
library(plyr)
library(optparse)

## Parameter setting
args_list = list(
  make_option("--chr", type="character", default=NULL,
              help="INPUT: summary data", metavar="character")
)
opt_parser = OptionParser(option_list=args_list)
opt = parse_args(opt_parser)

## define file string
hm3_str <- "/net/mulan/disk2/yasheng/comparisonProject/04_reference/hm3/"
ref_hm3_str <- paste0(hm3_str, "geno/")
ldm_hm3_str <- paste0(hm3_str, "ldm/")
gctb_str <- "/net/mulan/home/yasheng/comparisonProject/program/gctb_2.0_Linux/gctb"
ref_str <- paste0(ref_hm3_str, "chr", opt$chr)
map_str <- paste0("/net/mulan/disk2/yasheng/comparisonProject/interpolated_OMNI/chr", 
                  opt$chr, ".OMNI.interpolated_genetic_map")
out_str <- paste0(ldm_hm3_str, "/chr", opt$chr)

## load bim file 
snp_num_i <- 20000
bim_file <- read_delim(paste0(ref_hm3_str, "chr", opt$chr, ".bim"), delim = "\t", 
                       col_names = F)
snp_num <- nrow(bim_file)

if (snp_num >= snp_num_i){
  
  ## block 
  snp_len <- ceiling(snp_num/snp_num_i)
  snp_list_begin <- c(0: c(snp_len-1)) * snp_num_i + 1
  snp_list_end <- c(0: c(snp_len-1)) * snp_num_i + 20000
  snp_list_end[snp_len] <- snp_num
  snp_list <- paste0(snp_list_begin, "-", snp_list_end)

  ## gctb block 
  gctb_cmd_mat <- paste0(gctb_str, " --bfile ", ref_str, 
                         " --make-shrunk-ldm --gen-map ", map_str, 
                         " --snp ", snp_list, 
                         " --out ", out_str)
  
  gctb_ref <- aaply(gctb_cmd_mat, 1, function(a) system(a))

  ## output snp_list
  snp_list_str <- paste0(ldm_hm3_str, "/snplist_chr", opt$chr, ".txt")
  snp_list_file <- aaply(snp_list, 1, function(a) paste0(ldm_hm3_str, "chr", opt$chr, 
                               ".snp", a, ".ldm.shrunk"))
  write.table(snp_list_file, file = snp_list_str, 
              col.names = F, row.names = F, quote = F)
  
  ## merge 
  out_chr_str <- paste0(ldm_hm3_str, "/chr", opt$chr)
  merge_cmd <- paste0(gctb_str, " --mldm ", snp_list_str, 
                      " --make-shrunk-ldm --out ", out_chr_str)
  system(merge_cmd)
  
  ## remove files
  snp_list_rm <- aaply(snp_list_file, 1, function(a) system(paste0("rm ", a, "*")))
  system(paste0("rm ", snp_list_str))
  
} else {
  gctb_cmd <- paste0(gctb_str, " --bfile ", ref_str, 
                     " --make-shrunk-ldm --gen-map ", map_str, 
                     " --out ", out_str)
  system(gctb_cmd)
}

