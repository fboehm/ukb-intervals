#! /usr/bin/env Rscript

library(optparse)
library(bigreadr)

args_list = list(
  make_option("--pp", type="numeric", default=NULL,
              help="INPUT: summary data", metavar="character")
)
opt_parser = OptionParser(option_list=args_list)
opt = parse_args(opt_parser)

pheno <- read.table("/net/mulan/disk2/yasheng/comparisonProject/code/04_external/pheno.txt")[, 1]
pheno_uni <- unique(pheno)
load("/net/mulan/disk2/yasheng/comparisonProject/07_external_c/02_EUR/02_clean/hm3_snp_inter.RData")

p <- pheno_uni[opt$pp]
cat(p, "\n")
summ_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
for (cross in 1: 5){
  for (chr in 1: 22){
      summ <- fread2(paste0(summ_str, "05_internal_c/pheno", p, "/output/summary_hm3_cross", 
                        cross, "_chr", chr, ".assoc.txt"))
      summ_inter <- summ[summ[, 2] %in% hm3_snp_inter$SNP, ]
      write.table(summ_inter, quote = F, row.names = F, col.names = F, sep = "\t",
                  file = paste0(summ_str, "07_external_c/02_EUR/03_res/pheno",
                                p, "_data1/output/summary_hm3_cross",
                                cross, "_chr", chr, ".assoc.txt"))
  }

}
