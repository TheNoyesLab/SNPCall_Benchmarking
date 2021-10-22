#!/bin/bash


###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking"
db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"


###Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#Datasets to loop through (read count)
datasets=("0.5" "1" "5" "10" "15" "25" "50")


#Start metasnv environment
conda activate metasnv


for i in "${datasets[@]}"
do
metaSNV.py $Bench/Benchmarking_Run/M${i}/Meta_Out \
        $Bench/Benchmarking_Run/M${i}/meta_sample_list.txt \
        $db --threads 64


cat $Bench/Benchmarking_Run/M${i}/Meta_Out/snpCaller/called_SNPs.best_split_* | sed -n -e 's/[0-9][0-9]*|//g; /[ACTG]/ s/|.*//p' > $Bench/Benchmarking_Run/M${i}/Meta_Out/Meta_Out_Fix.csv

done
