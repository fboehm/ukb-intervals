#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
(trait <- args[1])

rmarkdown::render(here::here("Rmd2", "cv-plus.Rmd"), 
                params = list(traits = trait),
                output_file = paste0("/net/mulan/disk2/fredboe/research/ukb-intervals/Rmd2/binary", trait, ".html"))