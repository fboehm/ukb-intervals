#! /usr/bin/env Rscript
rm(list=ls())
library(tidyverse)
library(plyr)

# load data
comp_str <- "~/research/ukb-intervals/"
load(paste0(comp_str, "02_pheno/01_sqc.RData"))
load(paste0(comp_str, "02_pheno/04_pheno_c_adj.RData"))
load(paste0(comp_str, "02_pheno/05_pheno_b_clean.RData"))
rm(comp_str)
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
ref_num <- 500 # reference number: 1000 inviduals (500 males and 500 females)
# we extract 1000 subjects for use in the reference 
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
##########################
 


##########################
# delete reference sample 
#idx_ref <- read.table(paste0(comp_str, "04_reference/01_idx.txt"))[, 1]
sqc_sub <- sqc_i[!sqc_i$idx %in% idx_ref,]

# parameters
pheno_seed_str <- 2020*1:25
n_folds <- c(5, 10, 20)
cross_seed <- 20170529

##########################
# Continuous trait
for (n_fold in n_folds){
    comp_str <- paste0("~/research/ukb-intervals/study_nfolds/", n_fold, "-fold/")
    # trait values get split into 
    for (p in 1:25) {
        idx_tot <- setdiff(sqc_sub$idx, na_list_c[[p]])
        cat("pheno", p, "include", length(idx_tot), "samples.\n")
        set.seed(pheno_seed_str[p])
        # put 20% of subjects with nonmissing trait values into validation plus verification set
        # sample the indices 
        idx_val_ver <- sample(x = idx_tot, size = floor(0.2 * length(idx_tot)), replace = FALSE)
        cat("pheno", p, "include val_ver ", length(idx_val_ver), " samples.\n")
        idx_val <- sample(idx_val_ver, size = floor(length(idx_val_ver) / 2), replace = FALSE)
        idx_ver <- setdiff(idx_val_ver, idx_val)
        ## assemble a tibble with idx_ver & the corresponding trait values
        ver_tib <- tibble::tibble(FID = idx_ver, IID = idx_ver) %>%
            dplyr::arrange(FID) %>%
            dplyr::mutate(true_pheno = pheno_c_adj[match(IID, sqc_i$idx), p])
        mydir_ver <- paste0(comp_str, 
                    "03_subsample/continuous/pheno", 
                    p,
                    "/verif/")
        if (!dir.exists(mydir_ver)){dir.create(mydir_ver, recursive = TRUE)} 
        fn <- paste0(mydir_ver, "03_idx_pheno.txt")
        ver_tib %>%
            vroom::vroom_write(file = fn, col_names = FALSE)

        ## pheno data
        pheno_c_adj_val <- pheno_c_adj[match(idx_val, sqc_i$idx), p]
        pheno_c_adj_ver <- pheno_c_adj[match(idx_ver, sqc_i$idx), p]
        ## output
        mydir_val <- paste0(comp_str, 
                        "03_subsample/continuous/pheno", 
                        p,
                        "/val/")
        if (!dir.exists(mydir_val)){dir.create(mydir_val, recursive = TRUE)} 
        write.table(cbind(idx_val, idx_val),
                    file = paste0(mydir_val, "01_idx.txt"),
                    col.names = F, 
                    row.names = F, 
                    quote = F)
        write.table(pheno_c_adj_val, 
                file = paste0(mydir_val, "02_pheno_c.txt"), 
                col.names = F, row.names = F, quote = F)

        write.table(cbind(idx_ver, idx_ver),
                    file = paste0(mydir_ver, "01_idx.txt"),
                    col.names = F, 
                    row.names = F, 
                    quote = F)
        write.table(pheno_c_adj_ver, 
                file = paste0(mydir_ver, "02_pheno_c.txt"), 
                col.names = F, row.names = F, quote = F)
                        
        # Step2: cross validation set
        idx_cv <- setdiff(idx_tot, idx_val_ver)
        set.seed(pheno_seed_str[p]+cross_seed)
        if (n_fold == 5){
          split_indices <- splitTools::partition(idx_cv, p = c(fold1 = 1 / n_fold, 
                                                                fold2 = 1 / n_fold, 
                                                                fold3 = 1 / n_fold, 
                                                                fold4 = 1 / n_fold, 
                                                                fold5 = 1 / n_fold)
          )
            
        }
        if (n_fold == 10){
            split_indices <- splitTools::partition(idx_cv, p = c(fold1 = 1 / n_fold, 
                                                                fold2 = 1 / n_fold, 
                                                                fold3 = 1 / n_fold, 
                                                                fold4 = 1 / n_fold, 
                                                                fold5 = 1 / n_fold,
                                                                fold6 = 1 / n_fold, 
                                                                fold7 = 1 / n_fold, 
                                                                fold8 = 1 / n_fold, 
                                                                fold9 = 1 / n_fold, 
                                                                fold10 = 1 / n_fold
                                                                )
                                                                )
        }
        if (n_fold == 20){
            split_indices <- splitTools::partition(idx_cv, p = c(fold1 = 1 / n_fold, 
                                                                fold2 = 1 / n_fold, 
                                                                fold3 = 1 / n_fold, 
                                                                fold4 = 1 / n_fold, 
                                                                fold5 = 1 / n_fold,
                                                                fold6 = 1 / n_fold, 
                                                                fold7 = 1 / n_fold, 
                                                                fold8 = 1 / n_fold, 
                                                                fold9 = 1 / n_fold, 
                                                                fold10 = 1 / n_fold,
                                                                fold11 = 1 / n_fold, 
                                                                fold12 = 1 / n_fold, 
                                                                fold13 = 1 / n_fold, 
                                                                fold14 = 1 / n_fold, 
                                                                fold15 = 1 / n_fold,
                                                                fold16 = 1 / n_fold, 
                                                                fold17 = 1 / n_fold, 
                                                                fold18 = 1 / n_fold, 
                                                                fold19 = 1 / n_fold, 
                                                                fold20 = 1 / n_fold
                                                                )
                                                                )
        }
    #  group_test <- sample(c(2: group_num), fold, replace = F) ## for
    pheno_train <- pheno_test <- matrix(NA, nrow(pheno_c_adj), n_fold)
    for (cross in 1:n_fold) {
        ## test set
        # get indices for each test fold
        idx_test <- idx_cv[split_indices[[cross]]]
        # column of pheno_test is initialized with column from pheno_c_adj
        pheno_test[, cross] <- pheno_c_adj[, p]
        # same column has non-test entries set to NA
        pheno_test[!sqc_i$idx %in% idx_test, cross] <- NA
        ## train set
        idx_train <- setdiff(idx_cv, idx_test)
        # initially, set pheno_train column to the full trait vector
        pheno_train[, cross] <- pheno_c_adj[, p]
        # then, replace test subjects' entries with NA
        pheno_train[!sqc_i$idx %in% idx_train, cross] <- NA
        mydir <- paste0(comp_str, 
                    "02_pheno/01_test_idx_c/")
        if (!dir.exists(mydir)){dir.create(mydir, recursive = TRUE)} 
        write.table(cbind(idx_test, idx_test),
                    file = paste0(mydir, "idx_pheno", 
                    p, 
                    "_cross", 
                    cross, 
                    ".txt"),
                    quote = F, 
                    row.names = F, 
                    col.names = F)
    }
    mydir <- paste0(comp_str,
                    "02_pheno/02_train_c/")
    if (!dir.exists(mydir)){dir.create(mydir, recursive = TRUE)} 
    write.table(pheno_train, 
                file = paste0(mydir, "pheno_pheno", 
                                p,
                                ".txt"),
                quote = F, 
                row.names = F, 
                col.names = F
                )
    mydir <- paste0(comp_str, "02_pheno/03_test_c/")
    if (!dir.exists(mydir)){dir.create(mydir, recursive = TRUE)} 
    write.table(pheno_test, 
                file = paste0(mydir, "pheno_pheno", 
                                p, 
                                ".txt"),
                quote = F, 
                row.names = F, 
                col.names = F
                )
    }
}

pheno_uni_c <- c("SH", "PLT", "BMD", "BMR", "BMI", 
                 "RBC", "AM", "RDW", "EOS", "WBC", 
                 "FVC", "FEV", "FFR", "WC", "HC",
                 "WHR", "SBP", "BW", "BFP", "TFP", 
                 "SU", "TC", "HDL", "LDL", "TG")



##########################
# Binary trait
covVar_all <- as.matrix(cbind(sqc_i[, c(26:35)], # first ten PCs
                              ifelse(sqc_i$Inferred.Gender == "F", 0, 1)))
for (n_fold in n_folds){
  for (p in 1:25) {
    idx_tot <- setdiff(sqc_sub$idx, na_list_b[[p]])
    cat("pheno", p, " includes ", length(idx_tot), " samples.\n")
    # Step1: validation & verification set
    ## get index
    set.seed(pheno_seed_str[p])
    idx_val_ver <- sample(x = idx_tot, size = floor(0.2 * length(idx_tot)), replace = FALSE)
    cat("pheno", p, "include val_ver ", length(idx_val_ver), " samples.\n")
    idx_val <- sample(idx_val_ver, size = floor(length(idx_val_ver) / 2), replace = FALSE)
    idx_ver <- setdiff(idx_val_ver, idx_val)
    ## assemble a tibble with idx_ver & the corresponding trait values
    ver_tib <- tibble::tibble(FID = idx_ver, IID = idx_ver) %>%
      dplyr::arrange(FID) %>%
      dplyr::mutate(true_pheno = pheno_b_all[match(IID, sqc_i$idx), p])
    comp_str <- paste0("~/research/ukb-intervals/study_nfolds/", n_fold, "-fold/")
    mydir_ver <- paste0(comp_str, 
            "03_subsample/binary/pheno", 
            p,
            "/verif/")
    if (!dir.exists(mydir_ver)){dir.create(mydir_ver, recursive = TRUE)}
    fn <- paste0(mydir_ver, "03_idx_pheno.txt") 
    ver_tib %>%
      vroom::vroom_write(file = fn, col_names = FALSE)
  ## pheno data
    pheno_b_all_val <- pheno_b_all[match(idx_val, sqc_i$idx), p]
    pheno_b_all_ver <- pheno_b_all[match(idx_ver, sqc_i$idx), p]

    
    ## covariates data
    if(!p %in% c(1, 6, 21)){
      ## validation
      covVar_val <- data.frame(y = pheno_b_all_val, 
                              covVar_all[match(idx_val, sqc_i$idx), ])
      ## Verification
      covVar_ver <- data.frame(y = pheno_b_all_ver, 
                              covVar_all[match(idx_ver, sqc_i$idx), ])
      # linear model
      coefMat_val <- lm(y~., data = covVar_val) %>% coef()
      pred_val <- cbind(1, covVar_all[match(idx_val, sqc_i$idx), ]) %*% coefMat_val
      coefMat_ver <-  lm(y~., data = covVar_ver) %>% coef()
      pred_ver <- cbind(1, covVar_all[match(idx_ver, sqc_i$idx), ]) %*% coefMat_ver
    } else {
      ## validation
      covVar_val <- data.frame(y = pheno_b_all_val, 
                              covVar_all[match(idx_val, sqc_i$idx), -11])
      # linear model
      coefMat_val <- lm(y~., data = covVar_val) %>% coef()
      pred_val <- cbind(1, covVar_all[match(idx_val, sqc_i$idx), -11]) %*% coefMat_val
      covVar_ver <- data.frame(y = pheno_b_all_ver, 
                              covVar_all[match(idx_ver, sqc_i$idx), -11])
      # linear model
      coefMat_ver <- lm(y~., data = covVar_ver) %>% coef()
      pred_ver <- cbind(1, covVar_all[match(idx_ver, sqc_i$idx), -11]) %*% coefMat_ver
    }
    ## output
    mydir_val <- paste0(comp_str, "03_subsample/binary/pheno", p,
                              "/val/")
    if (!dir.exists(mydir_val)){dir.create(mydir_val, recursive = TRUE)}
    write.table(cbind(idx_val, idx_val), 
                file = paste0(mydir_val, "01_idx.txt"),
                col.names = F, row.names = F, quote = F)
    write.table(pheno_b_all_val, 
                file = paste0(mydir_val, "02_pheno_b.txt"), 
                col.names = F, row.names = F, quote = F)
 
    write.table(pred_val, 
                file = paste0(mydir_val, "03_cov_eff.txt"), 
                row.names = F, col.names = F, quote = F)
    write.table(cbind(idx_ver, idx_ver), 
                file = paste0(mydir_ver, "01_idx.txt"),
                col.names = F, row.names = F, quote = F)
    write.table(pheno_b_all_ver, 
                file = paste0(mydir_ver,
                              "02_pheno_b.txt"), 
                col.names = F, row.names = F, quote = F)
    
    write.table(pred_ver, 
                file = paste0(mydir_ver, "03_cov_eff.txt"), 
                row.names = F, col.names = F, quote = F)
    # Step2: cross validation set
    idx_cv <- setdiff(idx_tot, idx_val_ver)
    set.seed(pheno_seed_str[p]+cross_seed)
    if (n_fold == 5){
          split_indices <- splitTools::partition(idx_cv, p = c(fold1 = 1 / n_fold, 
                                                                fold2 = 1 / n_fold, 
                                                                fold3 = 1 / n_fold, 
                                                                fold4 = 1 / n_fold, 
                                                                fold5 = 1 / n_fold)
          )
    }
    if (n_fold == 10){
            split_indices <- splitTools::partition(idx_cv, p = c(fold1 = 1 / n_fold, 
                                                                fold2 = 1 / n_fold, 
                                                                fold3 = 1 / n_fold, 
                                                                fold4 = 1 / n_fold, 
                                                                fold5 = 1 / n_fold,
                                                                fold6 = 1 / n_fold, 
                                                                fold7 = 1 / n_fold, 
                                                                fold8 = 1 / n_fold, 
                                                                fold9 = 1 / n_fold, 
                                                                fold10 = 1 / n_fold
                                                                )
                                                                )
    }
    if (n_fold == 20){
            split_indices <- splitTools::partition(idx_cv, p = c(fold1 = 1 / n_fold, 
                                                                fold2 = 1 / n_fold, 
                                                                fold3 = 1 / n_fold, 
                                                                fold4 = 1 / n_fold, 
                                                                fold5 = 1 / n_fold,
                                                                fold6 = 1 / n_fold, 
                                                                fold7 = 1 / n_fold, 
                                                                fold8 = 1 / n_fold, 
                                                                fold9 = 1 / n_fold, 
                                                                fold10 = 1 / n_fold,
                                                                fold11 = 1 / n_fold, 
                                                                fold12 = 1 / n_fold, 
                                                                fold13 = 1 / n_fold, 
                                                                fold14 = 1 / n_fold, 
                                                                fold15 = 1 / n_fold,
                                                                fold16 = 1 / n_fold, 
                                                                fold17 = 1 / n_fold, 
                                                                fold18 = 1 / n_fold, 
                                                                fold19 = 1 / n_fold, 
                                                                fold20 = 1 / n_fold
                                                                )
                                                                )
    }    
    pheno_train <- pheno_test <- coveff <- coveff_glm <- matrix(NA, nrow(pheno_b_all), n_fold)
    for(cross in 1:n_fold){
      idx_test <- idx_cv[split_indices[[cross]]]
      idx_train <- setdiff(idx_cv, idx_test)
      
      ## train set
      pheno_train[, cross] <- pheno_b_all[, p]
      pheno_train[!sqc_i$idx %in% idx_train, cross] <- NA
      # covariates
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
      pheno_test[, cross] <- pheno_b_all[, p]
      pheno_test[!sqc_i$idx %in% idx_test, cross] <- NA
      # covariates
      if(!p %in% c(1, 6, 21)){
        coveff[sqc_i$idx %in% idx_test, cross] <- cbind(1, covVar_all[match(idx_test, sqc_i$idx), ]) %*% coefMat_train
        coveff_glm[sqc_i$idx %in% idx_test, cross] <- cbind(1, covVar_all[match(idx_test, sqc_i$idx), ]) %*% coefMat_train_glm
      } else {
        coveff[sqc_i$idx %in% idx_test, cross] <- cbind(1, covVar_all[match(idx_test, sqc_i$idx), -11]) %*% coefMat_train
        coveff_glm[sqc_i$idx %in% idx_test, cross] <- cbind(1, covVar_all[match(idx_test, sqc_i$idx), -11]) %*% coefMat_train_glm
      }
      mydir <- paste0(comp_str, "02_pheno/04_test_idx_b/")
      if (!dir.exists(mydir)){dir.create(mydir, recursive = TRUE)}
      write.table(cbind(idx_test, idx_test),
                  file = paste0(mydir, "idx_pheno", p, "_cross", cross, ".txt"),
                  quote = F, row.names = F, col.names = F)
    }
    mydir <- paste0(comp_str, "02_pheno/05_train_b/")
    if (!dir.exists(mydir)){dir.create(mydir, recursive = TRUE)}
    write.table(pheno_train, file = paste0(mydir, "pheno_pheno", p, ".txt"),
                quote = F, row.names = F, col.names = F)
    mydir <- paste0(comp_str, "02_pheno/06_test_b/")
    if (!dir.exists(mydir)){dir.create(mydir, recursive = TRUE)}
    write.table(pheno_test, file = paste0(mydir, "pheno_pheno", p, ".txt"),
                quote = F, row.names = F, col.names = F)
    write.table(coveff, file = paste0(mydir, "coveff_pheno", p, ".txt"),
                quote = F, row.names = F, col.names = F)
    write.table(coveff_glm, file = paste0(mydir, "coveff_pheno", p, "_glm.txt"),
                quote = F, row.names = F, col.names = F)
    
  }
}
pheno_uni_b <- c("PRCA", "TA", "T2D", "CAD", "RA", 
                 "BRCA", "AS", "MP", "MDD", "SS", 
                 "QU", "HT", "FFI", "DFI", "OA", 
                 "AN", "GO", "SAF", "HA", "TE", 
                 "T1B", "VMS", "MY", "SN", "ES")

