rm(list = ls())
library(plyr)
library(reshape2)

comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
method_ord <- c("CT", "DBSLMM", "lassosum",
                "LDpred2-auto","LDpred2-inf", "LDpred2-nosp", "LDpred2-sp",
                "NPS", "PRS-CS", "SbayesR", "SBLUP", "SCT", "PGSagg")
pheno_uni <- c("SH", "PLT", "BMD", "BMR", "BMI", 
               "RBC", "AM", "RDW", "EOS", "WBC", 
               "FVC", "FEV", "FFR", "WC", "HC",
               "WHR", "SBP", "BW", "BFP", "TFP", 
               "SU", "TC", "HDL", "LDL", "TG")
pheno_order <- c("SH", "BMD", "HDL", "BMR", "PLT",  
                 "BMI", "BFP", "AM", "HC", "RBC",
                 "TFP", "RDW", "WC", "EOS", "TG",
                 "WBC", "FVC", "FFR", "FEV", "WHR",
                 "SBP", "TC", "LDL", "BW", "SU")
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

## ldsc
# ldsc_tot <- vector()
# for (chr in 1: 22){
#   ldsc_str <- paste0("/net/mulan/disk2/yasheng/comparisonProject/04_reference/hm3/ldsc/", chr, ".l2.ldscore.gz")
#   ldsc_chr <- bigreadr::fread2(ldsc_str, select=4)[, 1]
#   ldsc_tot <- c(ldsc_tot, ldsc_chr)
# }
# ldsc_mean <- mean(ldsc_tot)
ldsc_mean <- 23.77407

#########################################################
## herit
E_r2 <- vector()
min_ref <- vector("numeric", length(pheno_uni))
max_ref <- vector("numeric", length(pheno_uni))
N_dat <- read.table(paste0(comp_str, "02_pheno/sample_size_c.txt"))
for (p in 1: length(pheno_uni)){
  E_r2_p <- vector("numeric", 5)
  for (cross in 1:5){

    herit_str <- paste0(comp_str, "05_internal_c/pheno",
                        p, "/herit/h2_hm3_cross", cross, ".log")
    herit_file <- read.delim(herit_str)[, 1]
    herit_dat <- as.character(herit_file)[24]
    herit <- as.numeric(strsplit(strsplit(herit_dat, ": ")[[1]][2], " \\(")[[1]][1])
    M_dat <- as.character(herit_file)[22]
    M <- as.numeric(strsplit(strsplit(M_dat, ", ")[[1]][2], " ")[[1]][1]) / ldsc_mean
    N <- N_dat[c((cross-1)*p+cross), 1]
    E_r2_p[cross] <- herit/(1 + M/(N*herit))
  }
  E_r2_pp <- rep(E_r2_p, length(method_ord))
  min_ref[p] <- min(E_r2_p)
  max_ref[p] <- max(E_r2_p)
  E_r2 <- c(E_r2, E_r2_pp)
}
#########################################################

# r2
## 12 methods
r2_list <- alply(c(1: length(pheno_uni)), 1, function(a){
  load(paste0(comp_str, "05_internal_c/summRes/res_hm3_c_pheno", a, ".RData"))
  load(paste0(comp_str, "05_internal_c/pheno", a, "/bagging/res_mat_hm3.RData"))
  r2_comb <- cbind(res_list[[1]][, -c(2, 10)], r2_mat)
  return(r2_comb)
})
r2_dat <- do.call("rbind", r2_list)
colnames(r2_dat) <- method_ord
r2_dat <- melt(r2_dat, id.vars = "pheno")[, -1]
colnames(r2_dat) <- c("Methods", "r2")
r2_dat <- data.frame(pheno = rep(pheno_f, each = 5), 
                     r2_dat, 
                     E_r2 = E_r2)
# save(r2_dat, file = paste0(comp_str, "05_internal_c/summRes/r2_hm3_dat.RData"))

min_dat <- data.frame(pheno = pheno_f, min_line = min_ref)
max_dat <- data.frame(pheno = pheno_f, max_line = max_ref)
## proportion to the best
r2_mean_list <- llply(r2_list, function(mat) {
  mean_mat <- colMeans(mat)
  res <- data.frame(Methods = factor(method_ord, levels = method_ord),
                    Prop = mean_mat/max(mean_mat), 
                    Mean = mean_mat, 
                    Rank = 14-rank(mean_mat))
  return(res)
})
r2_mean_dat <- do.call("rbind", r2_mean_list)
r2_mean_dat$Traits <- rep(pheno_f, each = length(method_ord))
dcast(r2_mean_dat[, c(1, 2)], Methods~., mean)

###################################################
# ## rank data
# r2_summ <- llply(r2_list, function(a) colMeans(a))
# r2_rank_num <- ldply(r2_summ, function(a) length(method_ord) + 1 - rank(a))
# colnames(r2_rank_num) <- c("pheno", method_ord)
# r2_rank_num <- melt(r2_rank_num, id.vars = "pheno")[, -1]
# r2_rank_num_dat <- data.frame(Traits = pheno_f,
#                               Methods = factor(r2_rank_num[, 1],
#                                                levels = rev(levels(r2_rank_num[, 1]))),
#                               Rank = r2_rank_num[, 2])
# ## rank percentage
# z_dat <- data.frame(pheno = r2_dat$pheno,
#                     Methods = r2_dat$Methods,
#                     z=0.5*log((1+sqrt(r2_dat$r2))/(1-sqrt(r2_dat$r2))))
# r2_percent2 <- comp_percent(r2_rank_num_dat, z_dat, pheno_order, method_ord)
###################################################

## rank data
r2_summ <- llply(r2_list, function(a) colMeans(a[, -13]))
r2_rank_num <- ldply(r2_summ, function(a) length(method_ord) - rank(a))
colnames(r2_rank_num) <- c("pheno", method_ord[-13])
r2_rank_num <- melt(r2_rank_num, id.vars = "pheno")[, -1]
r2_rank_num_dat <- data.frame(Traits = pheno_f,
                              Methods = factor(r2_rank_num[, 1],
                                               levels = rev(levels(r2_rank_num[, 1]))),
                              Rank = r2_rank_num[, 2])
r2_rank_num_dat <- r2_rank_num_dat[r2_rank_num_dat$Methods != "PGSagg", ]

## rank percentage
z_dat <- data.frame(pheno = r2_dat$pheno, 
                    Methods = r2_dat$Methods, 
                    z=0.5*log((1+sqrt(r2_dat$r2))/(1-sqrt(r2_dat$r2))))
z_dat <- z_dat[z_dat$Methods != "PGSagg", ]
r2_rank_obj <- comp_percent(r2_rank_num_dat, z_dat, pheno_order, method_ord[-13])
r2_percent2 <- r2_rank_obj[[1]]
r2_percent2_pheno <- r2_rank_obj[[2]]

# r2 output
save(r2_mean_dat, file = paste0(comp_str, "05_internal_c/summRes/r2_hm3_mean_dat.RData"))
save(r2_percent2, file = paste0(comp_str, "05_internal_c/summRes/r2_hm3_percent2.RData"))
save(r2_percent2_pheno, file = paste0(comp_str, "05_internal_c/summRes/r2_hm3_percent2_pheno.RData"))
save(min_dat, file = paste0(comp_str, "05_internal_c/summRes/min_hm3_dat.RData"))
save(max_dat, file = paste0(comp_str, "05_internal_c/summRes/max_hm3_dat.RData"))
save(r2_rank_num_dat, file = paste0(comp_str, "05_internal_c/summRes/r2_hm3_rank_num_dat.RData"))




# mse
## 12 methods
mse_list <- alply(c(1: length(pheno_uni)), 1, function(a){
  load(paste0(comp_str, "05_internal_c/summRes/res_hm3_c_pheno", a, ".RData"))
  load(paste0(comp_str, "05_internal_c/pheno", a, "/bagging/res_mat_hm3.RData"))
  mse_comb <- cbind(res_list[[2]][, -c(2, 10)], mse_mat)
  return(mse_comb)
})
mse_dat <- do.call("rbind", mse_list)
colnames(mse_dat) <- method_ord
mse_dat <- melt(mse_dat, id.vars = "pheno")[, -1]
colnames(mse_dat) <- c("Methods", "mse")
mse_dat <- data.frame(pheno = rep(pheno_f, each = 5), mse_dat)
save(mse_dat, file = paste0(comp_str, "05_internal_c/summRes/mse_hm3_dat.RData"))
## proportion to the best
mse_mean_list <- llply(c(1:25), function(p) {
  sd_vec <- laply(c(1:5), function(cross) {
    test_pheno <- bigreadr::fread2(paste0(comp_str, "02_pheno/03_test_c/pheno_pheno", 
                                          p, ".txt"), select = cross)[, 1]
    test_pheno_na <- test_pheno[!is.na(test_pheno)]
    return(sd(test_pheno_na))
  })
  mean_mat <- mse_list[[p]]-sd_vec
  best_idx <- which.min(colMeans(mse_list[[p]]))
  res <- data.frame(factor(method_ord, levels = method_ord),
                    colMeans(mean_mat/mean_mat[, best_idx]), 
                    colMeans(mean_mat))
  return(res)
})
mse_mean_dat <- do.call("rbind", mse_mean_list)
colnames(mse_mean_dat) <- c("Methods", "Prop", "Mean")
dcast(mse_mean_dat[, c(1, 2)], Methods~., mean)

# ## rank data
# mse_summ <- llply(mse_list, function(a) colMeans(a))
# mse_rank_num <- ldply(mse_summ, function(a) rank(a))
# colnames(mse_rank_num) <- c("pheno", method_ord)
# mse_rank_num <- melt(mse_rank_num, id.vars = "pheno")[, -1]
# mse_rank_num_dat <- data.frame(Traits = pheno_f,
#                                Methods = factor(mse_rank_num[, 1],
#                                                 levels = rev(levels(mse_rank_num[, 1]))),
#                                Rank = mse_rank_num[, 2])
# ## rank percentage
# mse_percent2 <- comp_percent(mse_rank_num_dat, mse_dat, pheno_order, method_ord)
## rank data
mse_summ <- llply(mse_list, function(a) colMeans(a[, -13]))
mse_rank_num <- ldply(mse_summ, function(a) rank(a))
colnames(mse_rank_num) <- c("pheno", method_ord[-13])
mse_rank_num <- melt(mse_rank_num, id.vars = "pheno")[, -1]
mse_rank_num_dat <- data.frame(Traits = pheno_f,
                               Methods = factor(mse_rank_num[, 1],
                                                levels = rev(levels(mse_rank_num[, 1]))),
                               Rank = mse_rank_num[, 2])
mse_rank_num_dat <- mse_rank_num_dat[mse_rank_num_dat$Methods != "PGSagg", ]
## rank percentage
mse_dat <- mse_dat[mse_dat$Methods != "PGSagg", ]
mse_rank_obj <- comp_percent(mse_rank_num_dat, mse_dat, pheno_order, method_ord[-13])
mse_percent2 <- mse_rank_obj[[1]]
mse_percent2_pheno <- mse_rank_obj[[2]]

# mse output
save(mse_mean_dat, file = paste0(comp_str, "05_internal_c/summRes/mse_hm3_mean_dat.RData"))
save(mse_percent2, file = paste0(comp_str, "05_internal_c/summRes/mse_hm3_percent2.RData"))
save(mse_percent2_pheno, file = paste0(comp_str, "05_internal_c/summRes/mse_hm3_percent2_pheno.RData"))
save(mse_rank_num_dat, file = paste0(comp_str, "05_internal_c/summRes/mse_hm3_rank_num_dat.RData"))

