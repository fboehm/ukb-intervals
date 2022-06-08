#!/bin/bash

while getopts "D:p:B:s:m:T:H:G:R:o:P:l:c:i:t:C:d:" opt; do
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
    o) outpath="$OPTARG"
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
    C) test_indicator_file="$OPTARG"
    ;;
    d) dat_str="$OPTARG"
    ;;
    # C) chr="$OPTARG"
    # ;;
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
printf "\033[33mArgument ref_geno_prefix is %s  \033[0m\n" "$ref_geno_prefix"
if [[ "${type}" == "t" ]]
then
	printf "\033[33mArgument type is %s  \033[0m\n" "$type"
	printf "\033[33mArgument val_geno_prefix is %s  \033[0m\n" "$val_geno_prefix"
	printf "\033[33mArgument valid_pheno is %s  \033[0m\n" "$val_pheno"
	printf "\033[33mArgument col is %s  \033[0m\n" "$col"
	printf "\033[33mArgument index is %s  \033[0m\n" "$index"
else
	printf "\033[33mArgument type is %s  \033[0m\n" "$type"
fi
if [ -n "$cov" ]; then 
	printf "\033[33mArgument cov is %s  \033[0m\n" "$cov"
fi
printf "\033[33mArgument thread is %s  \033[0m\n" "$thread"
printf "\033[33mArgument outpath is %s  \033[0m\n" "$outpath"
printf "\033[33mArgument test_indicator_file is %s  \033[0m\n" "$test_indicator_file"
printf "\033[33mArgument dat_str is %s  \033[0m\n" "$dat_str"


DBSLMM=${software_path}DBSLMM/software/DBSLMM.R
TUNE=${software_path}DBSLMM/software/TUNE.R
dbslmm=${software_path}/DBSLMM/scr/dbslmm

# LDSC: heritability and number of SNP
nsnp=`sed -n '24p' ${herit} | cut -d ',' -f 2 | cut -d ' ' -f 2`
h2=`sed -n '26p' ${herit} | cut -d ":" -f 2 | cut -d '(' -f 1 | cut -d " " -f 2`

# DBSLMM: tuning version
if [[ "$type" == "t" ]]
then
	#for chr in `seq 1 22`
	for chr in 22
	do

		BLOCK=${block_prefix}${chr}
		summchr=${summary_file_prefix}${chr}
		nobs=`sed -n "2p" ${summchr}.assoc.txt | awk '{print $5}'`
		nmis=`sed -n "2p" ${summchr}.assoc.txt | awk '{print $4}'`
		n=$(echo "${nobs}+${nmis}" | bc -l)
		ref_geno=${ref_geno_prefix}${chr}
		val_geno=${val_geno_prefix}${chr}
		for pth in 1e-4 1e-5 1e-6
		do
		Rscript ${DBSLMM} --summary ${summchr}.assoc.txt --outPath ${outpath} --plink ${plink} --model ${model}\
						  --dbslmm ${dbslmm} --ref ${ref_geno} --n ${n} --type ${type} --nsnp ${nsnp} --block ${BLOCK}.bed\
						   --h2 ${h2} --h2f 0.7,1,1.4 --pth ${pth} --thread ${thread} 
		for h2f in 0.7 1 1.4
		do
			summchr_prefix=`echo ${summchr##*/}`
			if [ -f "${outpath}${summchr_prefix}_h2f${h2f}_pth${pth}.dbslmm.badsnps" ];then
				rm ${outpath}${summchr_prefix}_h2f${h2f}_pth${pth}.dbslmm.badsnps
			fi
			${plink}  --silent --bfile ${val_geno} --score ${outpath}${summchr_prefix}_h2f${h2f}_pth${pth}.dbslmm.txt 1 2 4 sum\
					  --out ${outpath}${summchr_prefix}_h2f${h2f}_pth${pth}
			rm ${outpath}${summchr_prefix}_h2f${h2f}_pth${pth}.log
			if [ -f "${outpath}${summchr_prefix}_h2f${h2f}_pth${pth}.nopred" ];then
				rm ${outpath}${summchr_prefix}_h2f${h2f}_pth${pth}.nopred
			fi
		done
		done
	done

	summchr_prefix2=`echo ${summchr_prefix%_*}`
	if [[ ! -n "$cov" ]]
	then 
	Rscript ${TUNE} --phenoPred ${outpath}${summchr_prefix2} --phenoVal ${val_pheno},${col} \
		   --h2Range 0.7,1,1.4 --pthRange 1e-4,1e-5,1e-6 --index ${index}
	else 
	Rscript ${TUNE} --phenoPred ${outpath}${summchr_prefix2} --phenoVal ${val_pheno},${col} \
		   --h2Range 0.7,1,1.4 --pthRange 1e-4,1e-5,1e-6 --index ${index} --cov ${cov}
	fi

	hbest=`cat ${outpath}${summchr_prefix2}_hbest.${index}`
	pbest=`cat ${outpath}${summchr_prefix2}_pbest.${index}`
	for chr in `seq 1 22`
	do
		mv ${outpath}${summchr_prefix2}_chr${chr}_h2f${hbest}_pth${pbest}.dbslmm.txt ${outpath}${summchr_prefix2}_chr${chr}_best.dbslmm.txt
		rm ${outpath}${summchr_prefix2}_chr${chr}_h2f*_pth*
	done

fi

## DBSLMM automatic version
if [[ "$type" == "auto" ]]
then
#for chr in `seq 1 22` 
for chr in 22
do
	BLOCK=${block_prefix}${chr}
	summchr=${summary_file_prefix}${chr}
	ref_geno=${ref_geno_prefix}${chr}
	val_geno=${val_geno_prefix}${chr}
	summchr=${summary_file_prefix}${chr}
	nobs=`sed -n "2p" ${summchr}.assoc.txt | awk '{print $5}'`
	nmis=`sed -n "2p" ${summchr}.assoc.txt | awk '{print $4}'`
	n=$(echo "${nobs}+${nmis}" | bc -l)
	echo ${model}
	var_outfile=${outpath}${summchr_prefix2}_variance_chr${chr}.txt
if [ ! -f ${var_outfile} ]; then
	
	Rscript ${DBSLMM} --summary ${summchr}.assoc.txt --outPath ${outpath} --plink ${plink} --model ${model}\
					  --dbslmm ${dbslmm} --ref ${ref_geno} --n ${n} --nsnp ${nsnp} --block ${BLOCK}.bed\
					  --h2 ${h2} --thread ${thread}\
					  --test_indicator_file ${test_indicator_file} \
					  --dat_str ${dat_str}${chr}
	#				  --val ${val_geno}
	summchr_prefix=`echo ${summchr##*/}`
	summchr_prefix2=`echo ${summchr_prefix%_*}`
	mv ${outpath}${summchr_prefix2}_chr${chr}.dbslmm.txt ${outpath}${summchr_prefix2}_chr${chr}_auto.dbslmm.txt
	#rm ${outpath}${summchr_prefix}.dbslmm.badsnps
	mv variance.txt ${var_outfile}
fi

done
fi