#!/bin/bash

while getopts "D:p:B:s:m:T:H:G:R:o:P:l:c:i:t:r:z:q:" opt; do
  case $opt in
    D) software_path="$OPTARG"
    ;;
    p) plink="$OPTARG"
    ;;
    B) block_prefix="$OPTARG"
    ;;
    s) summary_file_prefix="$OPTARG"
    ;;
    m) model="$OPTARG"
    ;;
    T) type="$OPTARG"
    ;;
    H) herit="$OPTARG"
    ;;
    G) val_geno_prefix="$OPTARG"
    ;;
    R) ref_geno_prefix="$OPTARG"
    ;;
    o) outPath="$OPTARG"
    ;;
    P) val_pheno="$OPTARG"
    ;;
    l) col="$OPTARG"
    ;;
    c) cov="$OPTARG"
    ;;
    i) index="$OPTARG"
    ;;
    t) thread="$OPTARG"
    ;;
    z) test_indices_file="$OPTARG"
    ;;
    q) training_indices_file="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

printf "\033[33mArgument software_path is %s  \033[0m\n" "$software_path"
printf "\033[33mArgument plink is %s  \033[0m\n" "$plink"
printf "\033[33mArgument block_prefix is %s  \033[0m\n" "$block_prefix"
printf "\033[33mArgument summary_file_prefix is %s  \033[0m\n" "$summary_file_prefix"
printf "\033[33mArgument model is %s  \033[0m\n" "$model"
printf "\033[33mArgument herit is %s  \033[0m\n" "$herit"
printf "\033[33mArgument val_geno_prefix is %s  \033[0m\n" "$val_geno_prefix"
printf "\033[33mArgument ref_geno_prefix is %s  \033[0m\n" "$ref_geno_prefix"
printf "\033[33mArgument type is %s  \033[0m\n" "$type"
if [[ "${type}" == "t" ]]
then
	printf "\033[33mArgument valid_pheno is %s  \033[0m\n" "$val_pheno"
	printf "\033[33mArgument col is %s  \033[0m\n" "$col"
	printf "\033[33mArgument index is %s  \033[0m\n" "$index"
fi
if [ -n "$cov" ]; then 
	printf "\033[33mArgument cov is %s  \033[0m\n" "$cov"
fi
printf "\033[33mArgument thread is %s  \033[0m\n" "$thread"
printf "\033[33mArgument outPath is %s  \033[0m\n" "$outPath"

DBSLMM=${software_path}DBSLMM/software/DBSLMM.R
TUNE=${software_path}DBSLMM/software/TUNE.R
dbslmm=${software_path}/DBSLMM/scr/dbslmm

# LDSC: heritability and number of SNP
nsnp=704126
h2=0.5
#nsnp=`sed -n '24p' ${herit} | cut -d ',' -f 2 | cut -d ' ' -f 2`
#h2=`sed -n '26p' ${herit} | cut -d ":" -f 2 | cut -d '(' -f 1 | cut -d " " -f 2`


## DBSLMM default version
if [[ "$type" == "d" ]]
then
#for chr in `seq 1 22` 
for chr in 1
do
	BLOCK=${block_prefix}${chr}
	summchr=${summary_file_prefix}${chr}
	val_geno=${val_geno_prefix}${chr}
	summchr=${summary_file_prefix}${chr}
	nobs=`sed -n "2p" ${summchr}.assoc.txt | awk '{print $5}'`
	nmis=`sed -n "2p" ${summchr}.assoc.txt | awk '{print $4}'`
	n=$(echo "${nobs}+${nmis}" | bc -l)
	echo ${n}
	echo ${model}
	Rscript ${DBSLMM} --summary ${summchr}.assoc.txt --outPath ${outPath} --plink ${plink} --model ${model}\
					  --dbslmm ${dbslmm} --ref ${val_geno} --n ${n} --nsnp ${nsnp} --block ${BLOCK}.bed\
					  --h2 ${h2} --thread ${thread} \
					  --test_indices_file ~/research/ukb-intervals/Rmd/test_indices.txt \
					  --training_indices_file ~/research/ukb-intervals/Rmd/training_indices.txt
	summchr_prefix=`echo ${summchr##*/}`
	#mv corr_mats.bin ~/research/ukb-intervals/dat/corr_mats_files/pheno1_chr${chr}_test_corr_mats.bin
	#rm ${outpath}${summchr_prefix}.dbslmm.badsnps

done
fi
