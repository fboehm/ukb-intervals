#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=3-00:00:00
#SBATCH --job-name=cvplus
#SBATCH --mem=16G
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/render-rmd_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/render-rmd_%a.err

Rscript -e 'rmarkdown::render(input = "~/research/ukb-intervals/Rmd/cv-plus.Rmd")'
