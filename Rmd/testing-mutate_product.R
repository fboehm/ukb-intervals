tr_indic <- tibble::tibble(fold1_na = c(NA, 1, NA))

tibble::tibble(V1 = c(1,2,3), V2 = c(4:6)) %>%
  mutate_product(fold_num = 1, trait_num = 1:2)
# result has column names with L in them!