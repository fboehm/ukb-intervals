#!/bin/bash


#SBATCH --partition=mulan,main
#SBATCH --time=8:00:00
#SBATCH --job-name=cvplus
#SBATCH --mem=16G
#SBATCH --cpus-per-task=1
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/cvplus_binary_%j.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/cvplus_binary_%j.err

Rscript -e "rmarkdown::render('~/research/ukb-intervals/Rmd2/cv-plus.Rmd',
                              params = list(trait_type = 'continuous'),
                              output_file = 'cv-plus-continuous.html')"
