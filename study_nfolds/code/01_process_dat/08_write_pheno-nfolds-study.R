#! /usr/bin/env Rscript
rm(list = ls())
library(parallel)
library(bigreadr)


n_folds <- c(5, 10, 20)
trait_types <- c("continuous", "binary_adj")
comp_str <- "~/research/ukb-intervals/study_nfolds/"
pred_str <- "~/research/ukb-intervals/"
## output to fam file for cross validation 
pheno_num <- 25
for (trait_type in trait_types){
    for (n_fold in n_folds){
        pheno <- matrix(NA, nrow = 337129, ncol = pheno_num * n_fold)
        for (p in 1: pheno_num){
            begin <- (p - 1) * n_fold + 1
            end <- (p - 1) * n_fold + n_fold
            if (trait_type == "continuous") {
                pheno_str <- paste0(comp_str, n_fold, "-fold/", "02_pheno/02_train_c/pheno_pheno", p, ".txt")
            } 
            if (trait_type == "binary") {
                pheno_str <- paste0(comp_str, n_fold, "-fold/", "02_pheno/05_train_b/pheno_pheno", p, ".txt")
            }
            if (trait_type == "binary_adj") {
                pheno_str <- paste0(comp_str, n_fold, "-fold/", "02_pheno/05_train_b/pheno_pheno", p, "_adj.txt")
            }
            pheno[, c(begin:end)] <- as.matrix(fread2(pheno_str))
        }
        fam <- readr::read_table(paste0(pred_str, "plink_file/ukb/binary/chr22.fam"), col_names = FALSE)
        fam_pheno <- cbind(fam[, c(1:5)], pheno) # pheno
        mydir <- paste0(comp_str, n_fold, "-fold/",
                                        "plink_file/ukb/", 
                                        trait_type, 
                                        "/")
        if (!dir.exists(mydir)){dir.create(mydir, recursive = TRUE)}
        write.table(fam_pheno, 
                    file = paste0(mydir, "chr1.fam"),
                    col.names = F, 
                    row.names = F, 
                    quote = F
                    )
    }
}