rm(list=ls())
tm_str <- "/net/mulan/disk2/yasheng/comparisonProject/01_time_file/"

to_min <- function(time_str){
  time_ss <- stringr::str_split(time_str, ":", simplify = T)
  time_ss <- as.numeric(time_ss)
  if (length(time_ss) == 3){
    minute_res <- time_ss[1]*60+time_ss[2]+time_ss[3]/60
  }
  if (length(time_ss) == 2){
    minute_res <- time_ss[1]+time_ss[2]/60
  }
  return(minute_res)
}

to_record1 <- function(tm_path, thread){
  time_vec <- memory_vec <- vector("numeric", length = 22)
  for(chr in 1: 22){
    tm_chr_path <- paste0(tm_path, "_chr", chr, "_thread", thread, ".tm")
    tm_chr_file <- read.delim(tm_chr_path, skip = 1)
    time_vec[chr] <- to_min(stringr::str_split(tm_chr_file[4,2], ": ", simplify = T)[2])
    memory_vec[chr] <- as.numeric(stringr::str_split(tm_chr_file[9,2], ": ", simplify = T)[2])/1024/1024
  }

  res <- c(sum(time_vec, na.rm = T), max(memory_vec, na.rm= T))
  return(res)
}

to_record2 <- function(tm_path, thread){
  time_vec <- memory_vec <- vector("numeric", length = 22)
  for(chr in 1: 22){
    tm_chr_path <- paste0(tm_path, "_chr", chr, "_thread", thread, ".tm")
    tm_chr_file <- try(read.delim(tm_chr_path), silent = T)
    if (inherits(tm_chr_file, "try-error") == F){
      time_vec[chr] <- to_min(stringr::str_split(tm_chr_file[4,2], ": ", simplify = T)[2])
      memory_vec[chr] <- as.numeric(stringr::str_split(tm_chr_file[9,2], ": ", simplify = T)[2])/1024/1024
    } else {
      cat("chr: ", chr, "is failed!\n")
      time_vec[chr] <- memory_vec[chr] <- NA
    }

  }
  
  res <- c(sum(time_vec, na.rm = T), max(memory_vec, na.rm= T))
  return(res)
}
# to_record <- function(tm_path, thread){
#   time_vec <- memory_vec <- vector("numeric", length = 22)
#   for(chr in 1: 22){
#     tm_chr_path <- paste0(tm_path, "_chr", chr, "_thread", thread, ".tm")
#     tm_chr_file <- try(read.delim(tm_chr_path), silent = T)
#     if(inherits(tm_chr_file, "try-error")){
#       if (chr == 6){
#         time_vec[chr] <- 24*60
#         memory_vec[chr] <- NA
#       }else{
#         tm_chr_file <- read.delim(tm_chr_path, skip = 1)
#         time_vec[chr] <- to_min(stringr::str_split(tm_chr_file[4,2], ": ", simplify = T)[2])
#         memory_vec[chr] <- as.numeric(stringr::str_split(tm_chr_file[9,2], ": ", simplify = T)[2])/1024/1024
#       }
#     } else {
#       time_vec[chr] <- to_min(stringr::str_split(tm_chr_file[4,2], ": ", simplify = T)[2])
#       memory_vec[chr] <- as.numeric(stringr::str_split(tm_chr_file[9,2], ": ", simplify = T)[2])/1024/1024
#     }
#   }
#   res <- c(sum(time_vec, na.rm = T), max(memory_vec, na.rm= T))
#   return(res)
# }


dat_s<-"hm3"
thread_str <- c(1, 5)
time_mat_mean <- memory_mat_mean <- matrix(NA, 10, 2)
for (tt in 1: 2){
  thread <- thread_str[tt]
  # dat_str <- paste0("_",dat_s,c("_c_pheno1", "_b_pheno9"))
  dat_str <- paste0("_",dat_s,c("_continuous_pheno1", "_binary_pheno9"))
  method_ord <- c("CT/SCT", 
                  "DBSLMM", 
                  "lassosum", 
                  "LDpred2-auto", "LDpred2-inf", "LDpred2", 
                  "NPS", "PRS-CS", 
                  "SbayesR", "SBLUP")
  method_label <- c("01_SCT_CT", 
                    "06_DBSLMM", 
                    "03_lassosum", 
                    "02_LDpred2-auto", "02_LDpred2-inf", "02_LDpred2-m", 
                    "09_nps", "08_PRScs", 
                    "07_SbayesR", "05_sblup")

  time_mat <- memory_mat <- matrix(NA, 
                                   length(method_label)*length(dat_str),
                                   5)
  for (dd in 1:length(dat_str)){
    dat <- dat_str[dd]
    if(thread == 1 & grepl("hm3", dat)){
      m_str <- c(1: 10)
      m_len <- 10

    }
    if(thread == 5 & grepl("hm3", dat)){
      m_str <- c(1, 2, 3, 4, 5, 6, 10)
      m_len <- 10

    }
    if(grepl("ukb", dat)){
      method_ord <- c("CT/SCT", "DBSLMM", "lassosum", 
                      "LDpred2-auto", "LDpred2-inf", "LDpred2", "SBLUP")
      method_label <- c("01_SCT_CT", "06_DBSLMM", "03_lassosum", 
                        "02_LDpred2-auto", "02_LDpred2-inf", "02_LDpred2-m", "05_sblup")
      m_str <- c(1:7)
      m_len <- 7
    }
    # 1: length(m_str)
    for (m in 1: length(m_str)){
      method <- method_label[m_str[m]]
      row_num <- m_str[m] + m_len*(dd-1)
      for (cross in 1:5){
        cat(method, cross, "\n")
        if(method %in% c("01_SCT_CT", "06_DBSLMM", "03_lassosum", "09_nps")){ 
          tm_path <- paste0(tm_str, method_label[m_str[m]], dat, "_cross", cross, "_thread", thread, ".tm")
          tm_file <- try(read.delim(tm_path), silent=T)
          time_mat[row_num, cross] <- to_min(stringr::str_split(tm_file[4,2], ": ", simplify = T)[2])
          if (method == "01_SCT_CT" & tt == 2){
            memory_mat[row_num, cross] <- as.numeric(stringr::str_split(tm_file[9,2], ": ", simplify = T)[2])/1024/1024*10          
          } else {
            memory_mat[row_num, cross] <- as.numeric(stringr::str_split(tm_file[9,2], ": ", simplify = T)[2])/1024/1024
          }
        
        }
        if(method %in% c("02_LDpred2-auto", "02_LDpred2-inf")){
          tm_path <- paste0(tm_str, method_label[m_str[m]], dat, "_cross", cross)
          time_mat[row_num, cross] <- to_record1(tm_path, thread)[1]
          memory_mat[row_num, cross] <- to_record1(tm_path, thread)[2]
        }
        if(method %in% c("02_LDpred2-m", "07_SbayesR", "05_sblup")){
          tm_path <- paste0(tm_str, method_label[m_str[m]], dat, "_cross", cross)
          time_mat[row_num, cross] <- to_record2(tm_path, thread)[1]
          memory_mat[row_num, cross] <- to_record2(tm_path, thread)[2]
        }
        if(method == "08_PRScs"){
          tm_path <- paste0(tm_str, method_label[m_str[m]], dat, "_cross", cross)
          time_mat[row_num, cross] <- to_record2(tm_path, thread)[1]*4
          memory_mat[row_num, cross] <- to_record2(tm_path, thread)[2]
        }
      }
    }
  }
  time_mat <- time_mat[1:(length(method_ord)*length(dat_str)),]
  time_mat_mean_t <- rowMeans(time_mat, na.rm = T)
  for (m in 1: length(m_str)){
    time_mat_mean[m_str[m], tt] <- mean(time_mat_mean_t[c(m_str[m], m_str[m]+m_len)], na.rm = T)
    cat("Thread: ", thread_str[tt], ", ", method_ord[m_str[m]], " time :",
        round(time_mat_mean[m_str[m], tt], 2), "minutes\n")
  }
  memory_mat <- memory_mat[1:(length(method_ord)*length(dat_str)),]
  memory_mat_mean_t <- rowMeans(memory_mat, na.rm = T)
  for (m in 1: length(m_str)){
    memory_mat_mean[m_str[m], tt] <- mean(memory_mat_mean_t[c(m_str[m], m_str[m]+m_len)], na.rm = T)
    cat("Thread: ", thread_str[tt], ", ", method_ord[m_str[m]], " memory :",
        round(memory_mat_mean[m_str[m], tt], 2), "Gb\n")
  }
  time_dat <- data.frame(Methods = rep(method_ord, 2),
                         time_mat)
  colnames(time_dat)[-1] <- paste0("cross", c(1:5))
  time_dat <- reshape2::melt(time_dat, by = "Methods")
  time_dat_l <- data.frame(phenoCode = rep(c("c", "b"), each = length(method_ord)),
                           thread = thread,
                           Methods = time_dat$Methods,
                           cross = time_dat$variable,
                           time = time_dat$value)
  memory_dat <- data.frame(Methods = rep(method_ord, 2),
                           memory_mat)
  colnames(memory_dat)[-1] <- paste0("cross", c(1:5))
  memory_dat <- reshape2::melt(memory_dat, by = "Methods")
  memory_dat_l <- data.frame(phenoCode = rep(c("c", "b"), each = length(method_ord)),
                             thread = thread,
                             Methods = memory_dat$Methods,
                             cross = memory_dat$variable,
                             memory = memory_dat$value)
  
  save(time_dat_l, memory_dat_l,
       file = paste0("/net/mulan/disk2/yasheng/comparisonProject/code/08_summ_figure/l_record_",dat_s,"_thread",thread,".RData"))
}

save(time_mat_mean, memory_mat_mean,
     file = paste0("/net/mulan/disk2/yasheng/comparisonProject/code/08_summ_figure/mat_record_",dat_s,".RData"))

