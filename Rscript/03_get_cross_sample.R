#! /usr/bin/env Rscript
rm(list=ls())
library(tidyverse)
library(plyr)

# load data
load("/net/mulan/disk2/yasheng/comparisonProject/02_pheno/01_sqc.RData")
load("/net/mulan/disk2/yasheng/comparisonProject/02_pheno/04_pheno_c_adj.RData")
load("/net/mulan/disk2/yasheng/comparisonProject/02_pheno/05_pheno_b_clean.RData")
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"

# parameters
sub_num <- 500 # subsample number: 1000 inviduals
ref_num <- 250 # reference number: 500 inviduals

##########################
### First get the subsample index
## subsample index
# male
idx_male <- which(sqc_i$Inferred.Gender == "M")
sqc_male <- sqc_i[idx_male, c("Inferred.Gender", "idx")]
set.seed(2020825)
idx_male_sub <- sample(sqc_male$idx, sub_num)
# female
idx_female <- which(sqc_i$Inferred.Gender == "F")
sqc_female <- sqc_i[idx_female, c("Inferred.Gender", "idx")]
set.seed(2020825)
idx_female_sub <- sample(sqc_female$idx, sub_num)
# index for subsample 
idx_sub <- sort(c(idx_male_sub, idx_female_sub))
write.table(cbind(idx_sub, idx_sub), file = paste0(comp_str, "03_subsample/01_idx.txt"),
            col.names = F, row.names = F, quote = F)
write.table(cbind(sort(idx_female_sub), sort(idx_female_sub)),
            file = paste0(comp_str, "03_subsample/01_idx_female.txt"),
            col.names = F, row.names = F, quote = F)
write.table(cbind(sort(idx_male_sub), sort(idx_male_sub)),
            file = paste0(comp_str, "03_subsample/01_idx_male.txt"),
            col.names = F, row.names = F, quote = F)
pheno_c_adj_sub <- pheno_c_adj[sqc_i$idx %in% idx_sub, ]
pheno_b_all_sub <- pheno_b_all[sqc_i$idx %in% idx_sub, ]
write.table(pheno_c_adj_sub, file = paste0(comp_str, "03_subsample/02_pheno_c.txt"),
            col.names = F, row.names = F, quote = F)
write.table(pheno_b_all_sub, file = paste0(comp_str, "03_subsample/03_pheno_b.txt"),
            col.names = F, row.names = F, quote = F)
### End here!
##########################

##########################
### change the phenotype, build subsample by the same index
idx_sub <- read.table(paste0(comp_str, "03_subsample/01_idx.txt"))[, 1]
pheno_c_adj_sub <- pheno_c_adj[sqc_i$idx %in% idx_sub, ]
pheno_b_all_sub <- pheno_b_all[sqc_i$idx %in% idx_sub, ]
write.table(pheno_c_adj_sub, file = paste0(comp_str, "03_subsample/02_pheno_c.txt"),
            col.names = F, row.names = F, quote = F)
#write.table(pheno_b_all_sub, file = paste0(comp_str, "03_subsample/03_pheno_b.txt"),
#            col.names = F, row.names = F, quote = F)
### End here!
##########################

##########################
## first reference panel
set.seed(20170529)
idx_male_ref <- sample(idx_male_sub, ref_num)
set.seed(20170529)
idx_female_ref <- sample(idx_female_sub, ref_num)
idx_ref <- c(idx_male_ref, idx_female_ref)
write.table(cbind(idx_ref, idx_ref), file = "/net/mulan/disk2/yasheng/comparisonProject/04_reference/01_idx.txt",
            col.names = F, row.names = F, quote = F)
idx_ref <- read.table("/net/mulan/disk2/yasheng/comparisonProject/04_reference/01_idx.txt")[, 1]

# delete subsample and 5 folds cross validation
fold <- 5
seed_str <- c(20170529, 170529, 70529, 529, 20, 9)
label_sub <- ifelse(sqc_i$idx %in% idx_sub, 1, 0)

## continuous traits 
label_na <- apply(pheno_c_adj, 2, function(a) ifelse(is.na(a), 1, 0))
pheno_c_adj[label_sub == 1, ] <- NA
for (p in 1: 25){
  pheno_train <- matrix(NA, nrow = nrow(pheno_c_adj), ncol = fold)
  pheno_test <- matrix(NA, nrow = nrow(pheno_c_adj), ncol = fold)
  cnd <- label_na[, p] == 0 & label_sub == 0
  n_train <- vector("numeric", fold)
  for(cross in 1: fold){
    label_cross <- vector("numeric", nrow(pheno_c_adj))
    set.seed(seed_str[cross])
    label_cross[cnd] <- rbinom(length(sqc_i$idx[cnd]), 1, c(1 - 1/fold))
    label_cross[label_cross == 0 & !is.na(pheno_c_adj[, p])] <- -1
    pheno_train[label_cross == 1, cross] <- pheno_c_adj[label_cross == 1, p]
    pheno_test[label_cross == -1, cross] <- pheno_c_adj[label_cross == -1, p]
    n_train[cross] <- sum(label_cross == 1)
    n <- sum(label_cross == 1) + sum(label_cross == -1)
    test_idx <- sqc_i$idx[label_cross == -1]
    write.table(cbind(test_idx, test_idx),
                file = paste0(comp_str, "02_pheno/01_test_idx_c/idx_pheno", p, "_cross", cross, ".txt"),
                quote = F, row.names = F, col.names = F)
  }
  cat ("pheno: ", p, " sample size: ", n, "\n")
  write.table(n_train, file = paste0(comp_str, "02_pheno/02_train_c/n_pheno", p, ".txt"),
              quote = F, row.names = F, col.names = F)
  write.table(pheno_train, file = paste0(comp_str, "02_pheno/02_train_c/pheno_pheno", p, ".txt"),
              quote = F, row.names = F, col.names = F)
  write.table(pheno_test, file = paste0(comp_str, "02_pheno/03_test_c/pheno_pheno", p, ".txt"),
              quote = F, row.names = F, col.names = F)
}

