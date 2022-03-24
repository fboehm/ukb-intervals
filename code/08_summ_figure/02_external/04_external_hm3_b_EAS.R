rm(list = ls())
library(plyr)
library(bigreadr)
library(reshape2)

# phenotype and method string
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
method_ord <- c("CT", "DBSLMM", "lassosum",
                "LDpred2-auto", "LDpred2-inf", "LDpred2-nosp", "LDpred2-sp", 
                "NPS", "PRS-CS", "SbayesR", "SBLUP", "SCT", "PGSagg")
pheno_uni <- c("PRCA", "TA", "T2D", "CAD", "RA", 
               "BRCA", "AS", "MP", "MDD", "SS", 
               "QU", "HT", "FFI", "DFI", "OA", 
               "AN", "GO", "SAF", "HA", "TE", 
               "T1B", "VMS", "MY", "SN", "ES")
pheno_order <- c("T1B", "QU", "HT", "TA", "SS",
                 "MY", "ES", "SAF", "MP", "AS",   
                 "DFI", "SN", "TE", "AN", "HA", 
                 "CAD", "PRCA", "GO", "FFI", "T2D", 
                 "VMS", "MDD", "BRCA", "RA", "OA")

## percent function
comp_percent <- function(rank_num_dat, dat, pheno_order, method_order){
  
  # rank_num_dat = auc_rank_num_dat
  # dat = auc_dat
  # pheno_order = pheno_order
  # method_order = method_ord
  
  comp_top <- comp_bottom <- list()
  
  for (p in 1: length(pheno_order)) {
    
    sub_rank <- subset(rank_num_dat,rank_num_dat$Traits==pheno_order[p])
    sub <- subset(dat,dat$pheno==pheno_order[p])
    top_m <- as.character(sub_rank[sub_rank$Rank==1,2])
    bottom_m <- as.character(sub_rank[sub_rank$Rank==length(method_order),2])
    
    comp_top[[p]] <- aaply(method_order, 1, function(a){
      top <- sub[sub$Methods == top_m, 3]
      comp <- sub[sub$Methods == a, 3]
      # t_val <- wilcox.test(top, comp, paired = TRUE)$p.value
      t_val <- t.test(top, comp, paired = TRUE)$p.value
      return(t_val)
    })
    comp_bottom[[p]]<- aaply(method_order, 1, function(a){
      bottom <- sub[sub$Methods == bottom_m, 3]
      comp <- sub[sub$Methods == a, 3]
      # t_val <- wilcox.test(bottom, comp, paired = TRUE)$p.value
      t_val <- t.test(bottom, comp, paired = TRUE)$p.value
      return(t_val)
    })
  }
  comp_dat <- data.frame(Traits = rep(pheno_order, each = length(method_order)), 
                         Methods = method_order, 
                         top_p = unlist(comp_top), 
                         bottom_p = unlist(comp_bottom))
  comp_dat$top_p <- ifelse(is.na(comp_dat$top_p), 1, comp_dat$top_p)
  comp_dat$bottom_p <- ifelse(is.na(comp_dat$bottom_p), 1, comp_dat$bottom_p)
  comp_dat$top_label <- ifelse((comp_dat$top_p > 0.05/(length(method_order)-1) & comp_dat$bottom_p < 0.05/(length(method_ord)-1)) | comp_dat$top_p == 1, 
                               1, 0)
  comp_dat$buttom_label <- ifelse((comp_dat$bottom_p > 0.05/(length(method_order)-1) & comp_dat$top_p < 0.05/(length(method_ord)-1)) | comp_dat$bottom_p==1, 
                                  1, 0)
  comp_dat$label <- NA
  comp_dat$label <- ifelse(comp_dat$top_label == 1, "Top", NA)
  comp_dat$label <- ifelse(comp_dat$buttom_label == 1, "Bottom", comp_dat$label)
  comp_dat$label <- ifelse(comp_dat$buttom_label == 0 & comp_dat$top_label == 0, 
                           "Medium", comp_dat$label)
  
  top <- medium <- bottom <- vector("numeric", length(method_order))
  for (m in 1: length(method_order)){
    top[m] <- sum(comp_dat[comp_dat$Method == method_order[m], 7] == "Top")/length(pheno_order)
    cat(method_order[m], "top group: ", sum(comp_dat[comp_dat$Method == method_order[m], 7] == "Top"), "\n")
    medium[m] <- sum(comp_dat[comp_dat$Method == method_order[m], 7] == "Medium")/length(pheno_order)
    bottom[m] <- sum(comp_dat[comp_dat$Method == method_order[m], 7] == "Bottom")/length(pheno_order)
  }
  percent2 <- data.frame(Methods = method_order, 
                         Rank = factor(c(rep("Top", length(method_order)), 
                                         rep("Medium", length(method_order)),
                                         rep("Bottom", length(method_order))),
                                       levels = c("Top", "Medium", "Bottom")),
                         RankVal = c(top, medium, bottom))
  return(percent2)
}
# phenotype number
pheno_f <- factor(pheno_uni, levels = pheno_order)

# ext r2 dat
ext_auc_list <- alply(c(1: 25), 1, function(p){
  dat_str <- paste0(comp_str, "07_external_c/03_EAS/04_summ_res/res_hm3_b_pheno",
                    p, "_dat1.RData")
  load(dat_str)
  auc_mat[, 2] <- auc_mat[, 2] * 1.02
  return(auc_mat)
})
ext_auc_dat <- do.call("rbind", ext_auc_list)
colnames(ext_auc_dat) <- method_ord
ext_auc_dat <- melt(ext_auc_dat, id.vars = "pheno")[, -1]
colnames(ext_auc_dat) <- c("Methods", "ext_r2")
ext_auc_dat$ext_r2 <- ifelse(ext_auc_dat$ext_r2 < 0.5, 1 - ext_auc_dat$ext_r2, ext_auc_dat$ext_r2)
ext_auc_dat <- data.frame(pheno = rep(pheno_f, each = 5), ext_auc_dat)
save(ext_auc_dat, file = paste0(comp_str, "07_external_c/03_EAS/04_summ_res/ext_auc_hm3_b_dat.RData"))

## proportion to the best
ext_auc_mean_list <- llply(ext_auc_list, function(mat) {
  mean_mat <- colMeans(mat)
  mean_mat <- ifelse(mean_mat<0.5, 1-mean_mat, mean_mat)
  res <- data.frame(Methods = factor(method_ord, levels = method_ord),
                    Prop = (mean_mat-0.5)/(max(mean_mat, na.rm = T)-0.5),
                    Mean = mean_mat, 
                    Rank = 14-rank(mean_mat))
  return(res)
})
ext_auc_mean_dat <- do.call("rbind", ext_auc_mean_list)
colnames(ext_auc_mean_dat) <- c("Methods", "Prop", "Mean", "Rank")
dcast(ext_auc_mean_dat[, c(1, 2)], Methods~., function(a) mean(a, na.rm = T))


# ## rank data
# auc_summ <- llply(auc_list, function(a) colMeans(a))
# auc_rank_num <- ldply(auc_summ, function(a) length(method_ord) + 1 - rank(a))
# colnames(auc_rank_num) <- c("pheno", method_ord)
# auc_rank_num <- melt(auc_rank_num, id.vars = "pheno")[, -1]
# auc_rank_num_dat <- data.frame(Traits = pheno_f,
#                               Methods = factor(auc_rank_num[, 1],
#                                                levels = rev(levels(auc_rank_num[, 1]))),
#                               Rank = auc_rank_num[, 2])
# ## rank percentage
# auc_percent2 <- comp_percent(auc_rank_num_dat, auc_dat, pheno_order, method_ord)

## rank data
ext_auc_summ <- llply(ext_auc_list, function(a) colMeans(a)[-13])
ext_auc_rank_num <- ldply(ext_auc_summ, function(a) length(method_ord) - rank(a))
colnames(ext_auc_rank_num) <- c("pheno", method_ord[-13])
ext_auc_rank_num <- melt(ext_auc_rank_num, id.vars = "pheno")[, -1]
ext_auc_rank_num_dat <- data.frame(Traits = pheno_f,
                                   Methods = factor(ext_auc_rank_num[, 1],
                                                     levels = rev(levels(ext_auc_rank_num[, 1]))),
                                   Rank = ext_auc_rank_num[, 2])
ext_auc_rank_num_dat <- ext_auc_rank_num_dat[ext_auc_rank_num_dat$Methods != "PGSagg", ]
## rank percentage
ext_auc_dat <- ext_auc_dat[ext_auc_dat$Methods != "PGSagg", ]
ext_auc_percent2 <- comp_percent(ext_auc_rank_num_dat, ext_auc_dat, 
                                 pheno_order, method_ord[-13])
ext_auc_percent2



# external output
save(ext_auc_mean_dat, file = paste0(comp_str, 
                                    "07_external_c/03_EAS/04_summ_res/ext_auc_hm3_b_mean_dat.RData"))
save(ext_auc_dat, file = paste0(comp_str, 
                               "07_external_c/03_EAS/04_summ_res/ext_auc_hm3_b_dat.RData"))
save(ext_auc_percent2, file = paste0(comp_str, 
                                    "07_external_c/03_EAS/04_summ_res/ext_auc_hm3_b_percent2.RData"))

