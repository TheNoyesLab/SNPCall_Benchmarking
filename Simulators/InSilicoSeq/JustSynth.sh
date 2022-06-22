#!/bin/bash


#####Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#####Script to create directory structure

###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run"
#db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"
db="/home/noyes046/shared/databases/Jesse_database/Full_Sanchez_DB.fasta"


datasets=("0.5" "1") #name of datasets/directories
subsets=("5" "15" "25" "35") #number of reference sequences subsampled



conda activate InSilicoSeq

###Start SNP_Injector
#echo "Start SNP_Injector"
#python SNP_Injector_Fasta.py -s 2 -r $db


###Start InSilicoSeq
echo "Start InSilicoSeq"

for j in "${subsets[@]}"
do
	for i in "${datasets[@]}"
	do
		iss generate --genomes "$Bench/SNP_Injector/DB_subset${j}.fasta" -n ${i}m --cpus 16 --model miseq --output $Bench/S${j}/M${i}/Sim${i}_reads
	done
done


