rm(list = ls())
library(plyr)
library(reshape2)

# phenotype and method string
comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
method_ord <- c("CT", "DBSLMM", "lassosum",
                "LDpred2-auto", "LDpred2-inf", "LDpred2-nosp", "LDpred2-sp", 
                "NPS", 
                # "PRS-CS", 
                "SbayesR", "SBLUP", "SCT", "PGSagg")
pheno_uni <- c("SH", "PLT", "BMD", 
               "BMI", "RBC", "AM_RG1", "AM_RG2", 
               "EOS", "WBC", "FVC", "FEV", 
               "FFR", "WC", "HC", "WHR", 
               "BW",  "TC", "HDL_GLGC", "HDL_meta", 
               "HDL_NMR", "LDL_GLGC", "LDL_meta", "LDL_NMR",
               "TG_GLGC", "TG_NMR")
pheno_order <- c("SH", "BMD", "HDL_GLGC", "HDL_meta", 
                 "HDL_NMR", "PLT", "BMI", 
                 "AM_RG1", "AM_RG2",  "HC", "RBC", 
                 "WC",  "EOS", "TG_GLGC", "TG_NMR", 
                 "WBC", "FVC", "FFR", "FEV", 
                 "WHR", "TC", "LDL_GLGC", "LDL_meta", 
                 "LDL_NMR", "BW")

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


# phenotype number
pheno_f <- factor(pheno_uni, levels = pheno_order)
ext_pheno <- read.table(paste0(comp_str, "code/04_external_EUR/pheno.txt"))[, 1]
ext_dat <- read.table(paste0(comp_str, "code/04_external_EUR/dat.txt"))[, 1]
iter_str <- c(1: 28)[-c(1, 4, 6)]

# ext r2 dat
ext_r2_list <- alply(iter_str, 1, function(iter){
  dat_str <- paste0(comp_str, "07_external_c/02_EUR/04_summ_res/res_hm3_c_pheno",
                    ext_pheno[iter], "_dat", ext_dat[iter], ".RData")
  load(dat_str)
  return(r2_mat)
})
ext_r2_dat <- do.call("rbind", ext_r2_list)
colnames(ext_r2_dat) <- method_ord
ext_r2_dat <- melt(ext_r2_dat, id.vars = "pheno")[, -1]
colnames(ext_r2_dat) <- c("Methods", "ext_r2")
ext_r2_dat <- data.frame(pheno = rep(pheno_f, each = 5), ext_r2_dat
                         # , E_r2 = E_r2
)

## proportion to the best
ext_r2_mean_list <- llply(ext_r2_list, function(mat) {
  mean_mat <- apply(mat, 2, function(a) median(a, na.rm = T))
  res <- data.frame(Methods = factor(method_ord, levels = method_ord),
                    Prop = mean_mat/max(mean_mat), 
                    Mean = mean_mat, 
                    Rank = 14 - rank(mean_mat))
  return(res)
})
ext_r2_mean_dat <- do.call("rbind", ext_r2_mean_list)
dcast(ext_r2_mean_dat[, c(1, 2)], Methods~., mean)

## rank data
ext_r2_summ <- llply(ext_r2_list, function(a) colMeans(a[, -13]))
ext_r2_rank_num <- ldply(ext_r2_summ, function(a) length(method_ord) - rank(a))
colnames(ext_r2_rank_num) <- c("pheno", method_ord[-13])
ext_r2_rank_num <- melt(ext_r2_rank_num, id.vars = "pheno")[, -1]
ext_r2_rank_num_dat <- data.frame(Traits = pheno_f,
                                  Methods = factor(ext_r2_rank_num[, 1],
                                                   levels = rev(levels(ext_r2_rank_num[, 1]))),
                                  Rank = ext_r2_rank_num[, 2])

## rank percentage
z_dat <- data.frame(pheno = ext_r2_dat$pheno, 
                    Methods = ext_r2_dat$Methods, 
                    z=0.5*log((1+sqrt(ext_r2_dat$ext_r2))/(1-sqrt(ext_r2_dat$ext_r2))))
z_dat <- z_dat[z_dat$Methods != "PGSagg", ]
ext_r2_rank_obj <- comp_percent(ext_r2_rank_num_dat, z_dat, pheno_order, method_ord[-13])
ext_r2_percent2 <- ext_r2_rank_obj[[1]]
ext_r2_percent2_pheno <- ext_r2_rank_obj[[2]]

# internal output
save(ext_r2_mean_dat, file = paste0(comp_str, 
                                    "07_external_c/02_EUR/04_summ_res/ext_r2_hm3_c_mean_dat.RData"))
save(ext_r2_dat, file = paste0(comp_str, 
                               "07_external_c/02_EUR/04_summ_res/ext_r2_hm3_c_dat.RData"))
save(ext_r2_percent2, file = paste0(comp_str, 
                                    "07_external_c/02_EUR/04_summ_res/ext_r2_hm3_c_percent2.RData"))
save(ext_r2_percent2_pheno, file = paste0(comp_str, 
                                          "07_external_c/02_EUR/04_summ_res/ext_r2_hm3_c_percent2_pheno.RData"))

