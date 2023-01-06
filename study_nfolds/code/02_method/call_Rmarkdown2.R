aa <- commandArgs(trailingOnly = TRUE)
(trait_type <- aa[1])
(nfold <- as.numeric(aa[2]))
(output_dir <- aa[3])

rmarkdown::render(input = "~/research/ukb-intervals/study_nfolds/code/02_method/cv-plus-all.Rmd", 
                    output_dir = output_dir,
                    params = list(trait_type = trait_type, nfold = nfold))




