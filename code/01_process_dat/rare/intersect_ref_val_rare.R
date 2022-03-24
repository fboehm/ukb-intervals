library(bigreadr)
library(plyr)
compstr = "/net/mulan/disk2/yasheng/comparisonProject/"
# compstr2 = "/net/mulan/home/yasheng/comparisonProject/"

dat = "binary"
# val snp
val_snp_list <- alply(c(1: 25), 1, function(p){
  snp <- fread2(paste0(compstr, "03_subsample/", dat, "/pheno", p, 
                       "/val/rare/impute/merge.bim"))[, 2]
  return(snp)
})
inter_val <- Reduce("intersect", val_snp_list)

# ref snp
ref_snp <- fread2(paste0(compstr, "04_reference/hm3_rare/geno/merge_imp.bim"))[, 2]

# summary snp
# foreach
library(foreach)
library(doParallel)

comp_str <- "/net/mulan/disk2/yasheng/comparisonProject/"
# attach number of cores 
cores <- detectCores(logical=F)
cl <- makeCluster(cores)
registerDoParallel(cl, cores=10)

#do parallel
sum_snp_list <- foreach(p=c(1:25)) %dopar%
  { 
    library(bigreadr)
    snp_list <- list()
    for (cross in 1:5) {
      snp_list[[cross]] <- fread2(paste0(compstr, "06_internal_b/pheno", p, 
                                         "/output/summary_hm3_rare_cross",cross,".assoc.txt"))[, 2]
    }
    snp <- Reduce("intersect", snp_list)
    return(snp)
  }
# close the parallel function
stopImplicitCluster()
stopCluster(cl)

# sum_snp_list <- alply(c(1: 25), 1, function(p){
#   snp_list <- list()
#   for (cross in 1:5) {
#   snp_list[[cross]] <- fread2(paste0(compstr, "06_internal_b/pheno", p, 
#                        "/output/summary_hm3_rare_cross",cross,".assoc.txt"))[, 2]
#   }
#   snp <- Reduce("intersect", snp_list)
#   return(snp)
# })

inter_sum <- Reduce("intersect", sum_snp_list)

# intersect
inter_val_ref_sum <- Reduce("intersect",
                            list(ref_snp, 
                                 inter_val,
                                 inter_sum))

inter_str <- paste0(compstr, "04_reference/hm3_rare/geno/merge_intersect_",dat,".txt")
write.table(inter_val_ref_sum, file = inter_str, 
            row.names = F, col.names = F, quote = F)


ref_cmd <- paste0("plink-1.9 --bfile ", compstr, "04_reference/hm3_rare/geno/merge_imp --extract ", 
                  inter_str, " --make-bed --out ", compstr, "04_reference/hm3_rare/geno_inter/merge_b")
system(ref_cmd)

library(parallel)
val <- mclapply(c(1: 25), function(p){
  val_cmd <- paste0("plink-1.9 --silent --bfile ", compstr, "03_subsample/", dat, "/pheno", p, 
                    "/val/rare/impute/merge --extract ", inter_str, " --make-bed --out ", 
                    compstr, "03_subsample/", dat, "/pheno", p, 
                    "/val/rare/impute_inter/merge")
  system(val_cmd)
}, mc.cores = 25)