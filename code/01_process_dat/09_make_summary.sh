#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=3-00:00:00
#SBATCH --job-name=gemma
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-220
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/08_make_summary_m_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/08_make_summary_m_%a.err


let k=0
#gemma=/net/mulan/home/yasheng/comparisonProject/program/gemma-0.98.1-linux-static
gemma=/net/fantasia/home/borang/software/gemma-0.98.3-linux-static

fbstr=~/research/ukb-intervals/
dats=(1 2)
type=ukb

for dat in ${dats[@]}; do
  if [ ${dat} -eq 1 ]; then
    let p_num=14; # waist circumference, WC. Sheng's code confirms that this is trait 14
  fi
  if [ ${dat} -eq 2 ]; then
    let p_num=24; #snoring, SN
  fi
  #for p in `seq 1 25`; do
  for p in ${p_num}; do
    for cross in 1 2 3 4 5; do
      for chr in `seq 1 22`; do
        let k=${k}+1
        if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then

        let col=(${p}-1)*5+${cross}

        summ=summary_${type}_cross${cross}_chr${chr}

        if [ ${dat} -eq 1 ]; then
          echo continuous phenotype
          bfile=${fbstr}plink_file/ukb/continuous/chr${chr}
          cd ${fbstr}05_internal_c/pheno${p}
          ${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ}
          sed -i '1d' ${fbstr}05_internal_c/pheno${p}/output/${summ}.assoc.txt
          rm ${fbstr}05_internal_c/pheno${p}/output/${summ}.log.txt
        else

          echo binary phenotype
          if ((${p}==1 || ${p}==6 || ${p}==21)); then
            cov=${fbstr}02_pheno/08_cov_nosex.txt
          else
            cov=${fbstr}02_pheno/07_cov.txt
          fi
          bfile=${fbstr}plink_file/ukb/binary/chr${chr}
          cd ${fbstr}06_internal_b/pheno${p}
          ${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ} -c ${cov}
          sed -i '1d' ${fbstr}06_internal_b/pheno${p}/output/${summ}.assoc.txt
          rm ${fbstr}06_internal_b/pheno${p}/output/${summ}.log.txt
          
          fi
          
        fi
      
      done
    done
  done
done
