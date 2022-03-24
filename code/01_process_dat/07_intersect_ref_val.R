library(bigreadr)
library(plyr)
library(foreach)
library(doParallel)
compstr = "/net/mulan/disk2/yasheng/comparisonProject/"
# compstr2 = "/net/mulan/home/yasheng/comparisonProject/"

dat = "continuous"

# summary snp
# foreach
cores <- detectCores(logical=F)
cl <- makeCluster(cores)
registerDoParallel(cl, cores=10)

sum_snp_list <- foreach(p=c(1:25)) %dopar%
  { 
    library(bigreadr)
    snp_list <- list()
    for (cross in 1:5) {
      snp_list[[cross]] <- fread2(paste0(compstr, "05_internal_c/pheno", p, 
                                         "/output/summary_ukb_cross",cross,".assoc.txt"))[, 2]
    }
    snp <- Reduce("intersect", snp_list)
    return(snp)
  }
# close the parallel function
stopImplicitCluster()
stopCluster(cl)
inter_sum <- Reduce("intersect", sum_snp_list)

# validation snp 
val_snp_list <- alply(c(1: 25), 1, function(p){
  snp <- fread2(paste0(compstr, "03_subsample/", dat, "/pheno", p, 
                       "/val_ukb/impute/merge.bim"))[, 2]
  return(snp)
})
inter_val <- Reduce("intersect", val_snp_list)

# reference snp
ref_snp <- fread2(paste0(compstr, "04_reference/ukb/geno/merge_imp.bim"))[, 2]

# intersect snp
inter_val_ref_sum <- Reduce("intersect", list(ref_snp, 
                                              inter_val, 
                                              inter_sum))
inter_str <- paste0(compstr, "04_reference/ukb/geno/merge_intersect_continuous.txt")
write.table(inter_val_ref, file = inter_str, 
            row.names = F, col.names = F, quote = F)

##
ref_cmd <- paste0("plink-1.9 --bfile ", compstr, "04_reference/ukb/geno/merge_imp --extract ", 
                  inter_str, " --make-bed --out ", compstr, "04_reference/ukb/geno_inter/merge_c")
system(ref_cmd)

library(parallel)
val <- mclapply(c(1: 25), function(p){
  val_cmd <- paste0("plink-1.9 --silent --bfile ", compstr, "03_subsample/", dat, "/pheno", p, 
                    "/val_ukb/impute/merge --extract ", inter_str, " --make-bed --out ", 
                    compstr, "03_subsample/", dat, "/pheno", p, 
                    "/val_ukb/impute_inter/merge")
  system(val_cmd)
}, mc.cores = 25)