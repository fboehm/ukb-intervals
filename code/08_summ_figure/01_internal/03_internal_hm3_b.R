rm(list = ls())
library(plyr)
library(reshape2)

comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
method_ord <- c("CT", "DBSLMM", "lassosum",
                "LDpred2-auto","LDpred2-inf", "LDpred2-nosp", "LDpred2-sp", 
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
pheno_f <- factor(pheno_uni, levels = pheno_order)

## percent function
comp_percent <- function(rank_num_dat, dat, pheno_order, method_order){
  
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
  percent2_pheno <- dcast(comp_dat, Traits~label, fun.aggregate=length)
  
  top <- medium <- bottom <- vector("numeric", length(method_order))
  for (m in 1: length(method_order)){
    top[m] <- sum(comp_dat[comp_dat$Method == method_order[m], 7] == "Top")
    cat(method_order[m], "top group: ", sum(comp_dat[comp_dat$Method == method_order[m], 7] == "Top"), "\n")
    medium[m] <- sum(comp_dat[comp_dat$Method == method_order[m], 7] == "Medium")
    bottom[m] <- sum(comp_dat[comp_dat$Method == method_order[m], 7] == "Bottom")
  }
  percent2 <- data.frame(Methods = method_order, 
                         Rank = factor(c(rep("Top", length(method_order)), 
                                         rep("Medium", length(method_order)),
                                         rep("Bottom", length(method_order))),
                                       levels = c("Top", "Medium", "Bottom")),
                         RankVal = c(top, medium, bottom))
  percent2$RankValPerc <- percent2$RankVal/length(pheno_order)
  
  return(list(percent2, percent2_pheno))
}
# auc
## 12 methods
auc_list <- alply(c(1: length(pheno_uni)), 1, function(a){
  load(paste0(comp_str, "06_internal_b/summRes/res_hm3_b_pheno", a, ".RData"))
  load(paste0(comp_str, "06_internal_b/pheno", a, "/bagging/res_mat_hm3.RData"))
  auc_comb <- cbind(res_list[[2]][, -c(2, 10)], auc_mat)
  return(auc_comb)
})
auc_dat <- do.call("rbind", auc_list)
colnames(auc_dat) <- method_ord
auc_dat <- melt(auc_dat, id.vars = "pheno")[, -1]
colnames(auc_dat) <- c("Methods", "auc")
auc_dat <- data.frame(pheno = rep(pheno_f, each = 5), auc_dat)
# save(auc_dat, file = paste0(comp_str, "06_internal_b/summRes/auc_hm3_dat.RData"))
## proportion to the best
auc_mean_list <- llply(auc_list, function(mat) {
  mean_mat <- colMeans(mat)
  res <- data.frame(Methods = factor(method_ord, levels = method_ord),
                    Prop = (mean_mat-0.5)/(max(mean_mat, na.rm = T)-0.5),
                    Mean = mean_mat, 
                    Rank = 14-rank(mean_mat))
  return(res)
})
auc_mean_dat <- do.call("rbind", auc_mean_list)
auc_mean_dat$Traits <- rep(pheno_f, each = length(method_ord))

# dcast(auc_mean_dat[, c(1, 2)], Methods~., function(a) mean(a, na.rm = T))


#######################################################################
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
#######################################################################

## rank data
auc_summ <- llply(auc_list, function(a) colMeans(a)[-13])
auc_rank_num <- ldply(auc_summ, function(a) length(method_ord) - rank(a))
colnames(auc_rank_num) <- c("pheno", method_ord[-13])
auc_rank_num <- melt(auc_rank_num, id.vars = "pheno")[, -1]
auc_rank_num_dat <- data.frame(Traits = pheno_f,
                               Methods = factor(auc_rank_num[, 1],
                                                levels = rev(levels(auc_rank_num[, 1]))),
                               Rank = auc_rank_num[, 2])
auc_rank_num_dat <- auc_rank_num_dat[auc_rank_num_dat$Methods != "PGSagg", ]

## rank percentage
auc_dat <- auc_dat[auc_dat$Methods != "PGSagg", ]
auc_rank_obj <- comp_percent(auc_rank_num_dat, auc_dat, pheno_order, method_ord[-13])
auc_percent2 <- auc_rank_obj[[1]]
auc_percent2_pheno <- auc_rank_obj[[2]]

# auc output
save(auc_mean_dat, file = paste0(comp_str, "06_internal_b/summRes/auc_hm3_mean_dat.RData"))
save(auc_percent2, file = paste0(comp_str, "06_internal_b/summRes/auc_hm3_percent2.RData"))
save(auc_percent2_pheno, file = paste0(comp_str, "06_internal_b/summRes/auc_hm3_percent2_pheno.RData"))
save(auc_rank_num_dat, file = paste0(comp_str, "06_internal_b/summRes/auc_hm3_rank_num_dat.RData"))

# pr2
## 12 methods
pr2_list <- alply(c(1: length(pheno_uni)), 1, function(a){
  load(paste0(comp_str, "06_internal_b/summRes/res_hm3_b_pheno", a, ".RData"))
  load(paste0(comp_str, "06_internal_b/pheno", a, "/bagging/res_mat_hm3.RData"))
  pr2_comb <- cbind(res_list[[1]][, -c(2, 10)], pr2_mat)
  return(pr2_comb)
})
pr2_dat <- do.call("rbind", pr2_list)
colnames(pr2_dat) <- method_ord
pr2_dat <- melt(pr2_dat, id.vars = "pheno")[, -1]
colnames(pr2_dat) <- c("Methods", "pr2")
pr2_dat <- data.frame(pheno =  rep(pheno_f, each = 5), pr2_dat)
save(pr2_dat, file = paste0(comp_str, "06_internal_b/summRes/pr2_hm3_dat.RData"))
## proportion to the best
pr2_mean_list <- llply(pr2_list, function(mat) {
  mean_mat <- colMeans(mat)
  res <- data.frame(factor(method_ord, levels = method_ord),
                    mean_mat/max(mean_mat), 
                    mean_mat)
  return(res)
})
pr2_mean_dat <- do.call("rbind", pr2_mean_list)
colnames(pr2_mean_dat) <- c("Methods", "Prop", "Mean")
dcast(pr2_mean_dat[, c(1, 2)], Methods~., function(a) mean(a, na.rm = T))


# ## rank data
# pr2_summ <- llply(pr2_list, function(a) colMeans(a))
# pr2_rank_num <- ldply(pr2_summ, function(a) 13 - rank(a))
# colnames(pr2_rank_num) <- c("pheno", method_ord)
# pr2_rank_num <- melt(pr2_rank_num, id.vars = "pheno")[, -1]
# pr2_rank_num_dat <- data.frame(Traits = pheno_f,
#                                Methods = factor(pr2_rank_num[, 1],
#                                                 levels = rev(levels(pr2_rank_num[, 1]))),
#                                Rank = pr2_rank_num[, 2])
# ## rank percentage
# pr2_percent2 <- comp_percent(pr2_rank_num_dat, pr2_dat, pheno_order, method_ord)

## rank data
pr2_summ <- llply(pr2_list, function(a) colMeans(a)[-13])
pr2_rank_num <- ldply(pr2_summ, function(a) length(method_ord) - rank(a))
colnames(pr2_rank_num) <- c("pheno", method_ord[-13])
pr2_rank_num <- melt(pr2_rank_num, id.vars = "pheno")[, -1]
pr2_rank_num_dat <- data.frame(Traits = pheno_f,
                               Methods = factor(pr2_rank_num[, 1],
                                                levels = rev(levels(pr2_rank_num[, 1]))),
                               Rank = pr2_rank_num[, 2])
pr2_rank_num_dat <- pr2_rank_num_dat[pr2_rank_num_dat$Methods != "PGSagg", ]
## rank percentage
pr2_dat <- pr2_dat[pr2_dat$Methods != "PGSagg", ]
pr2_rank_obj <- comp_percent(pr2_rank_num_dat, pr2_dat, pheno_order, method_ord[-13])
pr2_percent2 <- pr2_rank_obj[[1]]
pr2_percent2_pheno <- pr2_rank_obj[[2]]


# pr2 output
save(pr2_mean_dat, file = paste0(comp_str, "06_internal_b/summRes/pr2_hm3_mean_dat.RData"))
save(pr2_percent2, file = paste0(comp_str, "06_internal_b/summRes/pr2_hm3_percent2.RData"))
save(pr2_percent2_pheno, file = paste0(comp_str, "06_internal_b/summRes/pr2_hm3_percent2_pheno.RData"))
save(pr2_rank_num_dat, file = paste0(comp_str, "06_internal_b/summRes/pr2_hm3_rank_num_dat.RData"))
