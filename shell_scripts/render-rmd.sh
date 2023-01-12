#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=3-00:00:00
#SBATCH --job-name=coverage
#SBATCH --mem=16G
#SBATCH --output=/net/mulan/disk2/fredboe/research/ukb-intervals/cluster_outputs/render-rmd.out
#SBATCH --error=/net/mulan/disk2/fredboe/research/ukb-intervals/cluster_outputs/render-rmd.err

Rscript -e 'rmarkdown::render(input = "/net/mulan/disk2/fredboe/research/ukb-intervals/Rmd/calculating-coverage-ukb.Rmd")'
