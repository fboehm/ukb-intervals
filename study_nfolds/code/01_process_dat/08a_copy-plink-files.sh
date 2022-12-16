
sheng_path=/net/mulan/disk2/yasheng/predictionProject/plink_file/ukb/
fred_path=~/research/ukb-intervals/plink_file/ukb/binary/
for chr in `seq 1 22`; do
    if [ ${chr} != 9 ]; then
        cp ${sheng_path}chr${chr}.bed ${fred_path}chr${chr}.bed
        cp ${sheng_path}chr${chr}.bim ${fred_path}chr${chr}.bim
        cp ${sheng_path}chr${chr}.fam ${fred_path}chr${chr}.fam
    fi
done
