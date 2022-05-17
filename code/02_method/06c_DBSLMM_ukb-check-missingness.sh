#!/bin/bash

#SBATCH --partition=mulan,nomosix
#SBATCH --time=1:00:00
#SBATCH --job-name=DBSLMM
#SBATCH --mem=32G
#SBATCH --cpus-per-task=1
#SBATCH --array=1
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/06c_DBSLMM_ukb_c_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/06c_DBSLMM_ukb_c_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fredboe@umich.edu




infile=/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/chr22
outfile=~/research/ukb-intervals/dat/plink_files2/chr22

# make symbolic links for bim and bed
#ln -s ${infile}.bed ${outfile}.bed
#ln -s ${infile}.bim ${outfile}.bim



tr -s ' ' ${infile}.fam | cut -d ' ' -f 1-5,12 > ${outfile}.fam


plink --bfile ${outfile} --missing

