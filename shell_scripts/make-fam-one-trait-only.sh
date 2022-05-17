

infile="/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/chr22.fam"
outfile="~/research/ukb-intervals/dat/plink_files2/chr22.fam"
tr -s ' ' infile | cut -d ' ' -f 1-6 > outfile


