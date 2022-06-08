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

gcta64 --bfile ../dat/simulations-ding/chr22 --simu-qt --simu-causal-loci ../dat/simulations-ding/snp_effects_Chr22_hsq0.2_pcausal0.1.txt --simu-hsq 0.2 --simu-rep 10 --out ../dat/simulations-ding/sim_traits/sims_Chr22_hsq0.2_pcausal0.1

gcta64 --bfile ../dat/simulations-ding/chr22 --simu-qt --simu-causal-loci ../dat/simulations-ding/snp_effects_Chr22_hsq0.1_pcausal0.1.txt --simu-hsq 0.1 --simu-rep 10 --out ../dat/simulations/sim_traits/sims_Chr22_hsq0.1_pcausal0.1

gcta64 --bfile ../dat/simulations-ding/chr22 --simu-qt --simu-causal-loci ../dat/simulations-ding/snp_effects_Chr22_hsq0.5_pcausal0.1.txt --simu-hsq 0.5 --simu-rep 10 --out ../dat/simulations/sim_traits/sims_Chr22_hsq0.5_pcausal0.1
