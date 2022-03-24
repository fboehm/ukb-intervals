#! /usr/bin/env Rscript
library(plyr)
library(bigreadr)
library(optparse)

## Parameter setting
args_list = list(
  make_option("--summgemma", type="character", default=NULL,
              help="INPUT: summary data", metavar="character"),
  make_option("--summldsc", type="character", default=NULL,
              help="OUTPUT: summary data for ldsc", metavar="character")
  
)
opt_parser = OptionParser(option_list=args_list)
opt = parse_args(opt_parser)

## load summary data, reference data and full data
summ <- fread2(opt$summgemma, select = c(2, 5, 6, 7, 9, 10))
colnames(summ) <- c("SNP", "N", "A1", "A2", "Beta", "SE")
summ_ldsc <- data.frame(SNP = summ$SNP, 
                        N = summ$N,
                        Z = as.numeric(summ$Beta) / as.numeric(summ$SE),
                        A1 = summ$A1,
                        A2 = summ$A2)

write.table(summ_ldsc, file = opt$summldsc, row.names = F, quote = F, sep = " ")
system (paste0("gzip -f ", opt$summldsc))