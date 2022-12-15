# we need to do an additional subsetting with plink to ensure that
# we have the same 337129 subjects that Sheng used.
# we'll use the output of this script in a call to plink --keep 

# first, read the file with 337129 ids
library(magrittr)
sfile <- vroom::vroom("~/research/ukb-intervals/plink_file/pheno_list/ukb_sub_info_337129.sample")
sfile %>%
    dplyr::filter(ID_1 != 0) %>%
    dplyr::select(1,2) %>%
    vroom::vroom_write(file = "~/research/ukb-intervals/plink_file/pheno_list/ukb_337129_ids.txt", col_names = FALSE)

