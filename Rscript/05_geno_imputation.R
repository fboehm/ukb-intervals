#ukb imputation
rm(list=ls())
gc()
library(bigsnpr)
library(optparse)

## Input parameters
args_list = list(
  make_option("--chr", type="numeric", default=NULL,
              help="INPUT: chromosome", metavar="character"), 
  make_option("--p", type="numeric", default=NULL,
              help="INPUT: phenotype", metavar="character"),
  make_option("--dat", type="character", default="NULL",
              help="INPUT: binary or continuous", metavar="character")
)

opt_parser <- OptionParser(option_list=args_list)
opt <- parse_args(opt_parser)

# parameters
chr <- opt$chr
p <- opt$p
dat <- opt$dat

geno_path <- paste0("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/",
                    dat, "/pheno", p, "/hm3/")


if(file.exists(paste0(geno_path,"geno/chr",chr, ".bk")) == F){
  val_bed <- snp_readBed(paste0(geno_path,"geno/chr",chr, ".bed"))
}
val_bed <- snp_attach(paste0(geno_path,"geno/chr",chr, ".rds"))
val_bed$genotypes <- snp_fastImputeSimple(val_bed$genotypes)

if(file.exists(paste0(geno_path, "impute/chr",chr, ".bed"))){
  system(paste0("rm ", geno_path,"impute/chr",chr, ".bed"))
  system(paste0("rm ", geno_path,"impute/chr",chr, ".bim"))
  system(paste0("rm ", geno_path,"impute/chr",chr, ".fam"))
}
snp_writeBed(val_bed, bedfile = paste0(geno_path, "impute/chr",chr, ".bed"))
system(paste0("rm ", geno_path,"geno/chr",chr, ".bk"))
system(paste0("rm ", geno_path,"geno/chr",chr, ".rds"))
