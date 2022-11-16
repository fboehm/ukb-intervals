#!/bin/bash


#SBATCH --partition=mulan,main
#SBATCH --time=8:00:00
#SBATCH --job-name=cvplus
#SBATCH --mem=16G
#SBATCH --cpus-per-task=1
#SBATCH --array=1
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/cvplus_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/cvplus_%a.err
#SBATCH --mail-user=fredboe@umich.edu  
#SBATCH --mail-type=ALL

Rscript -e "rmarkdown::render('~/research/ukb-intervals/Rmd2/cv-plus.Rmd', output_file = 'cv-plus-binary.html')"
