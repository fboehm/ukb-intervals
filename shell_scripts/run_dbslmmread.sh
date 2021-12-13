#!/bin/bash


#SBATCH --partition=mulan,nomosix
#SBATCH --time=24:00:00
#SBATCH --job-name=DBSLMM
#SBATCH --mem=256G
#SBATCH --cpus-per-task=1
#SBATCH --array=1
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/run_dbslmmread_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/run_dbslmmread_%a.err
#SBATCH --mail-user=fredboe@umich.edu  
#SBATCH --mail-type=ALL



# GOAL: Run dbslmmread on the two binary Armadillo files for Chr 1
bash 

cd ../dat/corr_mats_files
~/research/DBSLMMread/bin/dbslmmread -h 0.5 -nsnp 100000 

