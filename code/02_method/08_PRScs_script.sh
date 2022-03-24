#!/bin/bash

while getopts "P:s:r:v:p:c:o:f:h:I:" opt; do
  case $opt in
    P) software_path="$OPTARG"
    ;;
    s) summary_file_prefix="$OPTARG"
    ;;
    r) ref_geno="$OPTARG"
    ;;
    v) val_geno_prefix="$OPTARG"
    ;;
    p) val_pheno="$OPTARG"
    ;;
    c) cov="$OPTARG"
    ;;
    o) outfile="$OPTARG"
    ;;
    f) predfile="$OPTARG"
    ;;
    h) chr="$OPTARG"
    ;;
    I) PHI="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# check files
printf "\033[33mArgument software_path is %s  \033[0m\n" "$software_path"
printf "\033[33mArgument summary_file_prefix is %s  \033[0m\n" "$summary_file_prefix"
printf "\033[33mArgument ref_geno is %s  \033[0m\n" "$ref_geno"
printf "\033[33mArgument val_geno_prefix is %s  \033[0m\n" "$val_geno_prefix"
printf "\033[33mArgument val_pheno is %s  \033[0m\n" "$val_pheno"
if [ -n "$cov" ]; then 
    printf "\033[33mArgument cov is %s  \033[0m\n" "$cov"
fi
printf "\033[33mArgument outfile is %s  \033[0m\n" "$outfile"
printf "\033[33mArgument predfile is %s  \033[0m\n" "$predfile"
printf "\033[33mArgument chr is %s  \033[0m\n" "$chr"
printf "\033[33mArgument PHI is %s  \033[0m\n" "$PHI"

# set program
PRScs=${software_path}/PRScs.py
SEL=${software_path}/selectPHI.R

# set parameter
outpath=`echo ${outfile%/*}/`

# PRScs
# for chr in `seq 1 22`
# do
    ## set parameter
    bimStr=/net/mulan/disk2/yasheng/comparisonProject/04_reference/hm3/geno/chr${chr}
    awk '{print $2,$6,$7,$9,$11}' ${summary_file_prefix}${chr}.assoc.txt > ${summary_file_prefix}${chr}_phi${PHI}.prscs
    sed -i '1i\SNP A1 A2 BETA P' ${summary_file_prefix}${chr}_phi${PHI}.prscs
    nobs=`sed -n "2p" ${summary_file_prefix}${chr}.assoc.txt | awk '{print $5}'`
    nmis=`sed -n "2p" ${summary_file_prefix}${chr}.assoc.txt | awk '{print $4}'`
    n=$(echo "${nobs}+${nmis}" | bc -l)
    source activate /net/mulan/home/yasheng/py3/envs/py37
    echo py37 is activated.
    ## auto model
    if [[ "$PHI" == "auto" ]]
    then
    python3 ${PRScs} --ref_dir=${ref_geno} --bim_prefix=${bimStr} --sst_file=${summary_file_prefix}${chr}_phi${PHI}.prscs \
                     --n_gwas=${n} --chrom=${chr} --out_dir=${outpath} #\
                     # --n_iter=10 --n_burnin=5
    mv ${outpath}_pst_eff_a1_b0.5_phiauto_chr${chr}.txt ${outfile}${chr}_auto.txt 
    echo PRSCS-auto is done.
    else
    ## tuning model
    ### set four phi
    # for PHI in 1e-06 1e-04 1e-02 1e+00;do
        python3 ${PRScs} --ref_dir=${ref_geno} --bim_prefix=${bimStr} --sst_file=${summary_file_prefix}${chr}_phi${PHI}.prscs \
                         --n_gwas=${n} --chrom=${chr} --out_dir=${outpath} --phi ${PHI} #\
                         # --n_iter=10 --n_burnin=5
        mv ${outpath}_pst_eff_a1_b0.5_phi${PHI}_chr${chr}.txt ${outfile}${chr}_phi${PHI}.txt 
        echo PRSCS-phi${PHI} is done.
		rm ${summary_file_prefix}${chr}_phi${PHI}.prscs
		plink-1.9 --silent --bfile ${val_geno_prefix} --score ${outfile}${chr}_phi${PHI}.txt 2 4 6 sum --out ${predfile}${chr}_phi${PHI}
    # done
    fi
	# source deactivate
# done

# ### select phi
# if [[ -n "$cov" ]]; then
    # Rscript ${SEL} --esteff ${outfile} --predfile ${predfile} --valgeno ${val_geno_prefix} --valpheno ${val_pheno}
# else
    # Rscript ${SEL} --esteff ${outfile} --predfile ${predfile} --valgeno ${val_geno_prefix} --valpheno ${val_pheno} --cov ${cov}
# fi
# echo PRSCS-tuning is done.
