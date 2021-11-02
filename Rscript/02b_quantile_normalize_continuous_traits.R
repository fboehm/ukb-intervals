#! /usr/bin/env Rscript
rm(list=ls())
library(tidyverse)
library(plyr)

# load data
# load("/net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData")
load("/net/mulan/disk2/yasheng/comparisonProject/02_pheno/04_pheno_c_adj.RData")
#load("/net/mulan/disk2/yasheng/comparisonProject/02_pheno/05_pheno_b_clean.RData")
comp_str <- "~/research/ukb-intervals/data/"


