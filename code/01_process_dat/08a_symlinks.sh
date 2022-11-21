sheng_path=/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/
fred_path=~/research/ukb-intervals/plink_file/ukb/

for chr in `seq 1 22`; do
    ln -s ${sheng_path}chr${chr}.bed ${fred_path}binary/chr${chr}.bed
    ln -s ${sheng_path}chr${chr}.bim ${fred_path}binary/chr${chr}.bim
    ln -s ${sheng_path}chr${chr}.bed ${fred_path}continuous/chr${chr}.bed
    ln -s ${sheng_path}chr${chr}.bim ${fred_path}continuous/chr${chr}.bim
    if [ ${chr} != 1 ]; then 
        ln -s ${fred_path}binary/chr1.fam ${fred_path}binary/chr${chr}.fam
        ln -s ${fred_path}continuous/chr1.fam ${fred_path}continuous/chr${chr}.fam
    fi
done
