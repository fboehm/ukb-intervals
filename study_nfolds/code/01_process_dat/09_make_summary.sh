#!/bin/bash

#SBATCH --partition=mulan,main
#SBATCH --time=3-00:00:00
#SBATCH --job-name=gemma
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-38500%400
#SBATCH --output=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/gemma/08_make_summary_m_%a.out
#SBATCH --error=/net/mulan/home/fredboe/research/ukb-intervals/cluster_outputs/gemma/08_make_summary_m_%a.err


let k=0
gemma=/net/fantasia/home/borang/software/gemma-0.98.3-linux-static

#dats=(1 2)
dats=( 1 3) # continuous and binary_adj
type=ukb
nfolds=(5 10 20)
covstr=~/research/ukb-intervals/02_pheno/

for nfold in ${nfolds[@]}; do
    fbstr=~/research/ukb-intervals/study_nfolds/${nfold}-fold/
    for dat in ${dats[@]}; do
        for p in `seq 1 25`; do
            for cross in `seq 1 ${nfold}`; do
                for chr in `seq 1 22`; do
                    let k=${k}+1
                    if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
                        let col=(${p}-1)*${nfold}+${cross}
                        summ=summary_${type}_cross${cross}_chr${chr}
                        if [ ${dat} -eq 1 ]; then
                            echo continuous phenotype
                            echo column number: ${col}
                            bfile=${fbstr}plink_file/ukb/continuous/chr${chr}
                            mydir=${fbstr}05_internal_c/pheno${p}
                            mkdir -p ${mydir}
                            cd ${mydir}
                            ${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ}
                            sed -i '1d' ${fbstr}05_internal_c/pheno${p}/output/${summ}.assoc.txt
                            rm ${fbstr}05_internal_c/pheno${p}/output/${summ}.log.txt
                        if [ ${dat} -eq 2]; then
                            echo binary phenotype
                            if ((${p}==1 || ${p}==6 || ${p}==21)); then
                                cov=${covstr}08_cov_nosex.txt
                            else
                                cov=${covstr}07_cov.txt
                            fi
                            bfile=${fbstr}plink_file/ukb/binary/chr${chr}
                            mydir=${fbstr}06_internal_b/pheno${p}
                            mkdir -p ${mydir}
                            cd ${mydir}
                            ${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ} -c ${cov}
                            sed -i '1d' ${fbstr}06_internal_b/pheno${p}/output/${summ}.assoc.txt
                            rm ${fbstr}06_internal_b/pheno${p}/output/${summ}.log.txt
                        fi
                        if [${dat} -eq 3 ]; then
                            echo binary_adj phenotype
                            echo column number: ${col}
                            bfile=${fbstr}plink_file/ukb/binary_adj/chr${chr}
                            mydir=${fbstr}06_internal_b/pheno${p}
                            mkdir -p ${mydir}
                            cd ${mydir}
                            ${gemma} -bfile ${bfile} -notsnp -lm 1 -n ${col} -o ${summ}
                            sed -i '1d' ${fbstr}06_internal_b/pheno${p}/output/${summ}.assoc.txt
                            rm ${fbstr}06_internal_b/pheno${p}/output/${summ}.log.txt
                        fi
                    fi
                done
            done
        done
    done
done
