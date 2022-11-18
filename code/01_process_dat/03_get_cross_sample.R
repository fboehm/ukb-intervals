#! /usr/bin/env Rscript
rm(list=ls())
library(tidyverse)
library(plyr)

# load data
comp_str <- "~/research/ukb-intervals/"
load(paste0(comp_str, "02_pheno/01_sqc.RData"))
load(paste0(comp_str, "02_pheno/04_pheno_c_adj.RData"))
load(paste0("02_pheno/05_pheno_b_clean.RData"))

# na idx for continuous phenotypes
na_list_c <- lapply(1:25, function(x){
  sqc_i$idx[which(is.na(pheno_c_adj[,x]))]
})
# na_list_c contains a list with 25 vectors of integers.
# each vector contains the indices for the subjects with NA value for trait of interest


# na idx for binary phenotypes
na_list_b <- lapply(1:25, function(x){
  sqc_i$idx[which(is.na(pheno_b_all[,x]))]
})

# parameters
ref_num <- 250 # reference number: 500 inviduals (250 males and 250 females)

##########################
### Get the reference index
## reference index
# male
idx_male <- which(sqc_i$Inferred.Gender == "M")
sqc_male <- sqc_i[idx_male, c("Inferred.Gender", "idx")]
set.seed(20170529)
idx_male_ref <- sample(sqc_male$idx, ref_num)
# female
idx_female <- which(sqc_i$Inferred.Gender == "F")
sqc_female <- sqc_i[idx_female, c("Inferred.Gender", "idx")]
set.seed(20170529)
idx_female_ref <- sample(sqc_female$idx, ref_num)
# index for reference 
idx_ref <- sort(c(idx_male_ref, idx_female_ref))
 write.table(cbind(idx_ref, idx_ref), 
             file = paste0(comp_str, "04_reference/01_idx.txt"), 
             col.names = F, row.names = F, quote = F)
##########################

##########################
# delete reference sample 
#idx_ref <- read.table(paste0(comp_str, "04_reference/01_idx.txt"))[, 1]
sqc_sub <- sqc_i[!sqc_i$idx %in% idx_ref,]

# parameters
pheno_seed_str <- 2020*1:25
fold <- 5
group_num <- 10
cross_seed <- 20170529

##########################
# Continuous trait
sample_size_dat <- data.frame()
for (p in 1:25) {
  sample_size_mat <- matrix(NA, fold, 5) #nrow = fold & ncol = 5
  idx_tot <- setdiff(sqc_sub$idx, na_list_c[[p]])
  sample_size_mat[c(1:5), 1] <- length(idx_tot)
  cat("pheno", p, "include", length(idx_tot), "samples.\n")
  set.seed(pheno_seed_str[p])
  idx_group <- idx_tot %>% as.data.frame() %>%
    split(sample(1:group_num, length(idx_tot), replace=T))
  # sample(1:group_num, length(idx_tot), replace=T) draws numbers 1 through 10, with replacement, 
  # for every entry in idx_tot... so we have a vector of length `length(idx_tot)` with each entry being a number from 
  # 1 to 10.
  # application of `split` function creates a list of length 10 (one entry per integer). Each entry in the list is a data.frame with one column. 
  # the one column contains the indices for members of that 'group' (ie, for that entry in the list)
  
  
  # Step1: validation and PGSagg set
  ## get index
  set.seed(pheno_seed_str[p])
  idx_val_agg <- idx_group[[1]] %>%
    split(sample(1:2, nrow(idx_group[[1]]), replace=T))
  idx_val <- idx_val_agg[[1]][, 1]
  idx_agg <- idx_val_agg[[2]][, 1]
  sample_size_mat[c(1:5), 2] <- length(idx_val)
  sample_size_mat[c(1:5), 3] <- length(idx_agg)
  cat("pheno", p, "include val", length(idx_val), "samples, and",
      "agg", length(idx_agg), "samples.\n")
  ## pheno data
  pheno_c_adj_val <- pheno_c_adj[match(idx_val, sqc_i$idx), p]
  pheno_c_adj_agg <- pheno_c_adj[match(idx_agg, sqc_i$idx), p]
  # ## output
  write.table(cbind(idx_val, idx_val),
               file = paste0(comp_str, "03_subsample/continuous/pheno", p,
                             "/val/01_idx.txt"),
               col.names = F, row.names = F, quote = F)
   write.table(data.frame(pheno_c_adj_val),
               file = paste0(comp_str, "03_subsample/continuous/pheno", p,
                             "/val/02_pheno_c.txt"),
               col.names = F, row.names = F, quote = F)
  
  # Step2: cross validation set
  set.seed(pheno_seed_str[p]+cross_seed)
  group_test <- sample(c(2: group_num), fold, replace = F) ## for
  pheno_train <- pheno_test <- matrix(NA, nrow(pheno_c_adj), 5)
  for(cross in 1: fold){
    
    ## test set
    idx_test <- idx_group[[group_test[cross]]][, 1]
    pheno_test[, cross] <- pheno_c_adj[, p]
    pheno_test[!sqc_i$idx%in%idx_test, cross] <- NA
    ## train set
    idx_train <- idx_group[-c(1, group_test[cross])] %>% llply(function(a) a[, 1]) %>%
      unlist %>% sort
    pheno_train[, cross] <- pheno_c_adj[, p]
    pheno_train[!sqc_i$idx%in%idx_train, cross] <- NA
    sample_size_mat[cross, 4] <- length(idx_test)
    sample_size_mat[cross, 5] <- sum(!is.na(pheno_train[, cross]))
    cat("pheno", p, "include train", sample_size_mat[cross, 5],
        "samples, and test", sample_size_mat[cross, 4], "samples.\n")
    # write.table(cbind(idx_test, idx_test),
    #            file = paste0(comp_str, "02_pheno/01_test_idx_c/idx_pheno", p, "_cross", cross, ".txt"),
    #            quote = F, row.names = F, col.names = F)
  }
  # write.table(pheno_train, file = paste0(comp_str, "02_pheno/02_train_c/pheno_pheno", p, ".txt"),
  #             quote = F, row.names = F, col.names = F)
  # write.table(pheno_test, file = paste0(comp_str, "02_pheno/03_test_c/pheno_pheno", p, ".txt"),
  #             quote = F, row.names = F, col.names = F)
  
  sample_size_dat <- rbind(sample_size_dat, sample_size_mat)
}
pheno_uni_c <- c("SH", "PLT", "BMD", "BMR", "BMI", 
                 "RBC", "AM", "RDW", "EOS", "WBC", 
                 "FVC", "FEV", "FFR", "WC", "HC",
                 "WHR", "SBP", "BW", "BFP", "TFP", 
                 "SU", "TC", "HDL", "LDL", "TG")
sample_size_dat <- data.frame(rep(pheno_uni_c, each = 5), 
                              sample_size_dat)
write.table(sample_size_dat, file = paste0(comp_str, "02_pheno/sample_size_c.txt"),
            quote = F, row.names = F, col.names = F)



##########################
# Binary trait
sample_size_dat <- data.frame()
covVar_all <- as.matrix(cbind(sqc_i[, c(26:35)], 
                              ifelse(sqc_i$Inferred.Gender == "F", 0, 1)))
for (p in 1:25) {
  sample_size_mat <- matrix(NA, fold, 5)
  idx_tot <- setdiff(sqc_sub$idx, na_list_b[[p]])
  sample_size_mat[c(1:5), 1] <- length(idx_tot)
  cat("pheno", p, "include", length(idx_tot), "samples.\n")
  set.seed(pheno_seed_str[p])
  idx_group <- idx_tot %>% as.data.frame() %>% 
    split(sample(1:group_num, length(idx_tot), replace=T))
  
  # Step1: validation and PGSagg set
  ## get index
  set.seed(pheno_seed_str[p])
  idx_val_agg <- idx_group[[1]] %>% 
    split(sample(1:2, nrow(idx_group[[1]]), replace=T))
  idx_val <- idx_val_agg[[1]][, 1]
  idx_agg <- idx_val_agg[[2]][, 1]
  sample_size_mat[c(1:5), 2] <- length(idx_val)
  sample_size_mat[c(1:5), 3] <- length(idx_agg)
  cat("pheno", p, "include val", length(idx_val), "samples, and", 
      "agg", length(idx_agg), "samples.\n")
  ## pheno data
  pheno_b_all_val <- pheno_b_all[match(idx_val, sqc_i$idx), p]
  pheno_b_all_agg <- pheno_b_all[match(idx_agg, sqc_i$idx), p]
  ## covariates data
  if(!p %in% c(1, 6, 21)){
    ## validation
    covVar_val <- data.frame(y = pheno_b_all_val, 
                             covVar_all[match(idx_val, sqc_i$idx), ])
    # linear model
    coefMat_val <- lm(y~., data = covVar_val) %>% coef()
    pred_val <- cbind(1, covVar_all[match(idx_val, sqc_i$idx), ]) %*% coefMat_val
    # logistic regression
    coefMat_val_glm <- glm(y~., data = covVar_val,
                           family = binomial(link = "logit")) %>% coef()
    pred_val_glm <- cbind(1, covVar_all[match(idx_val, sqc_i$idx), ]) %*% coefMat_val_glm
    ## aggregation
    covVar_agg <- data.frame(y = pheno_b_all_agg, 
                             covVar_all[match(idx_agg, sqc_i$idx), ])
    # linear model
    coefMat_agg <- lm(y~., data = covVar_agg) %>% coef()
    pred_agg <- cbind(1, covVar_all[match(idx_agg, sqc_i$idx), ]) %*% coefMat_agg
    # logistic regression
    coefMat_agg_glm <- glm(y~., data = covVar_agg,
                           family = binomial(link = "logit")) %>% coef()
    pred_agg_glm <- cbind(1, covVar_all[match(idx_agg, sqc_i$idx), ]) %*% coefMat_agg_glm
    
  } else {
    ## validation
    covVar_val <- data.frame(y = pheno_b_all_val, 
                             covVar_all[match(idx_val, sqc_i$idx), -11])
    # linear model
    coefMat_val <- lm(y~., data = covVar_val) %>% coef()
    pred_val <- cbind(1, covVar_all[match(idx_val, sqc_i$idx), -11]) %*% coefMat_val
    # logistic regression
    coefMat_val_glm <- glm(y~., data = covVar_val, 
                           family = binomial(link = "logit")) %>% coef()
    pred_val_glm <- cbind(1, covVar_all[match(idx_val, sqc_i$idx), -11]) %*% coefMat_val_glm
    
    ## aggregation
    covVar_agg <- data.frame(y = pheno_b_all_agg, 
                             covVar_all[match(idx_agg, sqc_i$idx), -11])
    # linear model
    coefMat_agg <- lm(y~., data = covVar_agg) %>% coef()
    pred_agg <- cbind(1, covVar_all[match(idx_agg, sqc_i$idx), -11]) %*% coefMat_agg
    # logistic regression
    coefMat_agg_glm <- glm(y~., data = covVar_agg, 
                           family = binomial(link = "logit")) %>% coef()
    pred_agg_glm <- cbind(1, covVar_all[match(idx_agg, sqc_i$idx), -11]) %*% coefMat_agg_glm
  }
  ## output
   write.table(cbind(idx_val, idx_val), 
               file = paste0(comp_str, "03_subsample/binary/pheno", p,
                             "/val/01_idx.txt"),
               col.names = F, row.names = F, quote = F)
   write.table(pheno_b_all_val, 
               file = paste0(comp_str, "03_subsample/binary/pheno", p,
                             "/val/02_pheno_b.txt"), 
               col.names = F, row.names = F, quote = F)
   write.table(pred_val, 
               file = paste0(comp_str, "03_subsample/binary/pheno",p,
                             "/val/03_cov_eff.txt"), 
               row.names = F, col.names = F, quote = F)
  # write.table(pred_val_glm,
  #             file = paste0(comp_str, "03_subsample/binary/pheno",p,
  #                           "/val/04_cov_eff_glm.txt"),
  #             row.names = F, col.names = F, quote = F)
  # write.table(cbind(idx_agg, idx_agg), 
  #             file = paste0(comp_str, "03_subsample/binary/pheno", p,
  #                           "/agg/01_idx.txt"),
  #             col.names = F, row.names = F, quote = F)
  # write.table(pheno_b_all_agg, 
  #             file = paste0(comp_str, "03_subsample/binary/pheno", p,
  #                           "/agg/02_pheno_b.txt"), 
  #             col.names = F, row.names = F, quote = F)
  # write.table(pred_agg, 
  #             file = paste0(comp_str, "03_subsample/binary/pheno",p,
  #                           "/agg/03_cov_eff.txt"), 
  #             row.names = F, col.names = F, quote = F)
  # write.table(pred_agg_glm,
  #             file = paste0(comp_str, "03_subsample/binary/pheno",p,
  #                           "/agg/04_cov_eff_glm.txt"),
  #             row.names = F, col.names = F, quote = F)
  
  
  # Step2: cross validation set
  set.seed(pheno_seed_str[p]+cross_seed)
  group_test <- sample(c(2: group_num), fold, replace = F) ## for
  pheno_train <- pheno_test <- coveff <- coveff_glm <- matrix(NA, nrow(pheno_b_all), 5)
  for(cross in 1: fold){
    
    ## train set
    idx_train <- idx_group[-c(1, group_test[cross])] %>% llply(function(a) a[, 1]) %>%
      unlist %>% sort
    pheno_train[, cross] <- pheno_b_all[, p]
    pheno_train[!sqc_i$idx%in%idx_train, cross] <- NA
    if(!p %in% c(1, 6, 21)){
      covVar_train <- data.frame(y = pheno_train[, cross], 
                                 covVar_all)
      # linear model
      coefMat_train <- lm(y~., data = covVar_train) %>% coef()
      # logistic model
      coefMat_train_glm <- glm(y~., data = covVar_train, 
                               family = binomial(link = "logit")) %>% coef()
      
    } else {
      covVar_train <- data.frame(y = pheno_train[, cross], 
                                 covVar_all[, -11])
      # linear model
      coefMat_train <- lm(y~., data = covVar_train) %>% coef()
      # logistic model
      coefMat_train_glm <- glm(y~., data = covVar_train, 
                               family = binomial(link = "logit")) %>% coef()
      
    }
    
    ## test set
    idx_test <- idx_group[[group_test[cross]]][, 1]
    pheno_test[, cross] <- pheno_b_all[, p]
    pheno_test[!sqc_i$idx%in%idx_test, cross] <- NA
    if(!p %in% c(1, 6, 21)){
      coveff[sqc_i$idx%in%idx_test, cross] <- cbind(1, covVar_all[match(idx_test, sqc_i$idx), ]) %*% coefMat_train
      coveff_glm[sqc_i$idx%in%idx_test, cross] <- cbind(1, covVar_all[match(idx_test, sqc_i$idx), ]) %*% coefMat_train_glm
    } else {
      coveff[sqc_i$idx%in%idx_test, cross] <- cbind(1, covVar_all[match(idx_test, sqc_i$idx), -11]) %*% coefMat_train
      coveff_glm[sqc_i$idx%in%idx_test, cross] <- cbind(1, covVar_all[match(idx_test, sqc_i$idx), -11]) %*% coefMat_train_glm
    }
    sample_size_mat[cross, 4] <- length(idx_test)
    sample_size_mat[cross, 5] <- sum(!is.na(pheno_train[, cross]))
    cat("pheno", p, "include train", sample_size_mat[cross, 5],
        "samples, and test", sample_size_mat[cross, 4], "samples.\n")
     write.table(cbind(idx_test, idx_test),
                file = paste0(comp_str, "02_pheno/04_test_idx_b/idx_pheno", p, "_cross", cross, ".txt"),
                quote = F, row.names = F, col.names = F)
  }
   write.table(pheno_train, file = paste0(comp_str, "02_pheno/05_train_b/pheno_pheno", p, ".txt"),
               quote = F, row.names = F, col.names = F)
   write.table(pheno_test, file = paste0(comp_str, "02_pheno/06_test_b/pheno_pheno", p, ".txt"),
               quote = F, row.names = F, col.names = F)
   write.table(coveff, file = paste0(comp_str, "02_pheno/06_test_b/coveff_pheno", p, ".txt"),
               quote = F, row.names = F, col.names = F)
   write.table(coveff_glm, file = paste0(comp_str, "02_pheno/06_test_b/coveff_pheno", p, "_glm.txt"),
               quote = F, row.names = F, col.names = F)
  sample_size_dat <- rbind(sample_size_dat, sample_size_mat)
}
pheno_uni_b <- c("PRCA", "TA", "T2D", "CAD", "RA", 
                 "BRCA", "AS", "MP", "MDD", "SS", 
                 "QU", "HT", "FFI", "DFI", "OA", 
                 "AN", "GO", "SAF", "HA", "TE", 
                 "T1B", "VMS", "MY", "SN", "ES")
sample_size_dat <- data.frame(rep(pheno_uni_b, each = 5), sample_size_dat)
write.table(sample_size_dat, file = paste0(comp_str, "02_pheno/xsample_size_b.txt"),
            quote = F, row.names = F, col.names = F)

