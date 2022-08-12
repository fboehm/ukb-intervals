#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=3-00:00:00
#SBATCH --job-name=cvplus
#SBATCH --mem=16G
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/render-rmd_%j_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/render-rmd_%j_%a.err

Rscript -e 'rmarkdown::render(input = "~/research/ukb-intervals/Rmd/cv-plus-simulations.Rmd",
                              output_file = "~/research/ukb-intervals/Rmd/cv-plus-simulations-alpha0.1-hsq0.2-pcausal0.1",
                              params = list(hsq=0.2, pcausal=0.1))'
