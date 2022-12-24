# we need to write sym links for the 
# plink files created by 05a_get_subsample.sh

trait_types=(binary continuous)
nfolds=(10 20)

let k=0
# every fold value has the same validation set, so 
# only need to do subsetting for a single fold value, 
# then sym link to results
for nfold in ${nfolds[@]}; do
    compStr=~/research/ukb-intervals/study_nfolds/${nfold}-fold/
    for trait_type in ${trait_types[@]}; do
        for chr in `seq 1 22`;do
            for p in `seq 1 25`; do
                # remove old file if it's there
                mydir=${compStr}03_subsample/${trait_type}/pheno${p}/val/
                bdir=${mydir}ukb/geno/
                mkdir -p ${bdir}
                bfileSubP=${bdir}chr${chr}
                #if [ -f "${bfileSubP}.fam" ]; then
                    rm -f ${bfileSubP}.*
                #fi   
                odir=${mydir}impute/ 
                mkdir -p ${odir}
                output=${odir}chr${chr}
                #if [ -f "${output}.fam" ]; then
                    rm -f ${output}.*
                #fi
                # make sym links
                ln -s ~/research/ukb-intervals/study_nfolds/5-fold/03_subsample/${trait_type}/pheno${p}/val/ukb/geno/chr${chr}.bed ${bfileSubP}.bed
                ln -s ~/research/ukb-intervals/study_nfolds/5-fold/03_subsample/${trait_type}/pheno${p}/val/ukb/geno/chr${chr}.bim ${bfileSubP}.bim
                ln -s ~/research/ukb-intervals/study_nfolds/5-fold/03_subsample/${trait_type}/pheno${p}/val/ukb/geno/chr${chr}.fam ${bfileSubP}.fam
                # imput sym links
                ln -s ~/research/ukb-intervals/study_nfolds/5-fold/03_subsample/${trait_type}/pheno${p}/val/impute/chr${chr}.bed ${output}.bed
                ln -s ~/research/ukb-intervals/study_nfolds/5-fold/03_subsample/${trait_type}/pheno${p}/val/impute/chr${chr}.bim ${output}.bim
                ln -s ~/research/ukb-intervals/study_nfolds/5-fold/03_subsample/${trait_type}/pheno${p}/val/impute/chr${chr}.fam ${output}.fam
            done
        done
    done
done