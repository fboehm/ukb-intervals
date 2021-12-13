# GOAL: sample 10000 subjects and output new fam files


## read fam file for all subjects, post-qc

fam <- readr::read_delim("~/research/ukb-intervals/dat/plink_files/ukb/chr1.fam", col_names = FALSE)
set.seed(2021-12-05)
ss <- sample(1:nrow(fam), size = 10000)
readr::write_delim(x = tibble::as_tibble(fam$X1[ss]), file = "~/research/ukb-intervals/dat/test-subjects-ids.txt", col_names = FALSE)
tr <- fam
tr[(1:nrow(fam) %in% ss), 6:ncol(fam)] <- NA
te <- fam
te[!(1:nrow(fam) %in% ss), 6:ncol(fam)] <- NA

readr::write_delim(x = tr, file = "~/research/ukb-intervals/dat/plink_files/ukb/chr1-training.fam")
readr::write_delim(x = te, file = "~/research/ukb-intervals/dat/plink_files/ukb/chr1-test.fam")

