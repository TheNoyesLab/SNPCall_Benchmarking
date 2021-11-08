#!/bin/bash


###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run"
db="/home/noyes046/shared/databases/Jesse_database/Full_Sanchez_DB.fasta"


###Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#Datasets to loop through (read count)
datasets=("0.5" "1" "5" "10" "15" "25" "50")
subsets=("5" "15" "25" "35") #number of reference sequences subsampled




#####
#####START METASNV
#####
echo "Start MetaSNV"

#Start metasnv environment
conda activate metasnv

for j in "${subsets[@]}"
do
        sub_db="$Bench/SNP_Injector/DB_noSNP_subset${j}.fasta"

        for i in "${datasets[@]}"
        do
                /usr/bin/time -v -o $Bench/S$j/M$i/Meta_Time.txt metaSNV.py $Bench/S$j/M$i/Meta_Out \
                        $Bench/S$j/M$i/meta_sample_list.txt \
                        $sub_db --threads 32

                mv $Bench/S$j/M$i/Meta_Time.txt $Bench/S$j/M$i/Meta_Out/Meta_Time.txt #Move from M$i to M$i/Meta_Out because Meta_Out didn't exist
                cat $Bench/S$j/M$i/Meta_Out/snpCaller/called_SNPs.best_split_* | sed -n -e 's/[0-9][0-9]*|//g; /[ACTG]/ s/|.*//p' > $Bench/S$j/M$i/Meta_Out/Meta_Out_Fix.csv #Fix to look like normal csv

        done
done





