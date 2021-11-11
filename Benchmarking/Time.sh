#!/bin/bash

###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run"
#db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"
db="/home/noyes046/shared/databases/Jesse_database/Full_Sanchez_DB.fasta"


###Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh

#####
#####DO BENCHMARKING
#####
echo "Start Time Benchmarking"

#Start env with biopython (like InSilicoSeq)
conda activate InSilicoSeq


datasets=("0.5" "1" "5" "10" "15" "25" "50") #name of datasets/directories
subsets=("5" "15" "25" "35") #number of reference sequences subsampled

for j in "${subsets[@]}"
do

        for i in "${datasets[@]}"
        do
		python Time_Benchmarks.py -t $Bench/S$j/M$i/FB_Out/FB_Time.txt $Bench/S$j/M$i/GATK_Out/GATK_Time.txt $Bench/S$j/M$i/Disco_Out/Disco_Time.txt $Bench/S$j/M$i/Meta_Out/Meta_Time.txt

	done
done

#Merge the Benchmarking Datasets together!!!
python Merge_Bench.py 


