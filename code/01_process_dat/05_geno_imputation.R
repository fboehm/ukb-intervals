#ukb imputation
rm(list=ls())
gc()
library(bigsnpr)
library(optparse)

## Input parameters
args_list = list(
  make_option("--plinkin", type="numeric", default=NULL,
              help="INPUT: input file", metavar="character"), 
  make_option("--plinkout", type="numeric", default=NULL,
              help="INPUT: output file", metavar="character")
)

opt_parser <- OptionParser(option_list=args_list)
opt <- parse_args(opt_parser)

# parameters
# input <- opt$input
# output <- opt$output


if(file.exists(paste0(opt$plinkin, ".bk")) == F){
  val_bed <- snp_readBed(paste0(opt$plinkin, ".bed"))
}
val_bed <- snp_attach(paste0(opt$plinkin, ".rds"))
val_bed$genotypes <- snp_fastImputeSimple(val_bed$genotypes)

if(file.exists(paste0(opt$plinkout, ".bed"))){
  system(paste0("rm ", opt$plinkout, ".bed"))
  system(paste0("rm ", opt$plinkout, ".bim"))
  system(paste0("rm ", opt$plinkout, ".fam"))
}
snp_writeBed(val_bed, bedfile = paste0(opt$plinkout, ".bed"))
system(paste0("rm ", opt$plinkin, ".bk"))
system(paste0("rm ", opt$plinkin, ".rds"))
