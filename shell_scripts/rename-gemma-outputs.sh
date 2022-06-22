
gemma_output_dir=~/research/ukb-intervals/dat/simulations-ding/gemma/output
for chr in `seq 1 22`; do
  for pheno in `seq 1 10`; do
    for fold in `seq 1 5`; do
      mv ${gemma_output_dir}/summary_ukb_chr${chr}_pheno${pheno}_fold${fold}.assoc.txt ${gemma_output_dir}/summary_ukb_pheno${pheno}_fold${fold}_chr${chr}.assoc.txt 
    done
  done
done
      
      
      