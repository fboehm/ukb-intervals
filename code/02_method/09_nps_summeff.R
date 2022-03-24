rm(list=ls())
library(bigreadr)

comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
pred_str <- "/net/mulan/home/yasheng/comparisonProject/"
# win_str <- c(0, 500, 1000, 1500)
win_str <- c(0, 250, 500, 750)
# res <- parallel::mclapply(c(21:25), function(p) {
  p=9
  cross=1
  # for (cross in 1: 5){
    cat("p: ", p, "cross: ", cross, "\n")
    mod_dir <- paste0(pred_str, "06_internal_b/pheno", p, 
                      "/nps/tmp", cross)
    
    for (chr in 1: 22){
      
      snp_info_str <- paste0(comp_str, "03_subsample/binary/pheno", p, 
                             "/val/impute_inter/chr", chr, ".bim")
      snp_info <- fread2(snp_info_str)
      
      tail_mat <- matrix(NA, nrow(snp_info), 4)
      for (winshift in 1: length(win_str)){
        tail_str <- paste0(mod_dir, "/val.win_", win_str[winshift], 
                           ".adjbetahat_tail.chrom", chr, ".txt")
        tail_mat[, winshift] <- fread2(tail_str)[, 1]
      }
      pg_mat <- matrix(NA, nrow(snp_info), 4)
      for (winshift in 1: length(win_str)){
        pg_str <- paste0(mod_dir, "/val.win_", win_str[winshift], 
                         ".adjbetahat_pg.chrom", chr, ".txt")
        pg_mat[, winshift] <- fread2(tail_str)[, 1]
      }
      
      eff_mat <- rowSums(pg_mat) + rowSums(tail_mat)
      
      eff_dat <- data.frame(snp_info[, 2], snp_info[, 5], 
                            eff_mat)
      cat(summary(eff_dat[, 3]), "\n")
      # write.table(eff_dat, file = paste0(comp_str, "06_internal_b/pheno", p, 
      #                                    "/nps/est/esteff_cross", cross, "_chr", 
      #                                    chr, ".txt"), 
      #             col.names = F, row.names = F, quote = F)
    }
  }
}, mc.cores = 5)


rm(list=ls())
library(bigreadr)
summ_func <- function(p){
  for (cross in 1: 3){
    cat("p: ", p, "cross: ", cross, "\n")
    
    mod_dir <- paste0(pred_str, "05_internal_c/pheno", p, 
                      "/nps/tmp", cross)
    
    for (chr in 1: 22){
      
      snp_info_str <- paste0(comp_str, "03_subsample/continuous/pheno", p, 
                             "/val/impute_inter/chr", chr, ".bim")
      snp_info <- fread2(snp_info_str)
      
      tail_mat <- matrix(NA, nrow(snp_info), 4)
      for (winshift in 1: length(win_str)){
        tail_str <- paste0(mod_dir, "/val.win_", win_str[winshift], 
                           ".adjbetahat_tail.chrom", chr, ".txt")
        tail_mat[, winshift] <- fread2(tail_str)[, 1]
      }
      pg_mat <- matrix(NA, nrow(snp_info), 4)
      for (winshift in 1: length(win_str)){
        pg_str <- paste0(mod_dir, "/val.win_", win_str[winshift], 
                         ".adjbetahat_pg.chrom", chr, ".txt")
        pg_mat[, winshift] <- fread2(tail_str)[, 1]
      }
      
      eff_mat <- rowSums(pg_mat) + rowSums(tail_mat)
      
      eff_dat <- data.frame(snp_info[, 2], snp_info[, 5], 
                            eff_mat)
      write.table(eff_dat, file = paste0(comp_str, "05_internal_c/pheno", p, 
                                         "/nps/est/esteff_cross", cross, "_chr", 
                                         chr, ".txt"), 
                  col.names = F, row.names = F, quote = F)
    }
  }
  return(0)
}
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
pred_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
# win_str <- c(0, 500, 1000, 1500)
win_str <- c(0, 250, 500, 750)
res <- parallel::mclapply(5, function(p) {
  summ <- try(summ_func(p), silent = T)
  if (inherits(summ, "try-error")){
    return(0)
  }
  
}, mc.cores = 1)

