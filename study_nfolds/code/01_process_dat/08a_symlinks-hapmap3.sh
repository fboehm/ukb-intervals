orig_path=~/research/ukb-intervals/hapmap3/ # original plink file path

nfolds=(5 10 20)

for nfold in ${nfolds[@]}; do
    fred_path=~/research/ukb-intervals/study_nfolds/${nfold}-fold/plink_file/ukb-hapmap3/
    fam_path=~/research/ukb-intervals/study_nfolds/${nfold}-fold/plink_file/ukb/
    mkdir -p ${fred_path}binary_adj
    mkdir -p ${fred_path}continuous
    for chr in `seq 1 22`; do
        ln -s ${orig_path}chr${chr}.bed ${fred_path}binary_adj/chr${chr}.bed
        ln -s ${orig_path}chr${chr}.bim ${fred_path}binary_adj/chr${chr}.bim
        ln -s ${orig_path}chr${chr}.bed ${fred_path}continuous/chr${chr}.bed
        ln -s ${orig_path}chr${chr}.bim ${fred_path}continuous/chr${chr}.bim
        ln -s ${fam_path}binary_adj/chr1.fam ${fred_path}binary_adj/chr${chr}.fam
        ln -s ${fam_path}continuous/chr1.fam ${fred_path}continuous/chr${chr}.fam
    done
done
