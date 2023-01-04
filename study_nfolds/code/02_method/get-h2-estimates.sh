#!/bin/bash


nfolds=(5 10 20)
trait_types=(continuous binary)
echo ${trait_type}

print_array ()
{
  # run through array and print each entry:
  local array
  array=("$@")
  for i in "${array[@]}" ; do
      printf '%s,' "$i"
  done
  # print a new line
  printf '\n'
}

for trait_type in ${trait_types[@]}; do
    for nfold in ${nfolds[@]}; do
        fbstr=~/research/ukb-intervals/study_nfolds/${nfold}-fold/
        for cross in `seq 1 ${nfold}`; do
            array=()
            for p in `seq 1 25`; do # p is for phenotypes
                if [ "${trait_type}" == "continuous" ]; then 
                    herit=${fbstr}05_internal_c/pheno${p}/herit/h2_ukb_cross${cross}.log
                    outfile=${fbstr}05_internal_c/pheno${p}/herit/h2.csv
                else 
                    herit=${fbstr}06_internal_b/pheno${p}/herit/h2_ukb_cross${cross}.log
                    outfile=${fbstr}06_internal_b/pheno${p}/herit/h2.csv
                fi 

                echo ${herit}
                h2=`sed -n '26p' ${herit} | cut -d ":" -f 2 | cut -d '(' -f 1 | cut -d " " -f 2`
                array+=( ${h2} )
            done
            print_array "${array[@]}" >> $outfile
        done
    done
done
