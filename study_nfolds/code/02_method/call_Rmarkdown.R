aa <- commandArgs(trailingOnly = TRUE)
(trait_type <- aa[1])
(nfold <- as.numeric(aa[2]))
(trait_number <- as.numeric(aa[3]))
(output_dir <- aa[4])

rmarkdown::render(input = "cv-plus.Rmd", output_dir = output_dir, 
                params = list(trait_type = trait_type, nfold = nfold, trait_number = trait_number))
                



