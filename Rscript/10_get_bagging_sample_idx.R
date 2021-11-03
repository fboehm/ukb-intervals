library(bigreadr)
## all 1000 subsamples
all_female_idx <- read.table("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/01_idx_female.txt")
all_male_idx <- read.table("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/01_idx_male.txt")
all_idx <- read.table("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/01_idx.txt")
all_pheno_c <- fread2("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/02_pheno_c.txt")
all_pheno_c <- cbind(all_idx[, 1], all_pheno_c)

## val and test idx
val_female_idx <- all_female_idx[1: 250, ]
val_male_idx <- all_male_idx[1: 250, ]
test_female_idx <- all_male_idx[251: 500, ]
test_male_idx <- all_male_idx[251: 500, ]
val_idx <- rbind(val_female_idx, val_male_idx)
test_idx <- rbind(val_female_idx, val_male_idx)
val_idx <- val_idx[order(val_idx[, 1]), ]
test_idx <- test_idx[order(test_idx[, 1]), ]

## output idx and pheno
write.table(val_idx, file = "/net/mulan/disk2/yasheng/comparisonProject/03_subsample/bagging/01_val_idx.txt", 
            row.names = F, col.names = F, quote = F)
write.table(test_idx, file = "/net/mulan/disk2/yasheng/comparisonProject/03_subsample/bagging/02_test_idx.txt", 
            row.names = F, col.names = F, quote = F)
write.table(all_pheno_c[all_pheno_c[, 1] %in% val_idx[, 1], -1], 
            file = "/net/mulan/disk2/yasheng/comparisonProject/03_subsample/bagging/03_val_pheno_c.txt", 
            row.names = F, col.names = F, quote = F)
write.table(all_pheno_c[all_pheno_c[, 1] %in% test_idx[, 1], -1], 
            file = "/net/mulan/disk2/yasheng/comparisonProject/03_subsample/bagging/04_test_pheno_c.txt", 
            row.names = F, col.names = F, quote = F)