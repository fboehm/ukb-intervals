# Goal is to prepare chromosome-specific extract files for use when
# creating plink binary files with only the HapMap3 snps.

# I downloaded the HapMap3 data on Dec 16, 2022
library(magrittr)

mapfile <- vroom::vroom("~/research/ukb-intervals/hapmap3/hapmap3_r1_b36_fwd.CEU.qc.poly.recode.map", col_names = FALSE)

for (chr in 1:22){
    outfile <- paste0("~/research/ukb-intervals/hapmap3/CEU_snp_ids_chr", chr)
    mapfile %>%
        dplyr::filter(X1 == chr) %>%
        dplyr::select(2) %>%
        vroom::vroom_write(outfile, col_names = FALSE)
}
# https://zzz.bwh.harvard.edu/plink/dataman.shtml#extract

