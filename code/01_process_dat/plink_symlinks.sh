# make sym links from binary plink files into the continuous dir
for chr in `seq 1 22`; do   
    mydir=~/research/ukb-intervals/plink_file/ukb/
    ln -s ${mydir}binary/chr${chr}.bed ${mydir}continuous/chr${chr}.bed
    ln -s ${mydir}binary/chr${chr}.bim ${mydir}continuous/chr${chr}.bim
    ln -s ${mydir}binary/chr${chr}.fam ${mydir}continuous/chr${chr}.fam
done
