#!/bin/bash


#####Start conda
. /home/noyes046/elder099/anaconda3/etc/profile.d/conda.sh


#####Script to create directory structure

###Shortcut variables
Bench="/home/noyes046/shared/projects/SNP_Call_Benchmarking/Benchmarking_Run"
#db="/home/noyes046/shared/databases/Jesse_database/Jesse_full_db.fasta"
db="/home/noyes046/shared/databases/Jesse_database/Full_Sanchez_DB.fasta"



mkdir "$Bench"
mkdir "$Bench/SNP_Injector"


datasets=("0.5" "1" "5" "10" "15" "25" "50") #name of datasets/directories
subsets=("5" "15" "25" "35") #number of reference sequences subsampled

for j in "${subsets[@]}"
do
	echo "$j"
	mkdir "$Bench/S$j" #Make subset directories

	for i in "${datasets[@]}"
	do
		echo "$i"
		mkdir "$Bench/S$j/M$i"  #Make dataset directories
		mkdir "$Bench/S$j/M$i/Alignment"
		mkdir "$Bench/S$j/M$i/Disco_Out"
		mkdir "$Bench/S$j/M$i/Freq_Out"
		mkdir "$Bench/S$j/M$i/GATK_Out"
        	mkdir "$Bench/S$j/M$i/FB_Out"
        	mkdir "$Bench/S$j/M$i/Samtools_Out"
        	mkdir "$Bench/S$j/M$i/VarDict_Out"
        	mkdir "$Bench/S$j/M$i/Ebwt_Out"
        	mkdir "$Bench/S$j/M$i/VarScan_Out"
        	mkdir "$Bench/S$j/M$i/MIDAS_Out"


		printf "$Bench/S$j/M$i/Sim${i}_reads_R1.fastq\n$Bench/S$j/M$i/Sim${i}_reads_R2.fastq" > $Bench/S$j/M$i/Fastqlist_Disco.txt 
		printf "$Bench/S$j/M$i/Alignment/Sim${i}_Ref_sorted.bam" > $Bench/S$j/M$i/meta_sample_list.txt
		printf "Ecoli	$Bench/S$j/M$i/Sim${i}_reads_R1.fastq	$Bench/S$j/M$i/Sim${i}_reads_R2.fastq" > $Bench/S$j/M$i/Fastqlist_Bact.txt
	done
done





conda activate InSilicoSeq

###Start SNP_Injector
echo "Start SNP_Injector"
python SNP_Injector_Fasta.py -s 2 -r $db


