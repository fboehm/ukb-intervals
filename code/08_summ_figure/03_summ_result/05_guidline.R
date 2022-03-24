rm(list = ls())
# functions
comp_percent <- function(rank_num_dat, dat, pheno_order, method_ord){
  require(plyr)
  library(dplyr)
  
  # rank_num_dat = r2_rank_num_dat
  # dat = r2_dat
  # pheno_order = pheno_order_c_low
  # method_ord = method_ord_hm3
  
  comp_top <- comp_bottom <- list()
  
  for (p in 1: length(pheno_order)) {
    sub_rank <- subset(rank_num_dat, rank_num_dat$Traits==pheno_order[p])
    sub <- subset(dat, dat$pheno==pheno_order[p])
    top_m <- as.character(sub_rank[sub_rank$Rank==1,2])
    bottom_m<- as.character(sub_rank[sub_rank$Rank==length(method_ord),2])
    
    comp_top[[p]] <- aaply(method_ord, 1, function(a){
      top <- sub[sub$Methods == top_m, 3]
      comp <- sub[sub$Methods == a, 3]
      # t_val <- wilcox.test(top, comp, paired = TRUE)$p.value
      t_val <- t.test(top, comp, paired = TRUE)$p.value
      return(t_val)
    })
    comp_bottom[[p]]<- aaply(method_ord, 1, function(a){
      bottom <- sub[sub$Methods == bottom_m, 3]
      comp <- sub[sub$Methods == a, 3]
      # t_val <- wilcox.test(bottom, comp, paired = TRUE)$p.value
      t_val <- t.test(bottom, comp, paired = TRUE)$p.value
      return(t_val)
    })
  }
  comp_dat <- data.frame(Traits = rep(pheno_order, each = length(method_ord)), 
                         Methods = method_ord, 
                         top_p = unlist(comp_top), 
                         bottom_p = unlist(comp_bottom))
  comp_dat$top_p <- ifelse(is.na(comp_dat$top_p), 1, comp_dat$top_p)
  comp_dat$bottom_p <- ifelse(is.na(comp_dat$bottom_p), 1, comp_dat$bottom_p)
  comp_dat$top_label <- ifelse((comp_dat$top_p > 0.05/(length(method_ord)-1) & comp_dat$bottom_p < 0.05/(length(method_ord)-1)) | comp_dat$top_p == 1, 
                               1, 0)
  comp_dat$buttom_label <- ifelse((comp_dat$bottom_p > 0.05/(length(method_ord)-1) & comp_dat$top_p < 0.05/(length(method_ord)-1)) | comp_dat$bottom_p==1, 
                                  1, 0)
  comp_dat$label <- NA
  comp_dat$label <- ifelse(comp_dat$top_label == 1, "Top", NA)
  comp_dat$label <- ifelse(comp_dat$buttom_label == 1, "Bottom", comp_dat$label)
  comp_dat$label <- ifelse(comp_dat$buttom_label == 0 & comp_dat$top_label == 0, 
                           "Medium", comp_dat$label)
  
  top <- medium <- bottom <- vector("numeric", length(method_ord))
  for (m in 1: length(method_ord)){
    top[m] <- sum(comp_dat[comp_dat$Method == method_ord[m], 7] == "Top")/length(pheno_order)
    cat(method_ord[m], "top group: ", sum(comp_dat[comp_dat$Method == method_ord[m], 7] == "Top"), "\n")
    medium[m] <- sum(comp_dat[comp_dat$Method == method_ord[m], 7] == "Medium")/length(pheno_order)
    bottom[m] <- sum(comp_dat[comp_dat$Method == method_ord[m], 7] == "Bottom")/length(pheno_order)
  }
  percent2 <- data.frame(Methods = method_ord, 
                         Rank = factor(c(rep("Top", length(method_ord)), 
                                         rep("Medium", length(method_ord)),
                                         rep("Bottom", length(method_ord))),
                                       levels = c("Top", "Medium", "Bottom")),
                         RankVal = c(top, medium, bottom))
  return(percent2)
}



# parameters
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
method_ord_hm3 <- c("CT", "DBSLMM", "lassosum",
                    "LDpred2-auto","LDpred2-inf", "LDpred2-nosp", "LDpred2-sp", 
                    "NPS", "PRS-CS", "SbayesR", "SBLUP", "SCT")
method_ord_ukb <- c("CT", "DBSLMM", "lassosum",
                    "LDpred2-auto","LDpred2-inf", "LDpred2-nosp", "LDpred2-sp", 
                    "SBLUP", "SCT")

# continuous
load(paste0(comp_str, "05_internal_c/summRes/r2_hm3_percent2.RData"))
r2_rank_method <- 13-rank(r2_percent2[r2_percent2[, 2] == "Top", 3])

# binary
load(paste0(comp_str, "06_internal_b/summRes/auc_hm3_percent2.RData"))
auc_rank_method <- 13-rank(auc_percent2[auc_percent2[, 2] == "Top", 3])

# heritability
## herit 
herit_c <- read.csv(paste0(comp_str, "code/08_summ_figure/01_internal/hm3_c.csv"), 
                    header = T)
herit_b <- read.csv(paste0(comp_str, "code/08_summ_figure/01_internal/hm3_b.csv"), 
                    header = T)
pheno_order_c_low <- herit_c[herit_c[, 2] <= median(herit_c[, 2]), 1]
pheno_order_c_high <- herit_c[herit_c[, 2] > median(herit_c[, 2]), 1]
pheno_order_b_low <- herit_b[herit_b[, 2] <= median(herit_b[, 2]), 1]
pheno_order_b_high <- herit_b[herit_b[, 2] > median(herit_b[, 2]), 1]

## xx
load(paste0(comp_str, "05_internal_c/summRes/r2_hm3_dat.RData"))
load(paste0(comp_str, "05_internal_c/summRes/r2_hm3_rank_num_dat.RData"))
r2_dat <- r2_dat[r2_dat[, 2] %in% method_ord_hm3, ]
r2_percent_c_low <- comp_percent(r2_rank_num_dat, r2_dat, pheno_order_c_low, method_ord_hm3)
r2_percent_c_high <- comp_percent(r2_rank_num_dat, r2_dat, pheno_order_c_high, method_ord_hm3)
load(paste0(comp_str, "06_internal_b/summRes/auc_hm3_dat.RData"))
load(paste0(comp_str, "06_internal_b/summRes/auc_hm3_rank_num_dat.RData"))
auc_percent_c_low <- comp_percent(auc_rank_num_dat, auc_dat, pheno_order_b_low, method_ord_hm3)
auc_percent_c_high <- comp_percent(auc_rank_num_dat, auc_dat, pheno_order_b_high, method_ord_hm3)
herit_low_method <- 13-rank(rowMeans(cbind(auc_percent_c_low[auc_percent_c_low[, 2] == "Top", 3], r2_percent_c_low[r2_percent_c_low[, 2] == "Top", 3])))
herit_high_method <- 13-rank(rowMeans(cbind(auc_percent_c_high[auc_percent_c_high[, 2] == "Top", 3], r2_percent_c_high[r2_percent_c_high[, 2] == "Top", 3])))

# dense SNP set
load(paste0(comp_str, "05_internal_c/summRes/r2_ukb_percent2.RData"))
r2_rank_dense_method <- length(method_ord_ukb) + 1 - rank(r2_percent2[r2_percent2[, 2] == "Top", 3]+r2_percent2[r2_percent2[, 2] == "Medium", 3])

# cross-ancestry validation
## AFR
load(paste0(comp_str, "07_external_c/01_AFR/04_summ_res/ext_r2_hm3_c_percent2.RData"))
load(paste0(comp_str, "07_external_c/01_AFR/04_summ_res/ext_auc_hm3_b_percent2.RData"))
r2_percent_AFR_c <- rank(ext_r2_percent2[ext_r2_percent2[, 2] == "Top", 3])
auc_percent_AFR_b <- rank(ext_auc_percent2[ext_auc_percent2[, 2] == "Top", 3])
## EAS
load(paste0(comp_str, "07_external_c/03_EAS/04_summ_res/ext_r2_hm3_c_percent2_BBJ.RData"))
r2_percent_EAS_c_BBJ <- rank(ext_r2_percent2[ext_r2_percent2[, 2] == "Top", 3])
load(paste0(comp_str, "07_external_c/03_EAS/04_summ_res/ext_r2_hm3_c_percent2_UKB.RData"))
r2_percent_EAS_c_UKB <- rank(ext_r2_percent2[ext_r2_percent2[, 2] == "Top", 3])
load(paste0(comp_str, "07_external_c/03_EAS/04_summ_res/ext_auc_hm3_b_percent2.RData"))
auc_percent_EAS_b <- rank(ext_auc_percent2[ext_auc_percent2[, 2] == "Top", 3])
rank_cross_ancestry_method <- data.frame(r2_percent_AFR_c, auc_percent_AFR_b, 
                                         r2_percent_EAS_c_BBJ, r2_percent_EAS_c_UKB, 
                                         auc_percent_EAS_b)
rank_cross_ancestry_method <- 13 - rank(rowMeans(as.matrix(rank_cross_ancestry_method)))

# cross study
load(paste0(comp_str, "07_external_c/02_EUR/04_summ_res/ext_r2_hm3_c_percent2.RData"))
r2_rank_cross_study_method <- 13 - rank(ext_r2_percent2[ext_r2_percent2[, 2] == "Top", 3])

# speed and memory non dense
load(paste0(comp_str, "code/08_summ_figure/mat_record_hm3.RData"))
time_mat_mean[8, 1] <- time_mat_mean[8, 1]*4
speed_rank_nondense <- rank(time_mat_mean[, 1])
memory_rank_nondense <- rank(memory_mat_mean[, 1])

# speed and memory dense
load(paste0(comp_str, "code/08_summ_figure/mat_record_ukb.RData"))
speed_rank_dense <- rank(time_mat_mean[c(1:7), 1])
memory_rank_dense <- rank(memory_mat_mean[c(1:7), 1])

# summarize the result
summ_dat <- data.frame(Methods = method_ord_hm3, 
                       Continuous = r2_rank_method, 
                       Binary = auc_rank_method, 
                       High = herit_high_method, 
                       Low = herit_low_method, 
                       Dense = c(r2_rank_dense_method[1:7], NA, NA, NA, r2_rank_dense_method[8:9]),
                       Cross_ancestry = rank_cross_ancestry_method, 
                       Cross_study = r2_rank_cross_study_method, 
                       Speed_nondense = c(speed_rank_nondense[1:6], speed_rank_nondense[6], speed_rank_nondense[7:10], 
                                          speed_rank_nondense[1]),
                       Memory_nondense = c(memory_rank_nondense[1:6], memory_rank_nondense[6], memory_rank_nondense[7:10], 
                                           memory_rank_nondense[1]), 
                       Speed_dense = c(speed_rank_dense[1:6], speed_rank_dense[6], rep(NA, 3), speed_rank_dense[c(7, 1)]),
                       Memory_dense = c(memory_rank_dense[1:6], memory_rank_dense[6], rep(NA, 3), memory_rank_dense[c(7, 1)])
                       )

label <- c("Top", "Medium", "Bottom")
rank_dat <- data.frame(Methods = method_ord_hm3, 
                       Continuous = ifelse(summ_dat$Continuous <= 3.5, "Top", ifelse(summ_dat$Continuous < 9.5, "Medium", "Bottom")), 
                       Binary = ifelse(summ_dat$Binary <= 3.5, "Top", ifelse(summ_dat$Binary < 9.5, "Medium", "Bottom")), 
                       High = ifelse(summ_dat$High <= 3.5, "Top", ifelse(summ_dat$High < 9.5, "Medium", "Bottom")), 
                       Low = ifelse(summ_dat$Low <= 3.5, "Top", ifelse(summ_dat$Low < 9.5, "Medium", "Bottom")), 
                       Dense = ifelse(summ_dat$Dense <= 2.5, "Top", ifelse(summ_dat$Dense < 7.5, "Medium", "Bottom")), 
                       Cross_ancestry = ifelse(summ_dat$Cross_ancestry <= 3.5, "Top", ifelse(summ_dat$Cross_ancestry < 9.5, "Medium", "Bottom")), 
                       Cross_study = ifelse(summ_dat$Cross_study <= 3.5, "Top", ifelse(summ_dat$Cross_study < 9.5, "Medium", "Bottom")), 
                       Speed_nondense = ifelse(summ_dat$Speed_nondense <= 3.5, "Top", ifelse(summ_dat$Speed_nondense < 9.5, "Medium", "Bottom")), 
                       Memory_nondense = ifelse(summ_dat$Speed_nondense <= 3.5, "Top", ifelse(summ_dat$Speed_nondense < 9.5, "Medium", "Bottom")), 
                       Speed_dense = ifelse(summ_dat$Speed_dense <= 2.5, "Top", ifelse(summ_dat$Speed_dense < 6.5, "Medium", "Bottom")), 
                       Memory_dense = ifelse(summ_dat$Speed_dense <= 2.5, "Top", ifelse(summ_dat$Speed_dense < 6.5, "Medium", "Bottom"))
                       )

rank_dat_l <- reshape2::melt(rank_dat, id = "Methods")
quality <- c("Quantitative Trait", "Binary Trait", 
             "High Heritability Trait", "Low Heritability Trait", 
             "Dense SNP Set", "Cross-ancestry Validation", 
             "Cross-study Validation", 
             "CPU Time (Non-dense Set)", "Memory Usage (Non-dense Set)", 
             "CPU Time (Dense Set)", "Memory Usage (Dense Set)")
rank_dat_l[, 1] <- factor(rank_dat_l[, 1], levels = rev(method_ord_hm3))
rank_dat_l[, 2] <- factor(rep(quality, each = 12), levels = quality)
rank_dat_l[, 3] <- factor(rank_dat_l[, 3], levels = label)
colnames(rank_dat_l) <- c("Methods", "Index", "Rank")
rank_dat_l

save(rank_dat_l, file = paste0(comp_str,
                              "code/08_summ_figure/guideline_rank_dat.RData"))
