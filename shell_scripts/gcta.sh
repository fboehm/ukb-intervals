#!/bin/bash


#SBATCH --partition=mulan,nomosix
#SBATCH --time=8:00:00
#SBATCH --job-name=gcta
#SBATCH --mem=32G
#SBATCH --cpus-per-task=1
#SBATCH --array=1
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/gcta_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/gcta_%a.err
#SBATCH --mail-user=fredboe@umich.edu  
#SBATCH --mail-type=ALL

Rscript -e "rmarkdown::render('~/research/ukb-intervals/Rmd/simulating-traits-with-GCTA-chr22.Rmd')"
