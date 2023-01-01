# GOAL: create sym links to the validation plink files for the 5-fold analysis
# ie, we have the 5-fold plink files for validation sets for all traits. Now, 
# we want to create symbolic links for use with 10- and 20-fold analyses.

nfolds=(10 20)
trait_types=(continuous binary)
fbstr=~/research/ukb-intervals/
for nfold in ${nfolds[@]}; do
    for trait_type in ${trait_types[@]}; do
        for p in `seq 1 25`; do
            for chr in `seq 1 22`; do
                ffdir=${fbstr}study_nfolds/5-fold/03_subsample/${trait_type}/pheno${p}/val/hm3/geno/
                newdir=${fbstr}study_nfolds/${nfold}-fold/03_subsample/${trait_type}/pheno${p}/val/hm3/geno/
                mkdir -p ${newdir}
                ln -s ${ffdir}chr${chr}.bed ${newdir}chr${chr}.bed
                ln -s ${ffdir}chr${chr}.bim ${newdir}chr${chr}.bim
                ln -s ${ffdir}chr${chr}.fam ${newdir}chr${chr}.fam
            done
        done
    done
done
