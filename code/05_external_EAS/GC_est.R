#! /usr/bin/env Rscript
rm(list=ls())
library(bigreadr)
library(optparse)

# Input parameters
args_list = list(
  make_option("--summ", type="character", default=NULL,
              help="INPUT: gemma file", metavar="character"), 
  make_option("--out", type="character", default=NULL,
              help="INPUT: output file", metavar="character")
)

opt_parser = OptionParser(option_list=args_list)
opt = parse_args(opt_parser)

#
summ <- fread2(opt$summ)
print("Summary statistics has been loaded.\n")
chisq = qchisq(summ$p_wald,1,lower.tail=FALSE)
lambda <- median(chisq) / qchisq(0.5, 1) 

nsnp <- nrow(summ)
nsample <- max(summ$n_obs)
fwrite2(data.frame(nsample,nsnp,lambda), file = opt$out, sep = "\t")
print("GC estimation is ok!\n")