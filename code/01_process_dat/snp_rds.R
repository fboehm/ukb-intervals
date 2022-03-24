#! /usr/bin/env Rscript
rm(list=ls())
library(bigstatsr)
library(bigsnpr)
library(optparse)

## Input parameters
args_list = list(
  make_option("--bed_str", type="character", default=NULL,
              help="INPUT: plink file", metavar="character")
)

opt_parser = OptionParser(option_list=args_list)
opt = parse_args(opt_parser)
bedstr <- opt$bed_str
# val_str <- paste0(comp_str, "03_subsample/binary/pheno", p,
#                   "/val/rare/impute_inter/chr",chr)
if(!file.exists(paste0(bedstr, ".rds")) | !file.exists(paste0(bedstr, ".bk"))){
  # system(paste0("rm ", val_str, ".bk"))
  if(file.exists(paste0(bedstr, ".bk"))){
    system(paste0("rm ", bedstr, ".bk"))
  }
  val_bed <- snp_readBed(paste0(bedstr, ".bed"))
} 

