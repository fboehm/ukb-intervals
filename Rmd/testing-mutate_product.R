library(magrittr)

mutate_product <- function(data, trait_num, fold_num){
  for (trait in seq_along(trait_num)){
    for (fold in seq_along(fold_num)){
      trait_col_indic <- paste0("fold", fold, "_na")
      trait_col <- paste0("V", trait)
      data <- data %>%
        dplyr::mutate(
          "tr{{trait}}_fold{{fold}}" := .data[[trait_col]] * tr_indic[[trait_col_indic]]
        ) %>%
        dplyr::rename_with(.fn = function(x)stringr::str_remove_all(x, pattern = "L"))
    }
  }
  return(data)
}




tr_indic <- tibble::tibble(fold1_na = c(NA, 1, NA))

tibble::tibble(V1 = c(1,2,3), V2 = c(4:6)) %>%
  mutate_product(fold_num = 1, trait_num = 1:2)
# result has column names with L in them!