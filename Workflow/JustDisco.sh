#!/bin/bash


###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking"
db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"


###Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#Datasets to loop through (read count)
datasets=("1")



#####
#####START DISCOSNP
#####
echo "Start DiscoSNP"

#Start DiscoSNP environment
conda activate DiscoSNP

for i in "${datasets[@]}"
do
/usr/bin/time -v -o $Bench/Benchmarking_Run/M${i}/Disco_Out/Disco_Time.txt run_discoSnp++.sh -r $Bench/Benchmarking_Run/M${i}/Fastqlist_Disco.txt \
        -G $db\
        --bwa_path ~/.conda/envs/DiscoSNP/bin/ -p Disco_Out -u 64
mv $Bench/SNPCall_Benchmarking/Workflow/Disco_Out*  $Bench/Benchmarking_Run/M${i}/Disco_Out/

cat $Bench/Benchmarking_Run/M${i}/Disco_Out/Disco_Time.txt 
done


