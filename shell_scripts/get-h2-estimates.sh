#!/bin/bash

compstr=/net/mulan/disk2/yasheng/comparisonProject/

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

    
for cross in 1 2 3 4 5; do
    array=()
    for p in `seq 1 25`; do # p is for phenotypes
        herit=${compstr}05_internal_c/pheno${p}/herit/h2_ukb_cross${cross}.log
        h2=`sed -n '26p' ${herit} | cut -d ":" -f 2 | cut -d '(' -f 1 | cut -d " " -f 2`
        array+=( ${h2} )
    done
    print_array "${array[@]}" >> h2.csv
done

