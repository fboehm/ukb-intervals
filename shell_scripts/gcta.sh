#!/bin/bash


#SBATCH --partition=mulan,nomosix
#SBATCH --time=18:00:00
#SBATCH --job-name=gcta
#SBATCH --mem=32G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-5
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/gcta_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/gcta_%a.err
#SBATCH --mail-user=fredboe@umich.edu  
#SBATCH --mail-type=ALL

bash
let k=0

for pc in 0.001 0.01 1 0.1 0.1; do
  let k=${k}+1
  
  if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
    hsq=0.2
    if [ ${k} -eq 4 ]; then
      hsq=0.1
    fi
    if [ ${k} -eq 5 ]; then
      hsq=0.5
    fi
    
    
    gcta64 --bfile ../dat/simulations-ding/chr22 \
            --simu-qt \
            --simu-causal-loci ../dat/simulations-ding/snp_effects_Chr22_hsq${hsq}_pcausal${pc}.txt \
            --simu-hsq ${hsq} \
            --simu-rep 10 \
            --out ../dat/simulations-ding/sim_traits/sims_Chr22_hsq${hsq}_pcausal${pc}
            
  fi
done
