# GOAL: sample 1000 subjects and output the ids to a text file

## read fam file for all subjects, post-qc

fam <- genio::read_fam("~/research/ukb-intervals/dat/plink_files/ukb/chr1.fam")
ss <- sample(fam$id, size = 10000)
write.table(x = ss, file = "~/research/ukb-intervals/dat/idx_sample1.txt")

