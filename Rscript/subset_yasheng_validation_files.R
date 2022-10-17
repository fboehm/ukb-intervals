# Goal is to read Sheng Yang's validation set membership file and to subset
# it into two subsets: a new validation set and a verification set
# we'll do this for every one of the 50 traits (continuous and binary)
# OUTPUT is two text files per input file

for (phe_num in 1:25){
  ## binary
  dirpath <- paste0("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/binary/pheno", phe_num, "/val_ukb")
  idx_file <- file.path(dirpath, "01_idx.txt")
  ids <- vroom::vroom(file = idx_file, col_names = FALSE)
  # sample 500 subjects for verification set
  set.seed(2022-10-12)
  verif_ids <- sample(x = ids$X1, size = 500, replace = FALSE)
  # make indicator of verification membership
  verif_indic <- ids$X1 %in% verif_ids
  val_ids <- setdiff(ids$X1, verif_ids)
  # read pheno_b.txt and cov.txt
  pheno_file <- file.path(dirpath, "02_pheno_b.txt")
  pheno_all <- readr::read_table(file = pheno_file, col_names = FALSE)
  cov_file <- file.path(dirpath, "03_cov_eff.txt")
  cov_all <- readr::read_table(file = cov_file, col_names = FALSE)
  # subset pheno_all & cov_all 
  pheno_verif <- pheno_all[ids$X1 %in% verif_ids, ]
  pheno_val <- pheno_all[!(ids$X1 %in% verif_ids), ]
  cov_verif <- cov_all[ids$X1 %in% verif_ids, ]
  cov_val <- cov_all[!(ids$X1 %in% verif_ids), ]
  # write outputs 
  val_path <- paste0("~/research/ukb-intervals/03_subsample/binary/pheno", phe_num, "/val_ukb")
  verif_path <- paste0("~/research/ukb-intervals/03_subsample/binary/pheno", phe_num, "/verif_ukb")
  dir.create(val_path, recursive = TRUE)
  dir.create(verif_path, recursive = TRUE)
  tibble::tibble(X1 = val_ids, X2 = val_ids) %>%
    dplyr::arrange(X1) %>%
    vroom::vroom_write(file = file.path(val_path, "01_idx.txt"), col_names = FALSE)
  tibble::tibble(X1 = verif_ids, X2 = verif_ids) %>%
    dplyr::arrange(X1) %>%
    vroom::vroom_write(file = file.path(verif_path, "01_idx.txt"), col_names = FALSE)
  # write 02_pheno_b.txt
  tibble::tibble(X1 = verif_ids, X2 = pheno_verif$X1) %>%
    dplyr::arrange(X1) %>%
    dplyr::select(X2) %>%
    vroom::vroom_write(file = file.path(verif_path, "02_pheno_b.txt"), col_names = FALSE)
  tibble::tibble(X1 = val_ids, X2 = pheno_val$X1) %>%
    dplyr::arrange(X1) %>%
    dplyr::select(X2) %>%
    vroom::vroom_write(file = file.path(val_path, "02_pheno_b.txt"), col_names = FALSE)
  # write 03_cov_eff.txt
  tibble::tibble(X1 = verif_ids, X2 = cov_verif$X1) %>%
    dplyr::arrange(X1) %>%
    dplyr::select(X2) %>%
    vroom::vroom_write(file = file.path(verif_path, "03_cov_eff.txt"), col_names = FALSE)
  tibble::tibble(X1 = val_ids, X2 = cov_val$X1) %>%
    dplyr::arrange(X1) %>%
    dplyr::select(X2) %>%
    vroom::vroom_write(file = file.path(val_path, "03_cov_eff.txt"), col_names = FALSE)
}
# Continuous traits
for (phe_num in 1:25){
  ## binary
  dirpath <- paste0("/net/mulan/disk2/yasheng/comparisonProject/03_subsample/continuous/pheno", phe_num, "/val/ukb")
  idx_file <- file.path(dirpath, "01_idx.txt")
  ids <- vroom::vroom(file = idx_file, col_names = FALSE)
  # sample 500 subjects for verification set
  set.seed(2022-10-12)
  verif_ids <- sample(x = ids$X1, size = 500, replace = FALSE)
  # make indicator of verification membership
  verif_indic <- ids$X1 %in% verif_ids
  val_ids <- setdiff(ids$X1, verif_ids)
  # read pheno_b.txt and cov.txt
  pheno_file <- file.path(dirpath, "02_pheno_c.txt")
  pheno_all <- readr::read_table(file = pheno_file, col_names = FALSE)
  # subset pheno_all & cov_all 
  pheno_verif <- pheno_all[ids$X1 %in% verif_ids, ]
  pheno_val <- pheno_all[!(ids$X1 %in% verif_ids), ]
  # write outputs 
  val_path <- paste0("~/research/ukb-intervals/03_subsample/continuous/pheno", phe_num, "/val/ukb")
  verif_path <- paste0("~/research/ukb-intervals/03_subsample/continuous/pheno", phe_num, "/verif/ukb")
  dir.create(val_path, recursive = TRUE)
  dir.create(verif_path, recursive = TRUE)
  tibble::tibble(X1 = val_ids, X2 = val_ids) %>%
    dplyr::arrange(X1) %>%
    vroom::vroom_write(file = file.path(val_path, "01_idx.txt"), col_names = FALSE)
  tibble::tibble(X1 = verif_ids, X2 = verif_ids) %>%
    dplyr::arrange(X1) %>%
    vroom::vroom_write(file = file.path(verif_path, "01_idx.txt"), col_names = FALSE)
  # write 02_pheno_b.txt
  tibble::tibble(X1 = verif_ids, X2 = pheno_verif$X1) %>%
    dplyr::arrange(X1) %>%
    dplyr::select(X2) %>%
    vroom::vroom_write(file = file.path(verif_path, "02_pheno_c.txt"), col_names = FALSE)
  tibble::tibble(X1 = val_ids, X2 = pheno_val$X1) %>%
    dplyr::arrange(X1) %>%
    dplyr::select(X2) %>%
    vroom::vroom_write(file = file.path(val_path, "02_pheno_c.txt"), col_names = FALSE)
}


